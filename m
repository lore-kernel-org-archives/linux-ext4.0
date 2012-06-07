From: Ryan Wang <openspace.wang@gmail.com>
Subject: How to understand super.c/descriptor_loc for ext2/ext3/ext4?
Date: Fri, 8 Jun 2012 07:57:05 +0800
Message-ID: <CAPxxNQnNCCeX1sGNSeKqHzHAdP1sMk7z0M3igNpH0t7NVSyceg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0820696301041230526=="
Cc: kernelnewbies@kernelnewbies.org
To: linux-ext4@vger.kernel.org
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

--===============0820696301041230526==
Content-Type: multipart/alternative; boundary=bcaec52be60108ea2104c1eaa466

--bcaec52be60108ea2104c1eaa466
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I'm reading the source code for ext2/ext3/ext4, and cannot figure
out how descriptor_loc() runs:

1600static ext3_fsblk_t descriptor_loc(struct super_block *sb,
1601                                    ext3_fsblk_t logic_sb_block,
1602                                    int nr)
1603{
1604        struct ext3_sb_info *sbi = EXT3_SB(sb);
1605        unsigned long bg, first_meta_bg;
1606        int has_super = 0;
1607
1608        first_meta_bg = le32_to_cpu(sbi->s_es->s_first_meta_bg);


1) Who can setup the field ->s_first_meta_bg, mke2fs? And what does it mean?
   What's a meta block group?

1609
1610        if (!EXT3_HAS_INCOMPAT_FEATURE(sb,
EXT3_FEATURE_INCOMPAT_META_BG) ||
1611            nr < first_meta_bg)

2) In which case, we can have "nr < first_meta_bg"?
   And how does EXT3_FEATURE_INCOMPAT_META_BG affect the physical disk
layout?


1612                return (logic_sb_block + nr + 1);
1613        bg = sbi->s_desc_per_block * nr;
1614        if (ext3_bg_has_super(sb, bg))
1615                has_super = 1;
1616        return (has_super + ext3_group_first_block_no(sb, bg));

3) It always return the first block no of the specific bg, right?
   Then its caller ext3_fill_super will read in the disk block.
   It seems that ext3_fill_super just read many copies of one same block
   (1st block), right?

   I'm sure I'm wrong with it, but cannot find out the right way.

1617}


Any explanation are welcome.

thanks,

--bcaec52be60108ea2104c1eaa466
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,<br><br>I&#39;m reading the source code for ext2/ext3/ext4, and cannot f=
igure<br>out how descriptor_loc() runs:<br><br>1600static ext3_fsblk_t desc=
riptor_loc(struct super_block *sb,<br>1601=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ex=
t3_fsblk_t logic_sb_block,<br>
1602=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int nr)<br>1603{<br>1604=A0=A0=A0=A0=
=A0=A0=A0 struct ext3_sb_info *sbi =3D EXT3_SB(sb);<br>1605=A0=A0=A0=A0=A0=
=A0=A0 unsigned long bg, first_meta_bg;<br>1606=A0=A0=A0=A0=A0=A0=A0 int ha=
s_super =3D 0;<br>1607<br>1608=A0=A0=A0=A0=A0=A0=A0 first_meta_bg =3D le32_=
to_cpu(sbi-&gt;s_es-&gt;s_first_meta_bg); <br>
<br><br>1) Who can setup the field -&gt;s_first_meta_bg, mke2fs? And what d=
oes it mean?<br>=A0=A0 What&#39;s a meta block group? <br><br>1609<br>1610=
=A0=A0=A0=A0=A0=A0=A0 if (!EXT3_HAS_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOM=
PAT_META_BG) ||<br>
1611=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nr &lt; first_meta_bg)<br><br>2) In w=
hich case, we can have &quot;nr &lt; first_meta_bg&quot;?<br>=A0=A0 And how=
 does EXT3_FEATURE_INCOMPAT_META_BG affect the physical disk layout?<br><br=
><br>1612=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return (logic_sb_blo=
ck + nr + 1);<br>
1613=A0=A0=A0=A0=A0=A0=A0 bg =3D sbi-&gt;s_desc_per_block * nr;<br>1614=A0=
=A0=A0=A0=A0=A0=A0 if (ext3_bg_has_super(sb, bg))<br>1615=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 has_super =3D 1;<br>1616=A0=A0=A0=A0=A0=A0=A0 r=
eturn (has_super + ext3_group_first_block_no(sb, bg));<br><br>3) It always =
return the first block no of the specific bg, right?<br>
=A0=A0 Then its caller ext3_fill_super will read in the disk block.<br>=A0=
=A0 It seems that ext3_fill_super just read many copies of one same block<b=
r>=A0=A0 (1st block), right?<br><br>=A0=A0 I&#39;m sure I&#39;m wrong with =
it, but cannot find out the right way.<br>
<br>1617}<br><br><br>Any explanation are welcome.<br><br>thanks, <br>

--bcaec52be60108ea2104c1eaa466--


--===============0820696301041230526==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Kernelnewbies mailing list
Kernelnewbies@kernelnewbies.org
http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies

--===============0820696301041230526==--
