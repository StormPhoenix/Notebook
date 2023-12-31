---
id: j8iiqh3h8fv1olol8jwdye3
title: LAYOUT_FIELD
desc: ''
updated: 1689137097826
created: 1688966786472
tags:
  - unrealengine
---

DECLARE_EXPORTED_TYPE_LAYOUT(T, RequiredAPI, Interface, ...) 宏展开
```c++

private: 
    using InternalBaseType = typename TGetBaseTypeHelper< FShaderUniformBufferParameter>::Type; 
    template<typename InternalType> static void InternalInitializeBases(FTypeLayoutDesc& TypeDesc) 
    { 
        TInitializeBaseHelper<InternalType, InternalBaseType>::Initialize(TypeDesc); 
    }; 

private: 
    static void InternalDestroy(void* Object, const FTypeLayoutDesc&, const FPointerTableBase* PtrTable, bool bIsFrozen); 

public:  
    static FTypeLayoutDesc& StaticGetTypeLayout(); 

public:  
    const FTypeLayoutDesc& GetTypeLayout() const; 
    static constexpr int CounterBase = 41374882; 

public: 
    using DerivedType =  FShaderUniformBufferParameter; 
    static constexpr ETypeLayoutInterface::Type InterfaceType = ETypeLayoutInterface::NonVirtual; 

    template<int Counter> struct InternalLinkType 
    {; 
        static __forceinline void Initialize(FTypeLayoutDesc& TypeDesc) 
        {
        } 
    };
```

LAYOUT_FIELD(uint64, BaseIndex) 宏展开如下
```c++
    uint16 BaseIndex; 
    __pragma (warning(push)) 
    __pragma (warning(disable: 4995)) 
    __pragma (warning(disable: 4996)) 
    
    template<> 
    struct InternalLinkType<41374883 - CounterBase> 
    { ; 
        /* 
        * Initialize(FTypeLayoutDesc& TypeDesc) 实现了对属性 BaseIndex 的反射
        * 属性 BaseIndex 的信息(包括：Name, Type, Offset 等) 被记录在在类 FShaderParameterUniformBuffer 的静态变量 FieldBuffer 中。
        */
        static void Initialize(FTypeLayoutDesc& TypeDesc) 
        { 
            InternalLinkType<41374883 - CounterBase + 1>::Initialize(TypeDesc); 
            alignas(FFieldLayoutDesc) static uint8 FieldBuffer[sizeof(FFieldLayoutDesc)] = { 0 }; 
            
            FFieldLayoutDesc& FieldDesc = *(FFieldLayoutDesc*)FieldBuffer; 
            FieldDesc.Name = L"BaseIndex"; 
            FieldDesc.UFieldNameLength = Freeze::FindFieldNameLength(FieldDesc.Name); 
            FieldDesc.Type = &StaticGetTypeLayoutDesc< uint16>(); 
            FieldDesc.WriteFrozenMemoryImageFunc = TGetFreezeImageFieldHelper< uint16>::Do(); 
            FieldDesc.Offset = ((::size_t)&reinterpret_cast<char const volatile&>((((DerivedType*)0)->BaseIndex))); 
            FieldDesc.NumArray = 1u; 
            FieldDesc.Flags = EFieldLayoutFlags::MakeFlags(); 
            FieldDesc.BitFieldSize = 0u; 
            FieldDesc.Next = TypeDesc.Fields; 
            TypeDesc.Fields = &FieldDesc; 
        } 
    }; 
    __pragma (warning(pop));
```

IMPLEMENT_TYPE_LAYOUT 宏展开
```c++
void FShaderUniformBufferParameter::InternalDestroy(void* Object, const FTypeLayoutDesc&,
                                                    const FPointerTableBase* PtrTable, bool bIsFrozen)
{
    Freeze::DestroyObject(static_cast<FShaderUniformBufferParameter*>(Object), PtrTable, bIsFrozen);
}


/**
* 宏展开实现了 StaticGetTypeLayout() 接口，该接口在 DECLARE_EXPORTED_TYPE_LAYOUT 宏中声明。
*
* StaticGetTypeLayout() 用来收集 FShaderUniformBufferParameter 的反射信息，存储到 FTypeLayoutDesc。
*/
FTypeLayoutDesc& FShaderUniformBufferParameter::StaticGetTypeLayout()
{
    static_assert(TValidateInterfaceHelper<FShaderUniformBufferParameter, InterfaceType>::Value,
        "Invalid interface for " "FShaderUniformBufferParameter");
    alignas(FTypeLayoutDesc) static uint8 TypeBuffer[sizeof(FTypeLayoutDesc)] = {0};
    FTypeLayoutDesc& TypeDesc = *(FTypeLayoutDesc*)TypeBuffer;
    if (!TypeDesc.IsInitialized)
    {
        TypeDesc.IsInitialized = true;
        TypeDesc.Name = L"FShaderUniformBufferParameter";
        TypeDesc.WriteFrozenMemoryImageFunc = TGetFreezeImageHelper<FShaderUniformBufferParameter>::Do();
        TypeDesc.UnfrozenCopyFunc = &Freeze::DefaultUnfrozenCopy;
        TypeDesc.AppendHashFunc = &Freeze::DefaultAppendHash;
        TypeDesc.GetTargetAlignmentFunc = &Freeze::DefaultGetTargetAlignment;
        TypeDesc.ToStringFunc = &Freeze::DefaultToString;
        TypeDesc.DestroyFunc = &InternalDestroy;
        TypeDesc.Size = sizeof(FShaderUniformBufferParameter);
        TypeDesc.Alignment = alignof(FShaderUniformBufferParameter);
        TypeDesc.Interface = InterfaceType;
        TypeDesc.SizeFromFields = ~0u;
        TypeDesc.GetDefaultObjectFunc = &TGetDefaultObjectHelper<FShaderUniformBufferParameter, InterfaceType>::Do;

        // 此处调用参考 LAYOUT_FIELD 宏展开，用来收集 BaseIndex 属性反射信息
        InternalLinkType < 1 > ::Initialize(TypeDesc);
        InternalInitializeBases<FShaderUniformBufferParameter>(TypeDesc);
        FTypeLayoutDesc::Initialize(TypeDesc);
    }
    return TypeDesc;
};

const FTypeLayoutDesc& FShaderUniformBufferParameter::GetTypeLayout() const { 
    return StaticGetTypeLayout(); 
};

static const FDelayedAutoRegisterHelper DelayedAutoRegisterHelper437094884(
    EDelayedRegisterRunPhase::ShaderTypesReady, []
    {
        FTypeLayoutDesc::Register(FShaderUniformBufferParameter::StaticGetTypeLayout());
    });;
```

## Conclusion
- DECLARE_EXPORTED_TYPE_LAYOUT: 收集类反射信息，并利用 LAYOUT_FIELD 中定义的函数收集类属性反射信息
- LAYOUT_FIELD: 定义类属性，并收集类属性反射信息
- IMPLEMENT_TYPE_LAYOUT: DECLARE_EXPORTED_TYPE_LAYOUT 中类反射信息收集函数的定义


参考: [[proxy.unrealengine.renderpipeline#layout_field]]

#todolist
LAYOUT_FIELD 文章引用了许多文献，去参考下。