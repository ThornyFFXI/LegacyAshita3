--[[
* Ashita - Copyright (c) 2014 - 2018 atom0s [atom0s@live.com]
*
* This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
* To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to
* Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*
* By using Ashita, you agree to the above license and its terms.
*
*      Attribution - You must give appropriate credit, provide a link to the license and indicate if changes were
*                    made. You must do so in any reasonable manner, but not in any way that suggests the licensor
*                    endorses you or your use.
*
*   Non-Commercial - You may not use the material (Ashita) for commercial purposes.
*
*   No-Derivatives - If you remix, transform, or build upon the material (Ashita), you may not distribute the
*                    modified material. You are, however, allowed to submit the modified works back to the original
*                    Ashita project in attempt to have it added to the original project.
*
* You may not apply legal terms or technological measures that legally restrict others
* from doing anything the license permits.
*
* No warranties are given.
]]--

--
-- d3d8.h
--

DIRECT3D_VERSION                                = 0x0800;
D3D_SDK_VERSION                                 = 220;

D3DSPD_IUNKNOWN                                 = 0x00000001;

D3DCURRENT_DISPLAY_MODE                         = 0x00EFFFFF;

D3DCREATE_FPU_PRESERVE                          = 0x00000002;
D3DCREATE_MULTITHREADED                         = 0x00000004;
D3DCREATE_PUREDEVICE                            = 0x00000010;
D3DCREATE_SOFTWARE_VERTEXPROCESSING             = 0x00000020;
D3DCREATE_HARDWARE_VERTEXPROCESSING             = 0x00000040;
D3DCREATE_MIXED_VERTEXPROCESSING                = 0x00000080;
D3DCREATE_DISABLE_DRIVER_MANAGEMENT             = 0x00000100;

D3DADAPTER_DEFAULT                              = 0;

D3DENUM_NO_WHQL_LEVEL                           = 0x00000002;

D3DPRESENT_BACK_BUFFERS_MAX                     = 3;

D3DSGR_NO_CALIBRATION                           = 0x00000000;
D3DSGR_CALIBRATE                                = 0x00000001;

D3DCURSOR_IMMEDIATE_UPDATE                      = 0x00000001;

_FACD3D                                         = 0x876;

function MAKE_HRESULT(sev, fac, code)
    local t1 = bit.lshift(sev, 31);
    local t2 = bit.lshift(fac, 16);
    local t3 = bit.bor(t1, t2);
    return bit.bor(t3, code);
end

function MAKE_D3DHRESULT(code)
    return MAKE_HRESULT(1, _FACD3D, code);
end

D3D_OK                                          = 0;
D3DERR_WRONGTEXTUREFORMAT                       = MAKE_D3DHRESULT(2072);
D3DERR_UNSUPPORTEDCOLOROPERATION                = MAKE_D3DHRESULT(2073);
D3DERR_UNSUPPORTEDCOLORARG                      = MAKE_D3DHRESULT(2074);
D3DERR_UNSUPPORTEDALPHAOPERATION                = MAKE_D3DHRESULT(2075);
D3DERR_UNSUPPORTEDALPHAARG                      = MAKE_D3DHRESULT(2076);
D3DERR_TOOMANYOPERATIONS                        = MAKE_D3DHRESULT(2077);
D3DERR_CONFLICTINGTEXTUREFILTER                 = MAKE_D3DHRESULT(2078);
D3DERR_UNSUPPORTEDFACTORVALUE                   = MAKE_D3DHRESULT(2079);
D3DERR_CONFLICTINGRENDERSTATE                   = MAKE_D3DHRESULT(2081);
D3DERR_UNSUPPORTEDTEXTUREFILTER                 = MAKE_D3DHRESULT(2082);
D3DERR_CONFLICTINGTEXTUREPALETTE                = MAKE_D3DHRESULT(2086);
D3DERR_DRIVERINTERNALERROR                      = MAKE_D3DHRESULT(2087);
D3DERR_NOTFOUND                                 = MAKE_D3DHRESULT(2150);
D3DERR_MOREDATA                                 = MAKE_D3DHRESULT(2151);
D3DERR_DEVICELOST                               = MAKE_D3DHRESULT(2152);
D3DERR_DEVICENOTRESET                           = MAKE_D3DHRESULT(2153);
D3DERR_NOTAVAILABLE                             = MAKE_D3DHRESULT(2154);
D3DERR_OUTOFVIDEOMEMORY                         = MAKE_D3DHRESULT(380);
D3DERR_INVALIDDEVICE                            = MAKE_D3DHRESULT(2155);
D3DERR_INVALIDCALL                              = MAKE_D3DHRESULT(2156);
D3DERR_DRIVERINVALIDCALL                        = MAKE_D3DHRESULT(2157);

--
-- d3d8types.h
--

D3DMAXUSERCLIPPLANES                            = 32;

D3DCLIPPLANE0                                   = 1;
D3DCLIPPLANE1                                   = 2;
D3DCLIPPLANE2                                   = 4;
D3DCLIPPLANE3                                   = 8;
D3DCLIPPLANE4                                   = 16;
D3DCLIPPLANE5                                   = 32;

D3DCS_LEFT                                      = 0x00000001;
D3DCS_RIGHT                                     = 0x00000002;
D3DCS_TOP                                       = 0x00000004;
D3DCS_BOTTOM                                    = 0x00000008;
D3DCS_FRONT                                     = 0x00000010;
D3DCS_BACK                                      = 0x00000020;
D3DCS_PLANE0                                    = 0x00000040;
D3DCS_PLANE1                                    = 0x00000080;
D3DCS_PLANE2                                    = 0x00000100;
D3DCS_PLANE3                                    = 0x00000200;
D3DCS_PLANE4                                    = 0x00000400;
D3DCS_PLANE5                                    = 0x00000800;

D3DLIGHT_POINT                                  = 1;
D3DLIGHT_SPOT                                   = 2;
D3DLIGHT_DIRECTIONAL                            = 3;
D3DLIGHT_FORCE_DWORD                            = 0x7fffffff;

D3DCLEAR_TARGET                                 = 0x00000001;
D3DCLEAR_ZBUFFER                                = 0x00000002;
D3DCLEAR_STENCIL                                = 0x00000004;

D3DSHADE_FLAT                                   = 1;
D3DSHADE_GOURAUD                                = 2;
D3DSHADE_PHONG                                  = 3;
D3DSHADE_FORCE_DWORD                            = 0x7fffffff;

D3DFILL_POINT                                   = 1;
D3DFILL_WIREFRAME                               = 2;
D3DFILL_SOLID                                   = 3;
D3DFILL_FORCE_DWORD                             = 0x7fffffff;

D3DBLEND_ZERO                                   = 1;
D3DBLEND_ONE                                    = 2;
D3DBLEND_SRCCOLOR                               = 3;
D3DBLEND_INVSRCCOLOR                            = 4;
D3DBLEND_SRCALPHA                               = 5;
D3DBLEND_INVSRCALPHA                            = 6;
D3DBLEND_DESTALPHA                              = 7;
D3DBLEND_INVDESTALPHA                           = 8;
D3DBLEND_DESTCOLOR                              = 9;
D3DBLEND_INVDESTCOLOR                           = 10;
D3DBLEND_SRCALPHASAT                            = 11;
D3DBLEND_BOTHSRCALPHA                           = 12;
D3DBLEND_BOTHINVSRCALPHA                        = 13;
D3DBLEND_FORCE_DWORD                            = 0x7fffffff;

D3DBLENDOP_ADD                                  = 1;
D3DBLENDOP_SUBTRACT                             = 2;
D3DBLENDOP_REVSUBTRACT                          = 3;
D3DBLENDOP_MIN                                  = 4;
D3DBLENDOP_MAX                                  = 5;
D3DBLENDOP_FORCE_DWORD                          = 0x7fffffff;

D3DTADDRESS_WRAP                                = 1;
D3DTADDRESS_MIRROR                              = 2;
D3DTADDRESS_CLAMP                               = 3;
D3DTADDRESS_BORDER                              = 4;
D3DTADDRESS_MIRRORONCE                          = 5;
D3DTADDRESS_FORCE_DWORD                         = 0x7fffffff;

D3DCULL_NONE                                    = 1;
D3DCULL_CW                                      = 2;
D3DCULL_CCW                                     = 3;
D3DCULL_FORCE_DWORD                             = 0x7fffffff;

D3DCMP_NEVER                                    = 1;
D3DCMP_LESS                                     = 2;
D3DCMP_EQUAL                                    = 3;
D3DCMP_LESSEQUAL                                = 4;
D3DCMP_GREATER                                  = 5;
D3DCMP_NOTEQUAL                                 = 6;
D3DCMP_GREATEREQUAL                             = 7;
D3DCMP_ALWAYS                                   = 8;
D3DCMP_FORCE_DWORD                              = 0x7fffffff;

D3DSTENCILOP_KEEP                               = 1;
D3DSTENCILOP_ZERO                               = 2;
D3DSTENCILOP_REPLACE                            = 3;
D3DSTENCILOP_INCRSAT                            = 4;
D3DSTENCILOP_DECRSAT                            = 5;
D3DSTENCILOP_INVERT                             = 6;
D3DSTENCILOP_INCR                               = 7;
D3DSTENCILOP_DECR                               = 8;
D3DSTENCILOP_FORCE_DWORD                        = 0x7fffffff;

D3DFOG_NONE                                     = 0;
D3DFOG_EXP                                      = 1;
D3DFOG_EXP2                                     = 2;
D3DFOG_LINEAR                                   = 3;
D3DFOG_FORCE_DWORD                              = 0x7fffffff; 

D3DZB_FALSE                                     = 0;
D3DZB_TRUE                                      = 1;
D3DZB_USEW                                      = 2;
D3DZB_FORCE_DWORD                               = 0x7fffffff; 

D3DPT_POINTLIST                                 = 1;
D3DPT_LINELIST                                  = 2;
D3DPT_LINESTRIP                                 = 3;
D3DPT_TRIANGLELIST                              = 4;
D3DPT_TRIANGLESTRIP                             = 5;
D3DPT_TRIANGLEFAN                               = 6;
D3DPT_FORCE_DWORD                               = 0x7fffffff;

