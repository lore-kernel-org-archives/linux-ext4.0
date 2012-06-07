From: Ryan Wang <openspace.wang@gmail.com>
Subject: How to understand super.c/descriptor_loc for ext2/ext3/ext4?
Date: Thu, 7 Jun 2012 21:37:07 +0800
Message-ID: <CAPxxNQmj0rUav4ssNTXfQ7xy2tnFk2mY9G4S098m2=71-0DvuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4225155415163879039=="
To: linux-ext4@vger.kernel.org, kernelnewbies@kernelnewbies.org
Return-path: <kernelnewbies-bounces@kernelnewbies.org>
List-Unsubscribe: <http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies>,
	<mailto:kernelnewbies-request@kernelnewbies.org?subject=unsubscribe>
List-Archive: <http://lists.kernelnewbies.org/pipermail/kernelnewbies>
List-Post: <mailto:kernelnewbies@kernelnewbies.org>
List-Help: <mailto:kernelnewbies-request@kernelnewbies.org?subject=help>
List-Subscribe: <http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies>,
	<mailto:kernelnewbies-request@kernelnewbies.org?subject=subscribe>
Sender: kernelnewbies-bounces@kernelnewbies.org
Errors-To: kernelnewbies-bounces@kernelnewbies.org
List-Id: linux-ext4.vger.kernel.org

--===============4225155415163879039==
Content-Type: multipart/alternative; boundary=90e6ba6153dad7b4bf04c1e1fa59

--90e6ba6153dad7b4bf04c1e1fa59
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I'm reading the source code for ext2/ext3/ext4, and cannot figure
out how descriptor_loc() runs:

1600 <http://lxr.linux.no/linux+*/fs/ext3/super.c#L1600>static
ext3_fsblk_t <http://lxr.linux.no/linux+*/+code=ext3_fsblk_t>
descriptor_loc <http://lxr.linux.no/linux+*/+code=descriptor_loc>(struct
super_block <http://lxr.linux.no/linux+*/+code=super_block> *sb
<http://lxr.linux.no/linux+*/+code=sb>,1601
<http://lxr.linux.no/linux+*/fs/ext3/super.c#L1601>
                ext3_fsblk_t
<http://lxr.linux.no/linux+*/+code=ext3_fsblk_t> logic_sb_block
<http://lxr.linux.no/linux+*/+code=logic_sb_block>,1602
<http://lxr.linux.no/linux+*/fs/ext3/super.c#L1602>
                int nr <http://lxr.linux.no/linux+*/+code=nr>)1603
<http://lxr.linux.no/linux+*/fs/ext3/super.c#L1603>{1604
<http://lxr.linux.no/linux+*/fs/ext3/super.c#L1604>        struct
ext3_sb_info <http://lxr.linux.no/linux+*/+code=ext3_sb_info> *sbi
<http://lxr.linux.no/linux+*/+code=sbi> = EXT3_SB
<http://lxr.linux.no/linux+*/+code=EXT3_SB>(sb
<http://lxr.linux.no/linux+*/+code=sb>);1605
<http://lxr.linux.no/linux+*/fs/ext3/super.c#L1605>        unsigned
long bg <http://lxr.linux.no/linux+*/+code=bg>, first_meta_bg
<http://lxr.linux.no/linux+*/+code=first_meta_bg>;1606
<http://lxr.linux.no/linux+*/fs/ext3/super.c#L1606>        int
has_super <http://lxr.linux.no/linux+*/+code=has_super> = 0;1607
<http://lxr.linux.no/linux+*/fs/ext3/super.c#L1607>1608
<http://lxr.linux.no/linux+*/fs/ext3/super.c#L1608>
first_meta_bg <http://lxr.linux.no/linux+*/+code=first_meta_bg> =
le32_to_cpu <http://lxr.linux.no/linux+*/+code=le32_to_cpu>(sbi
<http://lxr.linux.no/linux+*/+code=sbi>->s_es
<http://lxr.linux.no/linux+*/+code=s_es>->s_first_meta_bg
<http://lxr.linux.no/linux+*/+code=s_first_meta_bg>);

1) Who can setup the field ->s_first_meta_bg, mke2fs? And what does it mean?
   What's a meta block group?

