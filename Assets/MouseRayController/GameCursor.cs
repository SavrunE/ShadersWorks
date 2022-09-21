using UnityEngine;
using System.Collections;

public class GameCursor : MonoBehaviour {

	public Texture2D cursorNormal;
	public Texture2D cursorEnemy;
	public Texture2D cursorInfo;
	public int size = 30; // размер курсора по ширине и высоте
	public enum ProjectMode {Project3D = 0, Project2D = 1};
	public ProjectMode mode = ProjectMode.Project3D;
	private Vector2 offset;
	private Texture2D cursor;

	void Awake () 
	{
		Cursor.visible = false; // скрываем системный курсор
		if(mode == ProjectMode.Project2D) Camera.main.orthographic = true; // для RaycastHit2D, камера должна быть в ортогональном режиме
	}

	void MainCursor(string tags)
	{
		if(tags == "Enemy" || tags == "Target")
		{
			offset = new Vector2(-size/2, -size/2); // смещение к центру
			cursor = cursorEnemy;
		}
		else if(tags == "Info")
		{
			offset = new Vector2(-size/2, -size/1.2f);
			cursor = cursorInfo;
		}
		else // курсор по умолчанию
		{
			offset = Vector2.zero;
			cursor = cursorNormal;
		}
	}

	void Update () 
	{
		if(mode == ProjectMode.Project3D)
		{
			RaycastHit hit;
			Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
			if (Physics.Raycast(ray, out hit))
			{
				MainCursor(hit.transform.tag);
			}
			else // если луч никуда не попадет
			{
				offset = Vector2.zero;
				cursor = cursorNormal;
			}
		}
		else
		{
			RaycastHit2D hit = Physics2D.Raycast(Camera.main.ScreenToWorldPoint(Input.mousePosition), Vector2.zero);
			if(hit.transform != null)
			{
				MainCursor(hit.transform.tag);
			}
			else
			{
				offset = Vector2.zero;
				cursor = cursorNormal;
			}
		}
	}

	void OnGUI () 
	{
		Vector2 mousePos = Event.current.mousePosition;
		GUI.depth = 999; // поверх остальных элементов
		GUI.Label(new Rect(mousePos.x + offset.x, mousePos.y + offset.y, size, size), cursor);
	}
}