D3DTS_VIEW                                      = 2;
D3DTS_PROJECTION                                = 3;
D3DTS_TEXTURE0                                  = 16;
D3DTS_TEXTURE1                                  = 17;
D3DTS_TEXTURE2                                  = 18;
D3DTS_TEXTURE3                                  = 19;
D3DTS_TEXTURE4                                  = 20;
D3DTS_TEXTURE5                                  = 21;
D3DTS_TEXTURE6                                  = 22;
D3DTS_TEXTURE7                                  = 23;
D3DTS_FORCE_DWORD                               = 0x7fffffff;

D3DTS_WORLD                                     = 256;
D3DTS_WORLD1                                    = 257;
D3DTS_WORLD2                                    = 258;
D3DTS_WORLD3                                    = 259;

D3DRS_ZENABLE                                   = 7;
D3DRS_FILLMODE                                  = 8;
D3DRS_SHADEMODE                                 = 9;
D3DRS_LINEPATTERN                               = 10;
D3DRS_ZWRITEENABLE                              = 14;
D3DRS_ALPHATESTENABLE                           = 15;
D3DRS_LASTPIXEL                                 = 16;
D3DRS_SRCBLEND                                  = 19;
D3DRS_DESTBLEND                                 = 20;
D3DRS_CULLMODE                                  = 22;
D3DRS_ZFUNC                                     = 23;
D3DRS_ALPHAREF                                  = 24;
D3DRS_ALPHAFUNC                                 = 25;
D3DRS_DITHERENABLE                              = 26;
D3DRS_ALPHABLENDENABLE                          = 27;
D3DRS_FOGENABLE                                 = 28;
D3DRS_SPECULARENABLE                            = 29;
D3DRS_ZVISIBLE                                  = 30;
D3DRS_FOGCOLOR                                  = 34;
D3DRS_FOGTABLEMODE                              = 35;
D3DRS_FOGSTART                                  = 36;
D3DRS_FOGEND                                    = 37;
D3DRS_FOGDENSITY                                = 38;
D3DRS_EDGEANTIALIAS                             = 40;
D3DRS_ZBIAS                                     = 47;
D3DRS_RANGEFOGENABLE                            = 48;
D3DRS_STENCILENABLE                             = 52;
D3DRS_STENCILFAIL                               = 53;
D3DRS_STENCILZFAIL                              = 54;
D3DRS_STENCILPASS                               = 55;
D3DRS_STENCILFUNC                               = 56;
D3DRS_STENCILREF                                = 57;
D3DRS_STENCILMASK                               = 58;
D3DRS_STENCILWRITEMASK                          = 59;
D3DRS_TEXTUREFACTOR                             = 60;
D3DRS_WRAP0                                     = 128;
D3DRS_WRAP1                                     = 129;
D3DRS_WRAP2                                     = 130;
D3DRS_WRAP3                                     = 131;
D3DRS_WRAP4                                     = 132;
D3DRS_WRAP5                                     = 133;
D3DRS_WRAP6                                     = 134;
D3DRS_WRAP7                                     = 135;
D3DRS_CLIPPING                                  = 136;
D3DRS_LIGHTING                                  = 137;
D3DRS_AMBIENT                                   = 139;
D3DRS_FOGVERTEXMODE                             = 140;
D3DRS_COLORVERTEX                               = 141;
D3DRS_LOCALVIEWER                               = 142;
D3DRS_NORMALIZENORMALS                          = 143;
D3DRS_DIFFUSEMATERIALSOURCE                     = 145;
D3DRS_SPECULARMATERIALSOURCE                    = 146;
D3DRS_AMBIENTMATERIALSOURCE                     = 147;
D3DRS_EMISSIVEMATERIALSOURCE                    = 148;
D3DRS_VERTEXBLEND                               = 151;
D3DRS_CLIPPLANEENABLE                           = 152;
D3DRS_SOFTWAREVERTEXPROCESSING                  = 153;
D3DRS_POINTSIZE                                 = 154;
D3DRS_POINTSIZE_MIN                             = 155;
D3DRS_POINTSPRITEENABLE                         = 156;
D3DRS_POINTSCALEENABLE                          = 157;
D3DRS_POINTSCALE_A                              = 158;
D3DRS_POINTSCALE_B                              = 159;
D3DRS_POINTSCALE_C                              = 160;
D3DRS_MULTISAMPLEANTIALIAS                      = 161;
D3DRS_MULTISAMPLEMASK                           = 162;
D3DRS_PATCHEDGESTYLE                            = 163;
D3DRS_PATCHSEGMENTS                             = 164;
D3DRS_DEBUGMONITORTOKEN                         = 165;
D3DRS_POINTSIZE_MAX                             = 166;
D3DRS_INDEXEDVERTEXBLENDENABLE                  = 167;
D3DRS_COLORWRITEENABLE                          = 168;
D3DRS_TWEENFACTOR                               = 170;
D3DRS_BLENDOP                                   = 171;
D3DRS_POSITIONORDER                             = 172;
D3DRS_NORMALORDER                               = 173;
D3DRS_FORCE_DWORD                               = 0x7fffffff;

D3DMCS_MATERIAL                                 = 0;
D3DMCS_COLOR1                                   = 1;
D3DMCS_COLOR2                                   = 2;
D3DMCS_FORCE_DWORD                              = 0x7fffffff;

D3DRENDERSTATE_WRAPBIAS                         = 128;

D3DWRAP_U                                       = 0x00000001;
D3DWRAP_V                                       = 0x00000002;
D3DWRAP_W                                       = 0x00000004;

D3DWRAPCOORD_0                                  = 0x00000001;
D3DWRAPCOORD_1                                  = 0x00000002;
D3DWRAPCOORD_2                                  = 0x00000004;
D3DWRAPCOORD_3                                  = 0x00000008;

D3DCOLORWRITEENABLE_RED                         = 1;
D3DCOLORWRITEENABLE_GREEN                       = 2;
D3DCOLORWRITEENABLE_BLUE                        = 4;
D3DCOLORWRITEENABLE_ALPHA                       = 8;

D3DTSS_COLOROP                                  = 1;
D3DTSS_COLORARG1                                = 2;
D3DTSS_COLORARG2                                = 3;
D3DTSS_ALPHAOP                                  = 4;
D3DTSS_ALPHAARG1                                = 5;
D3DTSS_ALPHAARG2                                = 6;
D3DTSS_BUMPENVMAT00                             = 7;
D3DTSS_BUMPENVMAT01                             = 8;
D3DTSS_BUMPENVMAT10                             = 9;
D3DTSS_BUMPENVMAT11                             = 10;
D3DTSS_TEXCOORDINDEX                            = 11;
D3DTSS_ADDRESSU                                 = 13;
D3DTSS_ADDRESSV                                 = 14;
D3DTSS_BORDERCOLOR                              = 15;
D3DTSS_MAGFILTER                                = 16;
D3DTSS_MINFILTER                                = 17;
D3DTSS_MIPFILTER                                = 18;
D3DTSS_MIPMAPLODBIAS                            = 19;
D3DTSS_MAXMIPLEVEL                              = 20;
D3DTSS_MAXANISOTROPY                            = 21;
D3DTSS_BUMPENVLSCALE                            = 22;
D3DTSS_BUMPENVLOFFSET                           = 23;
D3DTSS_TEXTURETRANSFORMFLAGS                    = 24;
D3DTSS_ADDRESSW                                 = 25;
D3DTSS_COLORARG0                                = 26;
D3DTSS_ALPHAARG0                                = 27;
D3DTSS_RESULTARG                                = 28;
D3DTSS_FORCE_DWORD                              = 0x7fffffff;

D3DTSS_TCI_PASSTHRU                             = 0x00000000;
D3DTSS_TCI_CAMERASPACENORMAL                    = 0x00010000;
D3DTSS_TCI_CAMERASPACEPOSITION                  = 0x00020000;
D3DTSS_TCI_CAMERASPACEREFLECTIONVECTOR          = 0x00030000;

D3DTOP_DISABLE                                  = 1;
D3DTOP_SELECTARG1                               = 2;
D3DTOP_SELECTARG2                               = 3;
D3DTOP_MODULATE                                 = 4;
D3DTOP_MODULATE2X                               = 5;
D3DTOP_MODULATE4X                               = 6;
D3DTOP_ADD                                      = 7;
D3DTOP_ADDSIGNED                                = 8;
D3DTOP_ADDSIGNED2X                              = 9;
D3DTOP_SUBTRACT                                 = 10;
D3DTOP_ADDSMOOTH                                = 11;
D3DTOP_BLENDDIFFUSEALPHA                        = 12;
D3DTOP_BLENDTEXTUREALPHA                        = 13;
D3DTOP_BLENDFACTORALPHA                         = 14;
D3DTOP_BLENDTEXTUREALPHAPM                      = 15;
D3DTOP_BLENDCURRENTALPHA                        = 16;
D3DTOP_PREMODULATE                              = 17;
D3DTOP_MODULATEALPHA_ADDCOLOR                   = 18;
D3DTOP_MODULATECOLOR_ADDALPHA                   = 19;
D3DTOP_MODULATEINVALPHA_ADDCOLOR                = 20;
D3DTOP_MODULATEINVCOLOR_ADDALPHA                = 21;
D3DTOP_BUMPENVMAP                               = 22;
D3DTOP_BUMPENVMAPLUMINANCE                      = 23;
D3DTOP_DOTPRODUCT3                              = 24;
D3DTOP_MULTIPLYADD                              = 25;
D3DTOP_LERP                                     = 26;
D3DTOP_FORCE_DWORD                              = 0x7fffffff;

D3DTA_SELECTMASK                                = 0x0000000f;
D3DTA_DIFFUSE                                   = 0x00000000;
D3DTA_CURRENT                                   = 0x00000001;
D3DTA_TEXTURE                                   = 0x00000002;
D3DTA_TFACTOR                                   = 0x00000003;
D3DTA_SPECULAR                                  = 0x00000004;
D3DTA_TEMP                                      = 0x00000005;
D3DTA_COMPLEMENT                                = 0x00000010;
D3DTA_ALPHAREPLICATE                            = 0x00000020;

