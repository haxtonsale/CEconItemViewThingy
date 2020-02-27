#if defined _CEconItemView_included
 #endinput
#endif
#define _CEconItemView_included

methodmap CEconItemView
{
	public CEconItemView(Address ptr)
	{
		return view_as<CEconItemView>(ptr);
	}
	
	property Address m_pVTable
	{
		public get()
		{
			return view_as<Address>(this);
		}
	}
	
	property int m_iItemDefinitionIndex
	{
		public get()
		{
			return LoadFromAddress(this.m_pVTable+view_as<Address>(4), NumberType_Int16);
		}
		public set(int iVal)
		{
			StoreToAddress(this.m_pVTable+view_as<Address>(4), iVal, NumberType_Int16);
		}
	}
	
	property int m_iEntityQuality
	{
		public get()
		{
			return LoadFromAddress(this.m_pVTable+view_as<Address>(8), NumberType_Int32);
		}
		public set(int iVal)
		{
			StoreToAddress(this.m_pVTable+view_as<Address>(8), iVal, NumberType_Int32);
		}
	}
	
	property int m_iEntityLevel
	{
		public get()
		{
			return LoadFromAddress(this.m_pVTable+view_as<Address>(12), NumberType_Int32);
		}
		public set(int iVal)
		{
			StoreToAddress(this.m_pVTable+view_as<Address>(12), iVal, NumberType_Int32);
		}
	}
	
	public void GetItemID(int buf[2])
	{
		buf[0] = LoadFromAddress(this.m_pVTable+view_as<Address>(16), NumberType_Int32);
		buf[1] = LoadFromAddress(this.m_pVTable+view_as<Address>(20), NumberType_Int32);
	}
	public void SetItemID(int buf[2])
	{
		StoreToAddress(this.m_pVTable+view_as<Address>(16), buf[0], NumberType_Int32);
		StoreToAddress(this.m_pVTable+view_as<Address>(20), buf[1], NumberType_Int32);
	}
	
	property int m_iItemIDHigh
	{
		public get()
		{
			return LoadFromAddress(this.m_pVTable+view_as<Address>(24), NumberType_Int32);
		}
		public set(int iVal)
		{
			StoreToAddress(this.m_pVTable+view_as<Address>(24), iVal, NumberType_Int32);
		}
	}
	
	property int m_iItemIDLow
	{
		public get()
		{
			return LoadFromAddress(this.m_pVTable+view_as<Address>(28), NumberType_Int32);
		}
		public set(int iVal)
		{
			StoreToAddress(this.m_pVTable+view_as<Address>(28), iVal, NumberType_Int32);
		}
	}
	
	property int m_iAccountID
	{
		public get()
		{
			return LoadFromAddress(this.m_pVTable+view_as<Address>(32), NumberType_Int32);
		}
		public set(int iVal)
		{
			StoreToAddress(this.m_pVTable+view_as<Address>(32), iVal, NumberType_Int32);
		}
	}
	
	property int m_iInventoryPosition
	{
		public get()
		{
			return LoadFromAddress(this.m_pVTable+view_as<Address>(36), NumberType_Int32);
		}
		public set(int iVal)
		{
			StoreToAddress(this.m_pVTable+view_as<Address>(36), iVal, NumberType_Int32);
		}
	}
	
	// CEconItemHandle
	property Address m_pItem // CEconItem
	{
		public get()
		{
			return view_as<Address>(LoadFromAddress(this.m_pVTable+view_as<Address>(44), NumberType_Int32));
		}
		public set(Address iVal)
		{
			StoreToAddress(this.m_pVTable+view_as<Address>(44), view_as<int>(iVal), NumberType_Int32);
		}
	}
	
	public void GetUlItemID(int buf[2])
	{
		buf[0] = LoadFromAddress(this.m_pVTable+view_as<Address>(48), NumberType_Int32);
		buf[1] = LoadFromAddress(this.m_pVTable+view_as<Address>(52), NumberType_Int32);
	}
	public void SetUlItemID(int buf[2])
	{
		StoreToAddress(this.m_pVTable+view_as<Address>(48), buf[0], NumberType_Int32);
		StoreToAddress(this.m_pVTable+view_as<Address>(52), buf[1], NumberType_Int32);
	}
	
	public void GetSteamID(int buf[2])
	{
		buf[0] = LoadFromAddress(this.m_pVTable+view_as<Address>(56), NumberType_Int32);
		buf[1] = LoadFromAddress(this.m_pVTable+view_as<Address>(60), NumberType_Int32);
	}
	public void SetSteamID(int buf[2])
	{
		StoreToAddress(this.m_pVTable+view_as<Address>(56), buf[0], NumberType_Int32);
		StoreToAddress(this.m_pVTable+view_as<Address>(60), buf[1], NumberType_Int32);
	}
	// ---------------------------------------------------
	
	property bool m_bColorInit
	{
		public get()
		{
			return view_as<bool>(LoadFromAddress(this.m_pVTable+view_as<Address>(64), NumberType_Int8));
		}
		public set(bool bVal)
		{
			StoreToAddress(this.m_pVTable+view_as<Address>(64), bVal, NumberType_Int8);
		}
	}
	
	property bool m_bPaintOverrideInit
	{
		public get()
		{
			return view_as<bool>(LoadFromAddress(this.m_pVTable+view_as<Address>(65), NumberType_Int8));
		}
		public set(bool bVal)
		{
			StoreToAddress(this.m_pVTable+view_as<Address>(65), bVal, NumberType_Int8);
		}
	}
	
	property bool m_bHasPaintOverride
	{
		public get()
		{
			return view_as<bool>(LoadFromAddress(this.m_pVTable+view_as<Address>(66), NumberType_Int8));
		}
		public set(bool bVal)
		{
			StoreToAddress(this.m_pVTable+view_as<Address>(66), bVal, NumberType_Int8);
		}
	}
	
	property float m_flOverrideIndex
	{
		public get()
		{
			return view_as<float>(LoadFromAddress(this.m_pVTable+view_as<Address>(68), NumberType_Int32));
		}
		public set(float flVal)
		{
			StoreToAddress(this.m_pVTable+view_as<Address>(68), view_as<int>(flVal), NumberType_Int32);
		}
	}
	
	property int m_unRGB
	{
		public get()
		{
			return LoadFromAddress(this.m_pVTable+view_as<Address>(72), NumberType_Int32);
		}
		public set(int iVal)
		{
			StoreToAddress(this.m_pVTable+view_as<Address>(72), iVal, NumberType_Int32);
		}
	}
	
	property int m_unAltRGB
	{
		public get()
		{
			return LoadFromAddress(this.m_pVTable+view_as<Address>(76), NumberType_Int32);
		}
		public set(int iVal)
		{
			StoreToAddress(this.m_pVTable+view_as<Address>(76), iVal, NumberType_Int32);
		}
	}
	
	property int m_iTeamNumber
	{
		public get()
		{
			return LoadFromAddress(this.m_pVTable+view_as<Address>(80), NumberType_Int32);
		}
		public set(int iVal)
		{
			StoreToAddress(this.m_pVTable+view_as<Address>(80), iVal, NumberType_Int32);
		}
	}
	
	property bool m_bInitialized
	{
		public get()
		{
			return view_as<bool>(LoadFromAddress(this.m_pVTable+view_as<Address>(84), NumberType_Int8));
		}
		public set(bool bVal)
		{
			StoreToAddress(this.m_pVTable+view_as<Address>(84), bVal, NumberType_Int8);
		}
	}
	
	property Address m_pAttributeList // CAttributeList
	{
		public get()
		{
			return view_as<Address>(LoadFromAddress(this.m_pVTable+view_as<Address>(88), NumberType_Int8));
		}
		public set(Address pVal)
		{
			StoreToAddress(this.m_pVTable+view_as<Address>(88), view_as<int>(pVal), NumberType_Int8);
		}
	}
	
	property Address m_pNetworkedDynamicAttributesForDemos // CAttributeList
	{
		public get()
		{
			return view_as<Address>(LoadFromAddress(this.m_pVTable+view_as<Address>(116), NumberType_Int8));
		}
		public set(Address pVal)
		{
			StoreToAddress(this.m_pVTable+view_as<Address>(116), view_as<int>(pVal), NumberType_Int8);
		}
	}
}