1609 <http://lxr.linux.no/linux+*/fs/ext3/super.c#L1609>1610
<http://lxr.linux.no/linux+*/fs/ext3/super.c#L1610>        if
(!EXT3_HAS_INCOMPAT_FEATURE
<http://lxr.linux.no/linux+*/+code=EXT3_HAS_INCOMPAT_FEATURE>(sb
<http://lxr.linux.no/linux+*/+code=sb>, EXT3_FEATURE_INCOMPAT_META_BG
<http://lxr.linux.no/linux+*/+code=EXT3_FEATURE_INCOMPAT_META_BG>)
||1611 <http://lxr.linux.no/linux+*/fs/ext3/super.c#L1611>
nr <http://lxr.linux.no/linux+*/+code=nr> < first_meta_bg
<http://lxr.linux.no/linux+*/+code=first_meta_bg>)
2) In which case, we can have "nr < first_meta_bg"?
   And how does EXT3_FEATURE_INCOMPAT_META_BG affect the physical disk layout?


1612 <http://lxr.linux.no/linux+*/fs/ext3/super.c#L1612>
 return (logic_sb_block
<http://lxr.linux.no/linux+*/+code=logic_sb_block> + nr
<http://lxr.linux.no/linux+*/+code=nr> + 1);1613
<http://lxr.linux.no/linux+*/fs/ext3/super.c#L1613>        bg
<http://lxr.linux.no/linux+*/+code=bg> = sbi
<http://lxr.linux.no/linux+*/+code=sbi>->s_desc_per_block
<http://lxr.linux.no/linux+*/+code=s_desc_per_block> * nr
<http://lxr.linux.no/linux+*/+code=nr>;1614
<http://lxr.linux.no/linux+*/fs/ext3/super.c#L1614>        if
(ext3_bg_has_super
<http://lxr.linux.no/linux+*/+code=ext3_bg_has_super>(sb
<http://lxr.linux.no/linux+*/+code=sb>, bg
<http://lxr.linux.no/linux+*/+code=bg>))1615
<http://lxr.linux.no/linux+*/fs/ext3/super.c#L1615>
has_super <http://lxr.linux.no/linux+*/+code=has_super> = 1;1616
<http://lxr.linux.no/linux+*/fs/ext3/super.c#L1616>        return
(has_super <http://lxr.linux.no/linux+*/+code=has_super> +
ext3_group_first_block_no
<http://lxr.linux.no/linux+*/+code=ext3_group_first_block_no>(sb
<http://lxr.linux.no/linux+*/+code=sb>, bg
<http://lxr.linux.no/linux+*/+code=bg>));
3) It always return the first block no of the specific bg, right?
   Then its caller ext3_fill_super will read in the disk block.
   It seems that ext3_fill_super just read many copies of one same block
   (1st block), right?
   I'm sure I'm wrong with it, but cannot find out the right way.

1617 <http://lxr.linux.no/linux+*/fs/ext3/super.c#L1617>}


Any explanation are welcome.

thanks,

--90e6ba6153dad7b4bf04c1e1fa59
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,<br><br>I&#39;m reading the source code for ext2/ext3/ext4, and cannot f=
igure<br>out how descriptor_loc() runs:<br><br><pre class=3D"done" id=3D"28=
/d5/81ec51bf6aa0efa0042edd4054a73e42b060_3/1000"><a href=3D"http://lxr.linu=
x.no/linux+*/fs/ext3/super.c#L1600" id=3D"L1600" class=3D"line" name=3D"lin=
ux+v3.4.1/fs/ext3/super.c#L1600">1600</a>static <a href=3D"http://lxr.linux=
.no/linux+*/+code=3Dext3_fsblk_t" class=3D"sref">ext3_fsblk_t</a> <a href=
=3D"http://lxr.linux.no/linux+*/+code=3Ddescriptor_loc" class=3D"sref">desc=
riptor_loc</a>(struct <a href=3D"http://lxr.linux.no/linux+*/+code=3Dsuper_=
block" class=3D"sref">super_block</a> *<a href=3D"http://lxr.linux.no/linux=
+*/+code=3Dsb" class=3D"sref">sb</a>,
<a href=3D"http://lxr.linux.no/linux+*/fs/ext3/super.c#L1601" id=3D"L1601" =
class=3D"line" name=3D"L1601">1601</a>                                    <=
a href=3D"http://lxr.linux.no/linux+*/+code=3Dext3_fsblk_t" class=3D"sref">=
ext3_fsblk_t</a> <a href=3D"http://lxr.linux.no/linux+*/+code=3Dlogic_sb_bl=
ock" class=3D"sref">logic_sb_block</a>,
<a href=3D"http://lxr.linux.no/linux+*/fs/ext3/super.c#L1602" id=3D"L1602" =
class=3D"line" name=3D"L1602">1602</a>                                    i=
nt <a href=3D"http://lxr.linux.no/linux+*/+code=3Dnr" class=3D"sref">nr</a>=
)
<a href=3D"http://lxr.linux.no/linux+*/fs/ext3/super.c#L1603" id=3D"L1603" =
class=3D"line" name=3D"L1603">1603</a>{
<a href=3D"http://lxr.linux.no/linux+*/fs/ext3/super.c#L1604" id=3D"L1604" =
class=3D"line" name=3D"L1604">1604</a>        struct <a href=3D"http://lxr.=
linux.no/linux+*/+code=3Dext3_sb_info" class=3D"sref">ext3_sb_info</a> *<a =
href=3D"http://lxr.linux.no/linux+*/+code=3Dsbi" class=3D"sref">sbi</a> =3D=
 <a href=3D"http://lxr.linux.no/linux+*/+code=3DEXT3_SB" class=3D"sref">EXT=
3_SB</a>(<a href=3D"http://lxr.linux.no/linux+*/+code=3Dsb" class=3D"sref">=
sb</a>);
<a href=3D"http://lxr.linux.no/linux+*/fs/ext3/super.c#L1605" id=3D"L1605" =
class=3D"line" name=3D"L1605">1605</a>        unsigned long <a href=3D"http=
://lxr.linux.no/linux+*/+code=3Dbg" class=3D"sref">bg</a>, <a href=3D"http:=
//lxr.linux.no/linux+*/+code=3Dfirst_meta_bg" class=3D"sref">first_meta_bg<=
/a>;
<a href=3D"http://lxr.linux.no/linux+*/fs/ext3/super.c#L1606" id=3D"L1606" =
class=3D"line" name=3D"L1606">1606</a>        int <a href=3D"http://lxr.lin=
ux.no/linux+*/+code=3Dhas_super" class=3D"sref">has_super</a> =3D 0;
<a href=3D"http://lxr.linux.no/linux+*/fs/ext3/super.c#L1607" id=3D"L1607" =
class=3D"line" name=3D"L1607">1607</a>
<a href=3D"http://lxr.linux.no/linux+*/fs/ext3/super.c#L1608" id=3D"L1608" =
class=3D"line" name=3D"L1608">1608</a>        <a href=3D"http://lxr.linux.n=
o/linux+*/+code=3Dfirst_meta_bg" class=3D"sref">first_meta_bg</a> =3D <a hr=
ef=3D"http://lxr.linux.no/linux+*/+code=3Dle32_to_cpu" class=3D"sref">le32_=
to_cpu</a>(<a href=3D"http://lxr.linux.no/linux+*/+code=3Dsbi" class=3D"sre=
f">sbi</a>-&gt;<a href=3D"http://lxr.linux.no/linux+*/+code=3Ds_es" class=
=3D"sref">s_es</a>-&gt;<a href=3D"http://lxr.linux.no/linux+*/+code=3Ds_fir=
st_meta_bg" class=3D"sref">s_first_meta_bg</a>); <br>
<br>1) Who can setup the field -&gt;s_first_meta_bg, mke2fs? And what does =
it mean?<br>=A0=A0 What&#39;s a meta block group? <br><br><a href=3D"http:/=
/lxr.linux.no/linux+*/fs/ext3/super.c#L1609" id=3D"L1609" class=3D"line" na=
me=3D"L1609">1609</a>
<a href=3D"http://lxr.linux.no/linux+*/fs/ext3/super.c#L1610" id=3D"L1610" =
class=3D"line" name=3D"L1610">1610</a>        if (!<a href=3D"http://lxr.li=
nux.no/linux+*/+code=3DEXT3_HAS_INCOMPAT_FEATURE" class=3D"sref">EXT3_HAS_I=
NCOMPAT_FEATURE</a>(<a href=3D"http://lxr.linux.no/linux+*/+code=3Dsb" clas=
s=3D"sref">sb</a>, <a href=3D"http://lxr.linux.no/linux+*/+code=3DEXT3_FEAT=
URE_INCOMPAT_META_BG" class=3D"sref">EXT3_FEATURE_INCOMPAT_META_BG</a>) ||
<a href=3D"http://lxr.linux.no/linux+*/fs/ext3/super.c#L1611" id=3D"L1611" =
class=3D"line" name=3D"L1611">1611</a>            <a href=3D"http://lxr.lin=
ux.no/linux+*/+code=3Dnr" class=3D"sref">nr</a> &lt; <a href=3D"http://lxr.=
linux.no/linux+*/+code=3Dfirst_meta_bg" class=3D"sref">first_meta_bg</a>)
<br>2) In which case, we can have &quot;nr &lt; first_meta_bg&quot;?<br>=A0=
=A0 And how does EXT3_FEATURE_INCOMPAT_META_BG affect the physical disk lay=
out?<br><br><br><a href=3D"http://lxr.linux.no/linux+*/fs/ext3/super.c#L161=
2" id=3D"L1612" class=3D"line" name=3D"L1612">1612</a>                retur=
n (<a href=3D"http://lxr.linux.no/linux+*/+code=3Dlogic_sb_block" class=3D"=
sref">logic_sb_block</a> + <a href=3D"http://lxr.linux.no/linux+*/+code=3Dn=
r" class=3D"sref">nr</a> + 1);
<a href=3D"http://lxr.linux.no/linux+*/fs/ext3/super.c#L1613" id=3D"L1613" =
class=3D"line" name=3D"L1613">1613</a>        <a href=3D"http://lxr.linux.n=
o/linux+*/+code=3Dbg" class=3D"sref">bg</a> =3D <a href=3D"http://lxr.linux=
.no/linux+*/+code=3Dsbi" class=3D"sref">sbi</a>-&gt;<a href=3D"http://lxr.l=
inux.no/linux+*/+code=3Ds_desc_per_block" class=3D"sref">s_desc_per_block</=
a> * <a href=3D"http://lxr.linux.no/linux+*/+code=3Dnr" class=3D"sref">nr</=
a>;
<a href=3D"http://lxr.linux.no/linux+*/fs/ext3/super.c#L1614" id=3D"L1614" =
class=3D"line" name=3D"L1614">1614</a>        if (<a href=3D"http://lxr.lin=
ux.no/linux+*/+code=3Dext3_bg_has_super" class=3D"sref">ext3_bg_has_super</=
a>(<a href=3D"http://lxr.linux.no/linux+*/+code=3Dsb" class=3D"sref">sb</a>=
, <a href=3D"http://lxr.linux.no/linux+*/+code=3Dbg" class=3D"sref">bg</a>)=
)
<a href=3D"http://lxr.linux.no/linux+*/fs/ext3/super.c#L1615" id=3D"L1615" =
class=3D"line" name=3D"L1615">1615</a>                <a href=3D"http://lxr=
.linux.no/linux+*/+code=3Dhas_super" class=3D"sref">has_super</a> =3D 1;
<a href=3D"http://lxr.linux.no/linux+*/fs/ext3/super.c#L1616" id=3D"L1616" =
class=3D"line" name=3D"L1616">1616</a>        return (<a href=3D"http://lxr=
.linux.no/linux+*/+code=3Dhas_super" class=3D"sref">has_super</a> + <a href=
=3D"http://lxr.linux.no/linux+*/+code=3Dext3_group_first_block_no" class=3D=
"sref">ext3_group_first_block_no</a>(<a href=3D"http://lxr.linux.no/linux+*=
/+code=3Dsb" class=3D"sref">sb</a>, <a href=3D"http://lxr.linux.no/linux+*/=
+code=3Dbg" class=3D"sref">bg</a>));
<br>3) It always return the first block no of the specific bg, right?<br>=
=A0=A0 Then its caller ext3_fill_super will read in the disk block.<br>=A0=
=A0 It seems that ext3_fill_super just read many copies of one same block<b=
r>=A0=A0 (1st block), right?<br>
=A0=A0 I&#39;m sure I&#39;m wrong with it, but cannot find out the right wa=
y.<br><br><a href=3D"http://lxr.linux.no/linux+*/fs/ext3/super.c#L1617" id=
=3D"L1617" class=3D"line" name=3D"L1617">1617</a>}
</pre><br>Any explanation are welcome.<br><br>thanks, <br>

--90e6ba6153dad7b4bf04c1e1fa59--


--===============4225155415163879039==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Kernelnewbies mailing list
Kernelnewbies@kernelnewbies.org
http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies

--===============4225155415163879039==--