D3DTEXF_NONE                                    = 0;
D3DTEXF_POINT                                   = 1;
D3DTEXF_LINEAR                                  = 2;
D3DTEXF_ANISOTROPIC                             = 3;
D3DTEXF_FLATCUBIC                               = 4;
D3DTEXF_GAUSSIANCUBIC                           = 5;
D3DTEXF_FORCE_DWORD                             = 0x7fffffff;

D3DPV_DONOTCOPYDATA                             = 1;

D3DFVF_RESERVED0                                = 0x001;
D3DFVF_POSITION_MASK                            = 0x00E;
D3DFVF_XYZ                                      = 0x002;
D3DFVF_XYZRHW                                   = 0x004;
D3DFVF_XYZB1                                    = 0x006;
D3DFVF_XYZB2                                    = 0x008;
D3DFVF_XYZB3                                    = 0x00a;
D3DFVF_XYZB4                                    = 0x00c;
D3DFVF_XYZB5                                    = 0x00e;
D3DFVF_NORMAL                                   = 0x010;
D3DFVF_PSIZE                                    = 0x020;
D3DFVF_DIFFUSE                                  = 0x040;
D3DFVF_SPECULAR                                 = 0x080;
D3DFVF_TEXCOUNT_MASK                            = 0xf00;
D3DFVF_TEXCOUNT_SHIFT                           = 8;
D3DFVF_TEX0                                     = 0x000;
D3DFVF_TEX1                                     = 0x100;
D3DFVF_TEX2                                     = 0x200;
D3DFVF_TEX3                                     = 0x300;
D3DFVF_TEX4                                     = 0x400;
D3DFVF_TEX5                                     = 0x500;
D3DFVF_TEX6                                     = 0x600;
D3DFVF_TEX7                                     = 0x700;
D3DFVF_TEX8                                     = 0x800;
D3DFVF_LASTBETA_UBYTE4                          = 0x1000;
D3DFVF_RESERVED2                                = 0xE000;

D3DVSD_TOKEN_NOP                                = 0;
D3DVSD_TOKEN_STREAM                             = 1;
D3DVSD_TOKEN_STREAMDATA                         = 2;
D3DVSD_TOKEN_TESSELLATOR                        = 3;
D3DVSD_TOKEN_CONSTMEM                           = 4;
D3DVSD_TOKEN_EXT                                = 5;
D3DVSD_TOKEN_END                                = 7;
D3DVSD_FORCE_DWORD                              = 0x7fffffff;

D3DVSD_TOKENTYPESHIFT                           = 29;
D3DVSD_TOKENTYPEMASK                            = 0xe0000000;

D3DVSD_STREAMNUMBERSHIFT                        = 0;
D3DVSD_STREAMNUMBERMASK                         = 0x0000000F;

D3DVSD_DATALOADTYPESHIFT                        = 28;
D3DVSD_DATALOADTYPEMASK                         = 0x00000038;

D3DVSD_DATATYPESHIFT                            = 16;
D3DVSD_DATATYPEMASK                             = 0x000f0000;

D3DVSD_SKIPCOUNTSHIFT                           = 16;
D3DVSD_SKIPCOUNTMASK                            = 0x000f0000;

D3DVSD_VERTEXREGSHIFT                           = 0;
D3DVSD_VERTEXREGMASK                            = 0x0000001f;

D3DVSD_VERTEXREGINSHIFT                         = 20;
D3DVSD_VERTEXREGINMASK                          = 0x00f00000;

D3DVSD_CONSTCOUNTSHIFT                          = 25;
D3DVSD_CONSTCOUNTMASK                           = 0x1e000000;

D3DVSD_CONSTADDRESSSHIFT                        = 0;
D3DVSD_CONSTADDRESSMASK                         = 0x0000007f;

D3DVSD_CONSTRSSHIFT                             = 16;
D3DVSD_CONSTRSMASK                              = 0x1fff0000;

D3DVSD_EXTCOUNTSHIFT                            = 24;
D3DVSD_EXTCOUNTMASK                             = 0x1f000000;

D3DVSD_EXTINFOSHIFT                             = 0;
D3DVSD_EXTINFOMASK                              = 0x00ffffff;

function D3DVSD_MAKETOKENTYPE(tokenType)
    return bit.band(bit.lshift(tokenType, D3DVSD_TOKENTYPESHIFT), D3DVSD_TOKENTYPEMASK);
end

function D3DVSD_STREAM(streamNumber)
    local t = D3DVSD_MAKETOKENTYPE(D3DVSD_TOKEN_STREAM);
    return bit.bor(t, streamNumber);
end

D3DVSD_STREAMTESSSHIFT                          = 28;
D3DVSD_STREAMTESSMASK                           = 0x10000000;

function D3DVSD_STREAM_TESS()
    return 0x30000000;
end

function D3DVSD_REG(vertexRegister, dataType)
    local t1 = D3DVSD_MAKETOKENTYPE(D3DVSD_TOKEN_STREAMDATA);
    local t2 = bit.lshift(dataType, D3DVSD_DATATYPESHIFT);
    local t3 = bit.bor(t1, t2);
    return bit.bor(t3, vertexRegister);
end

function D3DVSD_SKIP(dwordCount)
    local t1 = D3DVSD_MAKETOKENTYPE(D3DVSD_TOKEN_STREAMDATA);
    local t2 = bit.lshift(dwordCount, D3DVSD_SKIPCOUNTSHIFT);
    local t3 = bit.bor(t1, 0x10000000);
    return bit.bor(t2, t3);
end

function D3DVSD_CONST(constantAddress, count)
    local t1 = D3DVSD_MAKETOKENTYPE(D3DVSD_TOKEN_CONSTMEM);
    local t2 = bit.lshift(count, D3DVSD_CONSTCOUNTSHIFT);
    local t3 = bit.bor(t1, t2);
    return bit.bor(t3, constantAddress);
end

function D3DVSD_TESSNORMAL(vertexRegisterIn, vertexRegisterOut)
    local t1 = D3DVSD_MAKETOKENTYPE(D3DVSD_TOKEN_TESSELLATOR);
    local t2 = bit.lshift(vertexRegisterIn, D3DVSD_VERTEXREGINSHIFT);
    local t3 = bit.lshift(0x02, D3DVSD_DATATYPESHIFT);
    local t4 = bit.bor(t1, t2);
    local t5 = bit.bor(t3, t4);
    return bit.bor(t5, vertexRegisterOut);
end

function D3DVSD_TESSUV(vertexRegister)
    local t1 = D3DVSD_MAKETOKENTYPE(D3DVSD_TOKEN_TESSELLATOR);
    local t2 = bit.lshift(0x01, D3DVSD_DATATYPESHIFT);
    local t3 = bit.bor(t1, 0x10000000);
    local t4 = bit.bor(t2, t3);
    return bit.bor(t4, vertexRegister);
end

function D3DVSD_END()
    return 0xFFFFFFFF;
end

function D3DVSD_NOP()
    return 0;
end

D3DVSDT_FLOAT1                                  = 0x00;
D3DVSDT_FLOAT2                                  = 0x01;
D3DVSDT_FLOAT3                                  = 0x02;
D3DVSDT_FLOAT4                                  = 0x03;
D3DVSDT_D3DCOLOR                                = 0x04;
D3DVSDT_UBYTE4                                  = 0x05;
D3DVSDT_SHORT2                                  = 0x06;
D3DVSDT_SHORT4                                  = 0x07;

D3DVSDE_POSITION                                = 0;
D3DVSDE_BLENDWEIGHT                             = 1;
D3DVSDE_BLENDINDICES                            = 2;
D3DVSDE_NORMAL                                  = 3;
D3DVSDE_PSIZE                                   = 4;
D3DVSDE_DIFFUSE                                 = 5;
D3DVSDE_SPECULAR                                = 6;
D3DVSDE_TEXCOORD0                               = 7;
D3DVSDE_TEXCOORD1                               = 8;
D3DVSDE_TEXCOORD2                               = 9;
D3DVSDE_TEXCOORD3                               = 10;
D3DVSDE_TEXCOORD4                               = 11;
D3DVSDE_TEXCOORD5                               = 12;
D3DVSDE_TEXCOORD6                               = 13;
D3DVSDE_TEXCOORD7                               = 14;
D3DVSDE_POSITION2                               = 15;
D3DVSDE_NORMAL2                                 = 16;

D3DDP_MAXTEXCOORD                               = 8;

D3DSI_OPCODE_MASK                               = 0x0000FFFF;

D3DSIO_NOP                                      = 0;
D3DSIO_MOV                                      = 1;
D3DSIO_ADD                                      = 2;
D3DSIO_SUB                                      = 3;
D3DSIO_MAD                                      = 4;
D3DSIO_MUL                                      = 5;
D3DSIO_RCP                                      = 6;
D3DSIO_RSQ                                      = 7;
D3DSIO_DP3                                      = 8;
D3DSIO_DP4                                      = 9;
D3DSIO_MIN                                      = 10;
D3DSIO_MAX                                      = 11;
D3DSIO_SLT                                      = 12;
D3DSIO_SGE                                      = 13;
D3DSIO_EXP                                      = 14;
D3DSIO_LOG                                      = 15;
D3DSIO_LIT                                      = 16;
D3DSIO_DST                                      = 17;
D3DSIO_LRP                                      = 18;
D3DSIO_FRC                                      = 19;
D3DSIO_M4x4                                     = 20;
D3DSIO_M4x3                                     = 21;
D3DSIO_M3x4                                     = 22;
D3DSIO_M3x3                                     = 23;
D3DSIO_M3x2                                     = 24;
D3DSIO_TEXCOORD                                 = 64;
D3DSIO_TEXKILL                                  = 65;
D3DSIO_TEX                                      = 66;
D3DSIO_TEXBEM                                   = 67;
D3DSIO_TEXBEML                                  = 68;
D3DSIO_TEXREG2AR                                = 69;
D3DSIO_TEXREG2GB                                = 70;
D3DSIO_TEXM3x2PAD                               = 71;
D3DSIO_TEXM3x2TEX                               = 72;
D3DSIO_TEXM3x3PAD                               = 73;
D3DSIO_TEXM3x3TEX                               = 74;
D3DSIO_TEXM3x3DIFF                              = 75;
D3DSIO_TEXM3x3SPEC                              = 76;
D3DSIO_TEXM3x3VSPEC                             = 77;
D3DSIO_EXPP                                     = 78;
D3DSIO_LOGP                                     = 79;
D3DSIO_CND                                      = 80;
D3DSIO_DEF                                      = 81;
D3DSIO_TEXREG2RGB                               = 82;
D3DSIO_TEXDP3TEX                                = 83;
D3DSIO_TEXM3x2DEPTH                             = 84;
D3DSIO_TEXDP3                                   = 85;
D3DSIO_TEXM3x3                                  = 86;
D3DSIO_TEXDEPTH                                 = 87;
D3DSIO_CMP                                      = 88;
D3DSIO_BEM                                      = 89;
D3DSIO_PHASE                                    = 0xFFFD;
D3DSIO_COMMENT                                  = 0xFFFE;
D3DSIO_END                                      = 0xFFFF;
D3DSIO_FORCE_DWORD                              = 0x7fffffff;

D3DSI_COISSUE                                   = 0x40000000;

D3DSP_REGNUM_MASK                               = 0x00001FFF;

D3DSP_WRITEMASK_0                               = 0x00010000;
D3DSP_WRITEMASK_1                               = 0x00020000;
D3DSP_WRITEMASK_2                               = 0x00040000;
D3DSP_WRITEMASK_3                               = 0x00080000;
D3DSP_WRITEMASK_ALL                             = 0x000F0000;

D3DSP_DSTMOD_SHIFT                              = 20;
D3DSP_DSTMOD_MASK                               = 0x00F00000;

D3DSPDM_NONE                                    = 0x00000000;
D3DSPDM_SATURATE                                = 0x00100000;
D3DSPDM_FORCE_DWORD                             = 0x7fffffff;

D3DSP_DSTSHIFT_SHIFT                            = 24;
D3DSP_DSTSHIFT_MASK                             = 0x0F000000;

D3DSP_REGTYPE_SHIFT                             = 28;
D3DSP_REGTYPE_MASK                              = 0x70000000;

D3DSPR_TEMP                                     = 0x00000000;
D3DSPR_INPUT                                    = 0x10000000;
D3DSPR_CONST                                    = 0x20000000;
D3DSPR_ADDR                                     = 0x30000000;
D3DSPR_TEXTURE                                  = 0x30000000;
D3DSPR_RASTOUT                                  = 0x40000000;
D3DSPR_ATTROUT                                  = 0x50000000;
D3DSPR_TEXCRDOUT                                = 0x60000000;
D3DSPR_FORCE_DWORD                              = 0x7fffffff;

D3DSRO_POSITION                                 = 0;
D3DSRO_FOG                                      = 1;
D3DSRO_POINT_SIZE                               = 2;
D3DSRO_FORCE_DWORD                              = 0x7fffffff;

D3DVS_ADDRESSMODE_SHIFT                         = 13;
D3DVS_ADDRESSMODE_MASK                          = 0x00002000;

D3DVS_ADDRMODE_ABSOLUTE                         = 0x00000000;
D3DVS_ADDRMODE_RELATIVE                         = 0x00002000;
D3DVS_ADDRMODE_FORCE_DWORD                      = 0x7fffffff;

D3DVS_SWIZZLE_SHIFT                             = 16;
D3DVS_SWIZZLE_MASK                              = 0x00FF0000;

D3DVS_X_X                                       = 0x00000000;
D3DVS_X_Y                                       = 0x00010000;
D3DVS_X_Z                                       = 0x00020000;
D3DVS_X_W                                       = 0x00030000;

D3DVS_Y_X                                       = 0x00000000;
D3DVS_Y_Y                                       = 0x00040000;
D3DVS_Y_Z                                       = 0x00080000;
D3DVS_Y_W                                       = 0x000c0000;

D3DVS_Z_X                                       = 0x00000000;
D3DVS_Z_Y                                       = 0x00100000;
D3DVS_Z_Z                                       = 0x00200000;
D3DVS_Z_W                                       = 0x00300000;

D3DVS_W_X                                       = 0x00000000;
D3DVS_W_Y                                       = 0x00400000;
D3DVS_W_Z                                       = 0x00800000;
D3DVS_W_W                                       = 0x00c00000;

D3DVS_NOSWIZZLE                                 = 0x00e40000;

D3DSP_SWIZZLE_SHIFT                             = 16;
D3DSP_SWIZZLE_MASK                              = 0x00FF0000;

D3DSP_NOSWIZZLE                                 = 0x00e40000;

D3DSP_REPLICATERED                              = 0x00000000;
D3DSP_REPLICATEGREEN                            = 0x00550000;
D3DSP_REPLICATEBLUE                             = 0x00aa0000;
D3DSP_REPLICATEALPHA                            = 0x00ff0000;

D3DSP_SRCMOD_SHIFT                              = 24;
D3DSP_SRCMOD_MASK                               = 0x0F000000;

D3DSPSM_NONE                                    = 0x00000000;
D3DSPSM_NEG                                     = 0x01000000;
D3DSPSM_BIAS                                    = 0x02000000;
D3DSPSM_BIASNEG                                 = 0x03000000;
D3DSPSM_SIGN                                    = 0x04000000;
D3DSPSM_SIGNNEG                                 = 0x05000000;
D3DSPSM_COMP                                    = 0x06000000;
D3DSPSM_X2                                      = 0x07000000;
D3DSPSM_X2NEG                                   = 0x08000000;
D3DSPSM_DZ                                      = 0x09000000;
D3DSPSM_DW                                      = 0x0a000000;
D3DSPSM_FORCE_DWORD                             = 0x7fffffff;

function D3DPS_VERSION(Major, Minor)
    local t1 = 0xFFFF0000;
    local t2 = bit.lshift(Major, 8);
    local t3 = bit.bor(t1, t2);
    return bit.bor(t3, Minor);
end

function D3DVS_VERSION(Major, Minor)
    local t1 = 0xFFFE0000;
    local t2 = bit.lshift(Major, 8);
    local t3 = bit.bor(t1, t2);
    return bit.bor(t3, Minor);
end

function D3DSHADER_VERSION_MAJOR(Version)
    local t1 = bit.rshift(Version, 8);
    return bit.band(t1, 0x0FF);
end

function D3DSHADER_VERSION_MINOR(Version)
    local t1 = bit.rshift(Version, 0);
    return bit.band(t1, 0x0FF);
end

D3DSI_COMMENTSIZE_SHIFT                         = 16;
D3DSI_COMMENTSIZE_MASK                          = 0x7FFF0000;

function D3DSHADER_COMMENT(dwordSize)
    local t1 = bit.lshift(dwordSize, D3DSI_COMMENTSIZE_SHIFT);
    local t2 = bit.band(t1, D3DSI_COMMENTSIZE_MASK);
    return bit.bor(t2, D3DSIO_COMMENT);
end

function D3DPS_END()
    return 0x0000FFFF;
end

function D3DVS_END()
    return 0x0000FFFF;
end

D3DBASIS_BEZIER                                 = 0;
D3DBASIS_BSPLINE                                = 1;
D3DBASIS_INTERPOLATE                            = 2;
D3DBASIS_FORCE_DWORD                            = 0x7fffffff;

D3DORDER_LINEAR                                 = 1;
D3DORDER_QUADRATIC                              = 2;
D3DORDER_CUBIC                                  = 3;
D3DORDER_QUINTIC                                = 5;
D3DORDER_FORCE_DWORD                            = 0x7fffffff;

D3DPATCHEDGE_DISCRETE                           = 0;
D3DPATCHEDGE_CONTINUOUS                         = 1;
D3DPATCHEDGE_FORCE_DWORD                        = 0x7fffffff;

D3DSBT_ALL                                      = 1;
D3DSBT_PIXELSTATE                               = 2;
D3DSBT_VERTEXSTATE                              = 3;
D3DSBT_FORCE_DWORD                              = 0x7fffffff;

D3DVBF_DISABLE                                  = 0;
D3DVBF_1WEIGHTS                                 = 1;
D3DVBF_2WEIGHTS                                 = 2;
D3DVBF_3WEIGHTS                                 = 3;
D3DVBF_TWEENING                                 = 255;
D3DVBF_0WEIGHTS                                 = 256;
D3DVBF_FORCE_DWORD                              = 0x7fffffff;

D3DTTFF_DISABLE                                 = 0;
D3DTTFF_COUNT1                                  = 1;
D3DTTFF_COUNT2                                  = 2;
D3DTTFF_COUNT3                                  = 3;
D3DTTFF_COUNT4                                  = 4;
D3DTTFF_PROJECTED                               = 256;
D3DTTFF_FORCE_DWORD                             = 0x7fffffff;

D3DFVF_TEXTUREFORMAT2                           = 0;
D3DFVF_TEXTUREFORMAT1                           = 3;
D3DFVF_TEXTUREFORMAT3                           = 1;
D3DFVF_TEXTUREFORMAT4                           = 2;

function D3DFVF_TEXCOORDSIZE3(CoordIndex)
    local t1 = (CoordIndex * 2 + 16);
    return bit.lshift(D3DFVF_TEXTUREFORMAT3, t1);
end

function D3DFVF_TEXCOORDSIZE2(CoordIndex)
    return D3DFVF_TEXTUREFORMAT2;
end

function D3DFVF_TEXCOORDSIZE4(CoordIndex)
    local t1 = (CoordIndex * 2 + 16);
    return bit.lshift(D3DFVF_TEXTUREFORMAT4, t1);
end

function D3DFVF_TEXCOORDSIZE1(CoordIndex)
    local t1 = (CoordIndex * 2 + 16);
    return bit.lshift(D3DFVF_TEXTUREFORMAT1, t1);
end

D3DDEVTYPE_HAL                                  = 1;
D3DDEVTYPE_REF                                  = 2;
D3DDEVTYPE_SW                                   = 3;
D3DDEVTYPE_FORCE_DWORD                          = 0x7fffffff

D3DMULTISAMPLE_NONE                             = 0;
D3DMULTISAMPLE_2_SAMPLES                        = 2;
D3DMULTISAMPLE_3_SAMPLES                        = 3;
D3DMULTISAMPLE_4_SAMPLES                        = 4;
D3DMULTISAMPLE_5_SAMPLES                        = 5;
D3DMULTISAMPLE_6_SAMPLES                        = 6;
D3DMULTISAMPLE_7_SAMPLES                        = 7;
D3DMULTISAMPLE_8_SAMPLES                        = 8;
D3DMULTISAMPLE_9_SAMPLES                        = 9;
D3DMULTISAMPLE_10_SAMPLES                       = 10;
D3DMULTISAMPLE_11_SAMPLES                       = 11;
D3DMULTISAMPLE_12_SAMPLES                       = 12;
D3DMULTISAMPLE_13_SAMPLES                       = 13;
D3DMULTISAMPLE_14_SAMPLES                       = 14;
D3DMULTISAMPLE_15_SAMPLES                       = 15;
D3DMULTISAMPLE_16_SAMPLES                       = 16;
D3DMULTISAMPLE_FORCE_DWORD                      = 0x7fffffff

function MAKEFOURCC(ch0, ch1, ch2, ch3)

    ch0 = string.byte(ch0);
    ch1 = string.byte(ch1);
    ch2 = string.byte(ch2);
    ch3 = string.byte(ch3);

    local t1 = bit.bor(ch0, bit.lshift(ch1, 8));
    local t2 = bit.lshift(ch2, 16);
    local t3 = bit.lshift(ch3, 24);
    local t4 = bit.bor(t2, t3);
    return bit.bor(t1, t4);
end

D3DFMT_UNKNOWN                                  = 0;
D3DFMT_R8G8B8                                   = 20;
D3DFMT_A8R8G8B8                                 = 21;
D3DFMT_X8R8G8B8                                 = 22;
D3DFMT_R5G6B5                                   = 23;
D3DFMT_X1R5G5B5                                 = 24;
D3DFMT_A1R5G5B5                                 = 25;
D3DFMT_A4R4G4B4                                 = 26;
D3DFMT_R3G3B2                                   = 27;
D3DFMT_A8                                       = 28;
D3DFMT_A8R3G3B2                                 = 29;
D3DFMT_X4R4G4B4                                 = 30;
D3DFMT_A2B10G10R10                              = 31;
D3DFMT_G16R16                                   = 34;
D3DFMT_A8P8                                     = 40;
D3DFMT_P8                                       = 41;
D3DFMT_L8                                       = 50;
D3DFMT_A8L8                                     = 51;
D3DFMT_A4L4                                     = 52;
D3DFMT_V8U8                                     = 60;
D3DFMT_L6V5U5                                   = 61;
D3DFMT_X8L8V8U8                                 = 62;
D3DFMT_Q8W8V8U8                                 = 63;
D3DFMT_V16U16                                   = 64;
D3DFMT_W11V11U10                                = 65;
D3DFMT_A2W10V10U10                              = 67;
D3DFMT_UYVY                                     = MAKEFOURCC('U', 'Y', 'V', 'Y');
D3DFMT_YUY2                                     = MAKEFOURCC('Y', 'U', 'Y', '2');
D3DFMT_DXT1                                     = MAKEFOURCC('D', 'X', 'T', '1');
D3DFMT_DXT2                                     = MAKEFOURCC('D', 'X', 'T', '2');
D3DFMT_DXT3                                     = MAKEFOURCC('D', 'X', 'T', '3');
D3DFMT_DXT4                                     = MAKEFOURCC('D', 'X', 'T', '4');
D3DFMT_DXT5                                     = MAKEFOURCC('D', 'X', 'T', '5');
D3DFMT_D16_LOCKABLE                             = 70;
D3DFMT_D32                                      = 71;
D3DFMT_D15S1                                    = 73;
D3DFMT_D24S8                                    = 75;
D3DFMT_D16                                      = 80;
D3DFMT_D24X8                                    = 77;
D3DFMT_D24X4S4                                  = 79;
D3DFMT_VERTEXDATA                               = 100;
D3DFMT_INDEX16                                  = 101;
D3DFMT_INDEX32                                  = 102;
D3DFMT_FORCE_DWORD                              = 0x7fffffff

D3DSWAPEFFECT_DISCARD                           = 1;
D3DSWAPEFFECT_FLIP                              = 2;
D3DSWAPEFFECT_COPY                              = 3;
D3DSWAPEFFECT_COPY_VSYNC                        = 4;
D3DSWAPEFFECT_FORCE_DWORD                       = 0x7fffffff

D3DPOOL_DEFAULT                                 = 0;
D3DPOOL_MANAGED                                 = 1;
D3DPOOL_SYSTEMMEM                               = 2;
D3DPOOL_SCRATCH                                 = 3;
D3DPOOL_FORCE_DWORD                             = 0x7fffffff

D3DPRESENT_RATE_DEFAULT                         = 0x00000000;
D3DPRESENT_RATE_UNLIMITED                       = 0x7fffffff;

D3DPRESENTFLAG_LOCKABLE_BACKBUFFER              = 0x00000001;

D3DBACKBUFFER_TYPE_MONO                         = 0;
D3DBACKBUFFER_TYPE_LEFT                         = 1;
D3DBACKBUFFER_TYPE_RIGHT                        = 2;
D3DBACKBUFFER_TYPE_FORCE_DWORD                  = 0x7fffffff

D3DRTYPE_SURFACE                                = 1;
D3DRTYPE_VOLUME                                 = 2;
D3DRTYPE_TEXTURE                                = 3;
D3DRTYPE_VOLUMETEXTURE                          = 4;
D3DRTYPE_CUBETEXTURE                            = 5;
D3DRTYPE_VERTEXBUFFER                           = 6;
D3DRTYPE_INDEXBUFFER                            = 7;
D3DRTYPE_FORCE_DWORD                            = 0x7fffffff;

D3DUSAGE_RENDERTARGET                           = 0x00000001;
D3DUSAGE_DEPTHSTENCIL                           = 0x00000002;

D3DUSAGE_WRITEONLY                              = 0x00000008;
D3DUSAGE_SOFTWAREPROCESSING                     = 0x00000010;
D3DUSAGE_DONOTCLIP                              = 0x00000020;
D3DUSAGE_POINTS                                 = 0x00000040;
D3DUSAGE_RTPATCHES                              = 0x00000080;
D3DUSAGE_NPATCHES                               = 0x00000100;
D3DUSAGE_DYNAMIC                                = 0x00000200;

D3DCUBEMAP_FACE_POSITIVE_X                      = 0;
D3DCUBEMAP_FACE_NEGATIVE_X                      = 1;
D3DCUBEMAP_FACE_POSITIVE_Y                      = 2;
D3DCUBEMAP_FACE_NEGATIVE_Y                      = 3;
D3DCUBEMAP_FACE_POSITIVE_Z                      = 4;
D3DCUBEMAP_FACE_NEGATIVE_Z                      = 5;
D3DCUBEMAP_FACE_FORCE_DWORD                     = 0x7fffffff;

D3DLOCK_READONLY                                = 0x00000010;
D3DLOCK_DISCARD                                 = 0x00002000;
D3DLOCK_NOOVERWRITE                             = 0x00001000;
D3DLOCK_NOSYSLOCK                               = 0x00000800;
D3DLOCK_NO_DIRTY_UPDATE                         = 0x00008000;

MAX_DEVICE_IDENTIFIER_STRING                    = 512;

D3DDMT_ENABLE                                   = 0;
D3DDMT_DISABLE                                  = 1;
D3DDMT_FORCE_DWORD                              = 0x7fffffff;

D3DDEVINFOID_RESOURCEMANAGER                    = 5;
D3DDEVINFOID_VERTEXSTATS                        = 6;

D3DRTYPECOUNT                                   = 8;

----------------------------------------------------------------------------------------------------
--
-- Direct3D Object Wrappers
--
----------------------------------------------------------------------------------------------------

local d3d_IDirect3DResource8_mt =
{
    _this = nil,

    -- Properties
    Get = function(self)
        return self._this;
    end,

    -- IUnknown
    QueryInterface = function(self, iid)
        return ashita.d3d8dev.IDirect3DResource8_QueryInterface(self._this, iid);
    end,
    AddRef = function(self)
        return ashita.d3d8dev.IDirect3DResource8_AddRef(self._this);
    end,
    Release = function(self)
        local count = ashita.d3d8dev.IDirect3DResource8_Release(self._this);
        if (count <= 0) then
            self._this = nil;
        end
        return count;
    end,

    -- IDirect3DResource8
    SetPrivateData = function(self, refguid, data, sizeOfData, flags)
        return ashita.d3d8dev.IDirect3DResource8_SetPrivateData(self._this, refguid, data, sizeOfData, flags);
    end,
    GetPrivateData = function(self, refguid)
        return ashita.d3d8dev.IDirect3DResource8_GetPrivateData(self._this, refguid);
    end,
    FreePrivateData = function(self, refguid)
        return ashita.d3d8dev.IDirect3DResource8_FreePrivateData(self._this, refguid);
    end,
    SetPriority = function(self, priority)
        return ashita.d3d8dev.IDirect3DResource8_SetPriority(self._this, priority);
    end,
    GetPriority = function(self)
        return ashita.d3d8dev.IDirect3DResource8_GetPriority(self._this);
    end,
    PreLoad = function(self)
        return ashita.d3d8dev.IDirect3DResource8_PreLoad(self._this);
    end,
    GetType = function(self)
        return ashita.d3d8dev.IDirect3DResource8_GetType(self._this);
    end
};
local d3d_IDirect3DBaseTexture8_mt =
{
    _this = nil,

    -- Properties
    Get = function(self)
        return self._this;
    end,

    -- IUnknown
    QueryInterface = function(self, iid)
        return ashita.d3d8dev.IDirect3DResource8_QueryInterface(self._this, iid);
    end,
    AddRef = function(self)
        return ashita.d3d8dev.IDirect3DResource8_AddRef(self._this);
    end,
    Release = function(self)
        local count = ashita.d3d8dev.IDirect3DResource8_Release(self._this);
        if (count <= 0) then
            self._this = nil;
        end
        return count;
    end,

    -- IDirect3DResource8
    SetPrivateData = function(self, refguid, data, sizeOfData, flags)
        return ashita.d3d8dev.IDirect3DResource8_SetPrivateData(self._this, refguid, data, sizeOfData, flags);
    end,
    GetPrivateData = function(self, refguid)
        return ashita.d3d8dev.IDirect3DResource8_GetPrivateData(self._this, refguid);
    end,
    FreePrivateData = function(self, refguid)
        return ashita.d3d8dev.IDirect3DResource8_FreePrivateData(self._this, refguid);
    end,
    SetPriority = function(self, priority)
        return ashita.d3d8dev.IDirect3DResource8_SetPriority(self._this, priority);
    end,
    GetPriority = function(self)
        return ashita.d3d8dev.IDirect3DResource8_GetPriority(self._this);
    end,
    PreLoad = function(self)
        return ashita.d3d8dev.IDirect3DResource8_PreLoad(self._this);
    end,
    GetType = function(self)
        return ashita.d3d8dev.IDirect3DResource8_GetType(self._this);
    end,

    -- IDirect3DBaseTexture8
    SetLOD = function(self, lodNew)
        return ashita.d3d8dev.IDirect3DBaseTexture8_SetLOD(self._this, lodNew);
    end,
    GetLOD = function(self)
        return ashita.d3d8dev.IDirect3DBaseTexture8_GetLOD(self._this)
    end,
    GetLevelCount = function(self)
        return ashita.d3d8dev.IDirect3DBaseTexture8_GetLevelCount(self._this)
    end
};
local d3d_IDirect3DTexture8_mt =
{
    _this = nil,

    -- Properties
    Get = function(self)
        return self._this;
    end,

    -- IUnknown
    QueryInterface = function(self, iid)
        return ashita.d3d8dev.IDirect3DResource8_QueryInterface(self._this, iid);
    end,
    AddRef = function(self)
        return ashita.d3d8dev.IDirect3DResource8_AddRef(self._this);
    end,
    Release = function(self)
        local count = ashita.d3d8dev.IDirect3DResource8_Release(self._this);
        if (count <= 0) then
            self._this = nil;
        end
        return count;
    end,

    -- IDirect3DResource8
    SetPrivateData = function(self, refguid, data, sizeOfData, flags)
        return ashita.d3d8dev.IDirect3DResource8_SetPrivateData(self._this, refguid, data, sizeOfData, flags);
    end,
    GetPrivateData = function(self, refguid)
        return ashita.d3d8dev.IDirect3DResource8_GetPrivateData(self._this, refguid);
    end,
    FreePrivateData = function(self, refguid)
        return ashita.d3d8dev.IDirect3DResource8_FreePrivateData(self._this, refguid);
    end,
    SetPriority = function(self, priority)
        return ashita.d3d8dev.IDirect3DResource8_SetPriority(self._this, priority);
    end,
    GetPriority = function(self)
        return ashita.d3d8dev.IDirect3DResource8_GetPriority(self._this);
    end,
    PreLoad = function(self)
        return ashita.d3d8dev.IDirect3DResource8_PreLoad(self._this);
    end,
    GetType = function(self)
        return ashita.d3d8dev.IDirect3DResource8_GetType(self._this);
    end,

    -- IDirect3DBaseTexture8
    SetLOD = function(self, lodNew)
        return ashita.d3d8dev.IDirect3DBaseTexture8_SetLOD(self._this, lodNew);
    end,
    GetLOD = function(self)
        return ashita.d3d8dev.IDirect3DBaseTexture8_GetLOD(self._this)
    end,
    GetLevelCount = function(self)
        return ashita.d3d8dev.IDirect3DBaseTexture8_GetLevelCount(self._this)
    end,

    -- IDirect3DTexture8
    GetLevelDesc = function(self, level)
        return ashita.d3d8dev.IDirect3DTexture8_GetLevelDesc(self._this, level);
    end,
    GetSurfaceLevel = function(self, level)
        return ashita.d3d8dev.IDirect3DTexture8_GetSurfaceLevel(self._this, level);
    end,
    LockRect = function(self, level, rect, flags)
        return ashita.d3d8dev.IDirect3DTexture8_LockRect(self._this, level, rect, flags);
    end,
    UnlockRect = function(self, level)
        return ashita.d3d8dev.IDirect3DTexture8_UnlockRect(self._this, level);
    end,
    AddDirtyRect = function(self, rect)
        return ashita.d3d8dev.IDirect3DTexture8_AddDirtyRect(self._this, rect);
    end
};
local d3d_IDirect3DVolumeTexture8_mt =
{
    _this = nil,

    -- Properties
    Get = function(self)
        return self._this;
    end,

    -- IUnknown
    QueryInterface = function(self, iid)
        return ashita.d3d8dev.IDirect3DResource8_QueryInterface(self._this, iid);
    end,
    AddRef = function(self)
        return ashita.d3d8dev.IDirect3DResource8_AddRef(self._this);
    end,
    Release = function(self)
        local count = ashita.d3d8dev.IDirect3DResource8_Release(self._this);
        if (count <= 0) then
            self._this = nil;
        end
        return count;
    end,

    -- IDirect3DResource8
    SetPrivateData = function(self, refguid, data, sizeOfData, flags)
        return ashita.d3d8dev.IDirect3DResource8_SetPrivateData(self._this, refguid, data, sizeOfData, flags);
    end,
    GetPrivateData = function(self, refguid)
        return ashita.d3d8dev.IDirect3DResource8_GetPrivateData(self._this, refguid);
    end,
    FreePrivateData = function(self, refguid)
        return ashita.d3d8dev.IDirect3DResource8_FreePrivateData(self._this, refguid);
    end,
    SetPriority = function(self, priority)
        return ashita.d3d8dev.IDirect3DResource8_SetPriority(self._this, priority);
    end,
    GetPriority = function(self)
        return ashita.d3d8dev.IDirect3DResource8_GetPriority(self._this);
    end,
    PreLoad = function(self)
        return ashita.d3d8dev.IDirect3DResource8_PreLoad(self._this);
    end,
    GetType = function(self)
        return ashita.d3d8dev.IDirect3DResource8_GetType(self._this);
    end,

    -- IDirect3DBaseTexture8
    SetLOD = function(self, lodNew)
        return ashita.d3d8dev.IDirect3DBaseTexture8_SetLOD(self._this, lodNew);
    end,
    GetLOD = function(self)
        return ashita.d3d8dev.IDirect3DBaseTexture8_GetLOD(self._this)
    end,
    GetLevelCount = function(self)
        return ashita.d3d8dev.IDirect3DBaseTexture8_GetLevelCount(self._this)
    end,

    -- IDirect3DVolumeTexture8
    GetLevelDesc = function(self, level)
        return ashita.d3d8dev.IDirect3DVolumeTexture8_GetLevelDesc(self._this, level);
    end,
    GetVolumeLevel = function(self, level)
        return ashita.d3d8dev.IDirect3DVolumeTexture8_GetVolumeLevel(self._this, level);
    end,
    LockBox = function(self, level, box, flags)
        return ashita.d3d8dev.IDirect3DVolumeTexture8_LockBox(self._this, level, box, flags);
    end,
    UnlockBox = function(self, level)
        return ashita.d3d8dev.IDirect3DVolumeTexture8_UnlockBox(self._this, level);
    end,
    AddDirtyBox = function(self, dirtybox)
        return ashita.d3d8dev.IDirect3DVolumeTexture8_AddDirtyBox(self._this, dirtybox);
    end
};
local d3d_IDirect3DCubeTexture8_mt =
{
    _this = nil,

    -- Properties
    Get = function(self)
        return self._this;
    end,

    -- IUnknown
    QueryInterface = function(self, iid)
        return ashita.d3d8dev.IDirect3DResource8_QueryInterface(self._this, iid);
    end,
    AddRef = function(self)
        return ashita.d3d8dev.IDirect3DResource8_AddRef(self._this);
    end,
    Release = function(self)
        local count = ashita.d3d8dev.IDirect3DResource8_Release(self._this);
        if (count <= 0) then
            self._this = nil;
        end
        return count;
    end,

    -- IDirect3DResource8
    SetPrivateData = function(self, refguid, data, sizeOfData, flags)
        return ashita.d3d8dev.IDirect3DResource8_SetPrivateData(self._this, refguid, data, sizeOfData, flags);
    end,
    GetPrivateData = function(self, refguid)
        return ashita.d3d8dev.IDirect3DResource8_GetPrivateData(self._this, refguid);
    end,
    FreePrivateData = function(self, refguid)
        return ashita.d3d8dev.IDirect3DResource8_FreePrivateData(self._this, refguid);
    end,
    SetPriority = function(self, priority)
        return ashita.d3d8dev.IDirect3DResource8_SetPriority(self._this, priority);
    end,
    GetPriority = function(self)
        return ashita.d3d8dev.IDirect3DResource8_GetPriority(self._this);
    end,
    PreLoad = function(self)
        return ashita.d3d8dev.IDirect3DResource8_PreLoad(self._this);
    end,
    GetType = function(self)
        return ashita.d3d8dev.IDirect3DResource8_GetType(self._this);
    end,

    -- IDirect3DBaseTexture8
    SetLOD = function(self, lodNew)
        return ashita.d3d8dev.IDirect3DBaseTexture8_SetLOD(self._this, lodNew);
    end,
    GetLOD = function(self)
        return ashita.d3d8dev.IDirect3DBaseTexture8_GetLOD(self._this);
    end,
    GetLevelCount = function(self)
        return ashita.d3d8dev.IDirect3DBaseTexture8_GetLevelCount(self._this);
    end,

    -- IDirect3DCubeTexture8
    GetLevelDesc = function(self, level)
        return ashita.d3d8dev.IDirect3DCubeTexture8_GetLevelDesc(self._this, level);
    end,
    GetCubeMapSurface = function(self, facetype, level)
        return ashita.d3d8dev.IDirect3DCubeTexture8_GetCubeMapSurface(self._this, facetype, level);
    end,
    LockRect = function(self, facetype, level, rect, flags)
        return ashita.d3d8dev.IDirect3DCubeTexture8_LockRect(self._this, facetype, level, rect, flags);
    end,
    UnlockRect = function(self, facetype, level)
        return ashita.d3d8dev.IDirect3DCubeTexture8_UnlockRect(self._this, facetype, level);
    end,
    AddDirtyRect = function(self, facetype, dirtyrect)
        return ashita.d3d8dev.IDirect3DCubeTexture8_AddDirtyRect(self._this, facetype, dirtyrect);
    end
};
local d3d_IDirect3DVertexBuffer8_mt =
{
    _this = nil,

    -- Properties
    Get = function(self)
        return self._this;
    end,

    -- IUnknown
    QueryInterface = function(self, iid)
        return ashita.d3d8dev.IDirect3DResource8_QueryInterface(self._this, iid);
    end,
    AddRef = function(self)
        return ashita.d3d8dev.IDirect3DResource8_AddRef(self._this);
    end,
    Release = function(self)
        local count = ashita.d3d8dev.IDirect3DResource8_Release(self._this);
        if (count <= 0) then
            self._this = nil;
        end
        return count;
    end,

    -- IDirect3DResource8
    SetPrivateData = function(self, refguid, data, sizeOfData, flags)
        return ashita.d3d8dev.IDirect3DResource8_SetPrivateData(self._this, refguid, data, sizeOfData, flags);
    end,
    GetPrivateData = function(self, refguid)
        return ashita.d3d8dev.IDirect3DResource8_GetPrivateData(self._this, refguid);
    end,
    FreePrivateData = function(self, refguid)
        return ashita.d3d8dev.IDirect3DResource8_FreePrivateData(self._this, refguid);
    end,
    SetPriority = function(self, priority)
        return ashita.d3d8dev.IDirect3DResource8_SetPriority(self._this, priority);
    end,
    GetPriority = function(self)
        return ashita.d3d8dev.IDirect3DResource8_GetPriority(self._this);
    end,
    PreLoad = function(self)
        return ashita.d3d8dev.IDirect3DResource8_PreLoad(self._this);
    end,
    GetType = function(self)
        return ashita.d3d8dev.IDirect3DResource8_GetType(self._this);
    end,

    -- IDirect3DVertexBuffer8
    Lock = function(self, offsetToLock, sizeToLock, flags)
        return ashita.d3d8dev.IDirect3DVertexBuffer8_Lock(self._this, offsetToLock, sizeToLock, flags);
    end,
    Unlock = function(self)
        return ashita.d3d8dev.IDirect3DVertexBuffer8_Unlock(self._this);
    end,
    GetDesc = function(self)
        return ashita.d3d8dev.IDirect3DVertexBuffer8_GetDesc(self._this);
    end
};
local d3d_IDirect3DIndexBuffer8_mt =
{
    _this = nil,

    -- Properties
    Get = function(self)
        return self._this;
    end,

    -- IUnknown
    QueryInterface = function(self, iid)
        return ashita.d3d8dev.IDirect3DResource8_QueryInterface(self._this, iid);
    end,
    AddRef = function(self)
        return ashita.d3d8dev.IDirect3DResource8_AddRef(self._this);
    end,
    Release = function(self)
        local count = ashita.d3d8dev.IDirect3DResource8_Release(self._this);
        if (count <= 0) then
            self._this = nil;
        end
        return count;
    end,

    -- IDirect3DResource8
    SetPrivateData = function(self, refguid, data, sizeOfData, flags)
        return ashita.d3d8dev.IDirect3DResource8_SetPrivateData(self._this, refguid, data, sizeOfData, flags);
    end,
    GetPrivateData = function(self, refguid)
        return ashita.d3d8dev.IDirect3DResource8_GetPrivateData(self._this, refguid);
    end,
    FreePrivateData = function(self, refguid)
        return ashita.d3d8dev.IDirect3DResource8_FreePrivateData(self._this, refguid);
    end,
    SetPriority = function(self, priority)
        return ashita.d3d8dev.IDirect3DResource8_SetPriority(self._this, priority);
    end,
    GetPriority = function(self)
        return ashita.d3d8dev.IDirect3DResource8_GetPriority(self._this);
    end,
    PreLoad = function(self)
        return ashita.d3d8dev.IDirect3DResource8_PreLoad(self._this);
    end,
    GetType = function(self)
        return ashita.d3d8dev.IDirect3DResource8_GetType(self._this);
    end,

    -- IDirect3DIndexBuffer8
    Lock = function(self, offsetToLock, sizeToLock, flags)
        return ashita.d3d8dev.IDirect3DIndexBuffer8_Lock(self._this, offsetToLock, sizeToLock, flags);
    end,
    Unlock = function(self)
        return ashita.d3d8dev.IDirect3DIndexBuffer8_Unlock(self._this);
    end,
    GetDesc = function(self)
        return ashita.d3d8dev.IDirect3DIndexBuffer8_GetDesc(self._this);
    end
};
local d3d_IDirect3DSurface8_mt =
{
    _this = nil,

    -- Properties
    Get = function(self)
        return self._this;
    end,

    -- IUnknown
    QueryInterface = function(self, iid)
        return ashita.d3d8dev.IDirect3DSurface8_QueryInterface(self._this, iid);
    end,
    AddRef = function(self)
        return ashita.d3d8dev.IDirect3DSurface8_AddRef(self._this);
    end,
    Release = function(self)
        return ashita.d3d8dev.IDirect3DSurface8_Release(self._this);
    end,

    -- IDirect3DSurface8
    SetPrivateData = function(self, refguid, data, sizeOfData, flags)
        return ashita.d3d8dev.IDirect3DSurface8_SetPrivateData(self._this, refguid, data, sizeOfData, flags);
    end,
    GetPrivateData = function(self, refguid)
        return ashita.d3d8dev.IDirect3DSurface8_GetPrivateData(self._this, refguid);
    end,
    FreePrivateData = function(self, refguid)
        return ashita.d3d8dev.IDirect3DSurface8_FreePrivateData(self._this, refguid);
    end,
    GetContainer = function(self, riid)
        return ashita.d3d8dev.IDirect3DSurface8_GetContainer(self._this, riid);
    end,
    GetDesc = function(self)
        return ashita.d3d8dev.IDirect3DSurface8_GetDesc(self._this);
    end,
    LockRect = function(self, rect, flags)
        return ashita.d3d8dev.IDirect3DSurface8_LockRect(self._this, rect, flags);
    end,
    UnlockRect = function(self)
        return ashita.d3d8dev.IDirect3DSurface8_UnlockRect(self._this);
    end
};
local d3d_IDirect3DVolume8_mt =
{
    _this = nil,

    -- Properties
    Get = function(self)
        return self._this;
    end,

    -- IUnknown
    QueryInterface = function(self, iid)
        return ashita.d3d8dev.IDirect3DSurface8_QueryInterface(self._this, iid);
    end,
    AddRef = function(self)
        return ashita.d3d8dev.IDirect3DSurface8_AddRef(self._this);
    end,
    Release = function(self)
        return ashita.d3d8dev.IDirect3DSurface8_Release(self._this);
    end,

    -- IDirect3DVolume8
    SetPrivateData = function(self, refguid, data, sizeOfData, flags)
        return ashita.d3d8dev.IDirect3DVolume8_SetPrivateData(self._this, refguid, data, sizeOfData, flags);
    end,
    GetPrivateData = function(self, refguid)
        return ashita.d3d8dev.IDirect3DVolume8_GetPrivateData(self._this, refguid);
    end,
    FreePrivateData = function(self, refguid)
        return ashita.d3d8dev.IDirect3DVolume8_FreePrivateData(self._this, refguid);
    end,
    GetContainer = function(self, riid)
        return ashita.d3d8dev.IDirect3DVolume8_GetContainer(self._this, riid);
    end,
    GetDesc = function(self)
        return ashita.d3d8dev.IDirect3DVolume8_GetDesc(self._this);
    end,
    LockBox = function(self, box, flags)
        return ashita.d3d8dev.IDirect3DVolume8_LockBox(self._this, rect, flags);
    end,
    UnlockBox = function(self)
        return ashita.d3d8dev.IDirect3DVolume8_UnlockBox(self._this);
    end
};

----------------------------------------------------------------------------------------------------
-- Direct3D Wrapper Tables
----------------------------------------------------------------------------------------------------
IDirect3DResource8Wrapper       = { };
IDirect3DBaseTexture8Wrapper    = { };
IDirect3DTexture8Wrapper        = { };
IDirect3DVolumeTexture8Wrapper  = { };
IDirect3DCubeTexture8Wrapper    = { };
IDirect3DVertexBuffer8Wrapper   = { };
IDirect3DIndexBuffer8Wrapper    = { };
IDirect3DSurface8Wrapper        = { };
IDirect3DVolume8Wrapper         = { };

----------------------------------------------------------------------------------------------------
-- func: IDirect3DResource8Wrapper.wrap
-- desc: Wraps an existing IDirect3DResource8 object.
----------------------------------------------------------------------------------------------------
IDirect3DResource8Wrapper.wrap = function(o)
    if (o == nil) then
        error('IDirect3DResource8Wrapper.wrap - o is invalid, cannot wrap.');
    end

    local r = { };
    r._this = o;

    d3d_IDirect3DResource8_mt.__index = d3d_IDirect3DResource8_mt;
    setmetatable(r, d3d_IDirect3DResource8_mt);

    return r;
end

----------------------------------------------------------------------------------------------------
-- func: IDirect3DBaseTexture8Wrapper.wrap
-- desc: Wraps an existing IDirect3DBaseTexture8 object.
----------------------------------------------------------------------------------------------------
IDirect3DBaseTexture8Wrapper.wrap = function(o)
    if (o == nil) then
        error('IDirect3DBaseTexture8Wrapper.wrap - o is invalid, cannot wrap.');
    end

    local r = { };
    r._this = o;

    d3d_IDirect3DBaseTexture8_mt.__index = d3d_IDirect3DBaseTexture8_mt;
    setmetatable(r, d3d_IDirect3DBaseTexture8_mt);

    return r;
end

----------------------------------------------------------------------------------------------------
-- func: IDirect3DTexture8Wrapper.wrap
-- desc: Wraps an existing IDirect3DTexture8 object.
----------------------------------------------------------------------------------------------------
IDirect3DTexture8Wrapper.wrap = function(o)
    if (o == nil) then
        error('IDirect3DTexture8Wrapper.wrap - o is invalid, cannot wrap.');
    end

    local r = { };
    r._this = o;

    d3d_IDirect3DTexture8_mt.__index = d3d_IDirect3DTexture8_mt;
    setmetatable(r, d3d_IDirect3DTexture8_mt);

    return r;
end

----------------------------------------------------------------------------------------------------
-- func: IDirect3DVolumeTexture8Wrapper.wrap
-- desc: Wraps an existing IDirect3DVolumeTexture8 object.
----------------------------------------------------------------------------------------------------
IDirect3DVolumeTexture8Wrapper.wrap = function(o)
    if (o == nil) then
        error('IDirect3DVolumeTexture8Wrapper.wrap - o is invalid, cannot wrap.');
    end

    local r = { };
    r._this = o;

    d3d_IDirect3DVolumeTexture8_mt.__index = d3d_IDirect3DVolumeTexture8_mt;
    setmetatable(r, d3d_IDirect3DVolumeTexture8_mt);

    return r;
end

----------------------------------------------------------------------------------------------------
-- func: IDirect3DCubeTexture8Wrapper.wrap
-- desc: Wraps an existing IDirect3DCubeTexture8 object.
----------------------------------------------------------------------------------------------------
IDirect3DCubeTexture8Wrapper.wrap = function(o)
    if (o == nil) then
        error('IDirect3DCubeTexture8Wrapper.wrap - o is invalid, cannot wrap.');
    end

    local r = { };
    r._this = o;

    d3d_IDirect3DCubeTexture8_mt.__index = d3d_IDirect3DCubeTexture8_mt;
    setmetatable(r, d3d_IDirect3DCubeTexture8_mt);

    return r;
end

----------------------------------------------------------------------------------------------------
-- func: IDirect3DVertexBuffer8Wrapper.wrap
-- desc: Wraps an existing IDirect3DVertexBuffer8 object.
----------------------------------------------------------------------------------------------------
IDirect3DVertexBuffer8Wrapper.wrap = function(o)
    if (o == nil) then
        error('IDirect3DVertexBuffer8Wrapper.wrap - o is invalid, cannot wrap.');
    end

    local r = { };
    r._this = o;

    d3d_IDirect3DVertexBuffer8_mt.__index = d3d_IDirect3DVertexBuffer8_mt;
    setmetatable(r, d3d_IDirect3DVertexBuffer8_mt);

    return r;
end

----------------------------------------------------------------------------------------------------
-- func: IDirect3DIndexBuffer8Wrapper.wrap
-- desc: Wraps an existing IDirect3DIndexBuffer8 object.
----------------------------------------------------------------------------------------------------
IDirect3DIndexBuffer8Wrapper.wrap = function(o)
    if (o == nil) then
        error('IDirect3DIndexBuffer8Wrapper.wrap - o is invalid, cannot wrap.');
    end

    local r = { };
    r._this = o;

    d3d_IDirect3DIndexBuffer8_mt.__index = d3d_IDirect3DIndexBuffer8_mt;
    setmetatable(r, d3d_IDirect3DIndexBuffer8_mt);

    return r;
end

----------------------------------------------------------------------------------------------------
-- func: IDirect3DSurface8Wrapper.wrap
-- desc: Wraps an existing IDirect3DSurface8 object.
----------------------------------------------------------------------------------------------------
IDirect3DSurface8Wrapper.wrap = function(o)
    if (o == nil) then
        error('IDirect3DSurface8Wrapper.wrap - o is invalid, cannot wrap.');
    end

    local r = { };
    r._this = o;

    d3d_IDirect3DSurface8_mt.__index = d3d_IDirect3DSurface8_mt;
    setmetatable(r, d3d_IDirect3DSurface8_mt);

    return r;
end

----------------------------------------------------------------------------------------------------
-- func: IDirect3DVolume8Wrapper.wrap
-- desc: Wraps an existing IDirect3DVolume8 object.
----------------------------------------------------------------------------------------------------
IDirect3DVolume8Wrapper.wrap = function(o)
    if (o == nil) then
        error('IDirect3DVolume8Wrapper.wrap - o is invalid, cannot wrap.');
    end

    local r = { };
    r._this = o;

    d3d_IDirect3DVolume8_mt.__index = d3d_IDirect3DVolume8_mt;
    setmetatable(r, d3d_IDirect3DVolume8_mt);

    return r;
end

----------------------------------------------------------------------------------------------------
--
-- Direct3DX Object Wrappers
--
----------------------------------------------------------------------------------------------------

local d3dx_buffer_mt =
{
    _this = nil,

    -- Properties
    Get = function(self)
        return self._this;
    end,

    -- IUnknown
    QueryInterface = function(self, iid)
        return ashita.d3dx.ID3DXBuffer_QueryInterface(self._this, iid);
    end,
    AddRef = function(self)
        return ashita.d3dx.ID3DXBuffer_AddRef(self._this);
    end,
    Release = function(self)
        local count = ashita.d3dx.ID3DXBuffer_Release(self._this);
        if (count <= 0) then
            self._this = nil;
        end
        return count;
    end,
    
    -- ID3DXBuffer
    GetBufferPointer = function(self)
        return ashita.d3dx.ID3DXBuffer_GetBufferPointer(self._this);
    end,
    GetBufferSize = function(self)
        return ashita.d3dx.ID3DXBuffer_GetBufferSize(self._this);
    end
};

local d3dx_font_mt =
{
    _this = nil,

    __gc = function(self)
        print('FONT WAS GARBAGE COLLECTED!!!');
    end, 

    -- Properties
    Get = function(self)
        return self._this;
    end,

    -- IUnknown
    QueryInterface = function(self, iid)
        return ashita.d3dx.ID3DXFont_QueryInterface(self._this, iid);
    end,
    AddRef = function(self)
        return ashita.d3dx.ID3DXFont_AddRef(self._this);
    end,
    Release = function(self)
        local count = ashita.d3dx.ID3DXFont_Release(self._this);
        if (count <= 0) then
            self._this = nil;
        end
        return count;
    end,

    -- ID3DXFont
    GetLogFont = function(self)
        return ashita.d3dx.ID3DXFont_GetLogFont(self._this);
    end,
    Begin = function(self)
        return ashita.d3dx.ID3DXFont_Begin(self._this);
    end,
    DrawTextA = function(self, str, count, rect, format, color)
        return ashita.d3dx.ID3DXFont_DrawTextA(self._this, str, count, rect, format, color);
    end,
    End = function(self)
        return ashita.d3dx.ID3DXFont_End(self._this);
    end,
};

local d3dx_sprite_mt =
{
    _this = nil,

    -- Properties
    Get = function(self)
        return self._this;
    end,

    -- IUnknown
    QueryInterface = function(self, iid)
        return ashita.d3dx.ID3DXSprite_QueryInterface(self._this, iid);
    end,
    AddRef = function(self)
        return ashita.d3dx.ID3DXSprite_AddRef(self._this);
    end,
    Release = function(self)
        local count = ashita.d3dx.ID3DXSprite_Release(self._this);
        if (count <= 0) then
            self._this = nil;
        end
        return count;
    end,

    -- ID3DXSprite
    Begin = function(self)
        return ashita.d3dx.ID3DXSprite_Begin(self._this);
    end,
    Draw = function(self, srcTexture, srcRect, scaling, rotationCenter, rotation, translation, color)
        return ashita.d3dx.ID3DXSprite_Draw(self._this, srcTexture, srcRect, scaling, rotationCenter, rotation, translation, color);
    end,
    DrawTransform = function(self, srcTexture, srcRect, transform, color)
        return ashita.d3dx.ID3DXSprite_DrawTransform(self._this, srcTexture, srcRect, transform, color);
    end,
    End = function(self)
        return ashita.d3dx.ID3DXSprite_End(self._this);
    end
};

----------------------------------------------------------------------------------------------------
-- Direct3DX Wrapper Tables
----------------------------------------------------------------------------------------------------
ID3DXBufferWrapper  = { };
ID3DXFontWrapper    = { };
ID3DXSpriteWrapper  = { };

----------------------------------------------------------------------------------------------------
-- func: ID3DXBufferWrapper.wrap
-- desc: Wraps an existing ID3DXBuffer object.
----------------------------------------------------------------------------------------------------
ID3DXBufferWrapper.wrap = function(b)
    if (b == nil) then
        error('ID3DXBufferWrapper.wrap - b is invalid; cannot wrap.');
    end
    
    local buffer = { };
    buffer._this = b;
    
    d3dx_buffer_mt.__index = d3dx_buffer_mt;
    setmetatable(buffer, d3dx_buffer_mt);

    return buffer;
end

----------------------------------------------------------------------------------------------------
-- func: ID3DXFontWrapper.wrap
-- desc: Wraps an existing ID3DXFont object.
----------------------------------------------------------------------------------------------------
ID3DXFontWrapper.wrap = function(f)
    if (f == nil) then
        error('ID3DXFontWrapper.new - f is invalid; cannot wrap.');
    end

    local font = { };
    font._this = f;
    
    d3dx_font_mt.__index = d3dx_font_mt;
    setmetatable(font, d3dx_font_mt);

    return font;
end

----------------------------------------------------------------------------------------------------
-- func: ID3DXSpriteWrapper.wrap
-- desc: Wraps an existing ID3DXSprite object.
----------------------------------------------------------------------------------------------------
ID3DXSpriteWrapper.wrap = function (s)
    if (s == nil) then
        error('Failed to create new ID3DXSpriteWrapper, sprite must not be null.');
    end

    local sprite = { };
    sprite._this = s;

    d3dx_sprite_mt.__index = d3dx_sprite_mt;
    setmetatable(sprite, d3dx_sprite_mt);

    return sprite;
end