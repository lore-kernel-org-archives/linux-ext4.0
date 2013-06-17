From: "jon ernst" <jonernst07@gmx.com>
Subject: [PATCH] ext4: delete unused variables
Date: Sun, 16 Jun 2013 20:05:43 -0400
Message-ID: <20130617000543.164330@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.201]:54900 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab3FQAFq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Jun 2013 20:05:46 -0400
Received: from mailout-us.gmx.com ([172.19.198.47]) by mrigmx.server.lan
 (mrigmxus002) with ESMTP (Nemesis) id 0McVsK-1V5tnu06PQ-00HjO3 for
 <linux-ext4@vger.kernel.org>; Mon, 17 Jun 2013 02:05:46 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch removed several unused variables.

Signed-off-by: Jon Ernst <jonernst07@gmx.com>
---


diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 3dcbf36..b494382 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -912,7 +912,6 @@ move_extent_per_page(struct file *o_filp, struct in=
ode *donor_inode,
 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct page *pagep[2] =3D {NULL, NULL};
 =C2=A0 =C2=A0 =C2=A0 =C2=A0handle_t *handle;
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_lblk_t orig_blk_offset;
- =C2=A0 =C2=A0 =C2=A0 long long offs =3D orig_page_offset << PAGE_CACH=
E_SHIFT;
 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long blocksize =3D orig_inode->i_s=
b->s_blocksize;
 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int w_flags =3D 0;
 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int tmp_data_size, data_size, repl=
aced_size;
@@ -940,7 +939,6 @@ again:
 =C2=A0 =C2=A0 =C2=A0 =C2=A0orig_blk_offset =3D orig_page_offset * bloc=
ks_per_page +
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0data_offset_in_=
page;

- =C2=A0 =C2=A0 =C2=A0 offs =3D (long long)orig_blk_offset << orig_inod=
e->i_blkbits;

 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Calculate data_size */
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((orig_blk_offset + block_len_in_page - =
1) =3D=3D
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 6ed4df2..707095b 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1556,11 +1556,10 @@ int ext4_group_add(struct super_block *sb, stru=
ct ext4_new_group_data *input)
 =C2=A0 =C2=A0 =C2=A0 =C2=A0int reserved_gdb =3D ext4_bg_has_super(sb, =
input->group) ?
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0le16_to_cpu(es-=
>s_reserved_gdt_blocks) : 0;
 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct inode *inode =3D NULL;
- =C2=A0 =C2=A0 =C2=A0 int gdb_off, gdb_num;
+ =C2=A0 =C2=A0 =C2=A0 int gdb_off;
 =C2=A0 =C2=A0 =C2=A0 =C2=A0int err;
 =C2=A0 =C2=A0 =C2=A0 =C2=A0__u16 bg_flags =3D 0;

- =C2=A0 =C2=A0 =C2=A0 gdb_num =3D input->group / EXT4_DESC_PER_BLOCK(s=
b);
 =C2=A0 =C2=A0 =C2=A0 =C2=A0gdb_off =3D input->group % EXT4_DESC_PER_BL=
OCK(sb);

 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (gdb_off =3D=3D 0 && !EXT4_HAS_RO_COMPAT=
_FEATURE(sb,
diff --git a/fs/ext4/super.c b/ext4/fs/super.c
index eb52a7b..54701fc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1924,7 +1924,6 @@ static int ext4_fill_flex_info(struct super_block=
 *sb)
 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ext4_sb_info *sbi =3D EXT4_SB(sb);
 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ext4_group_desc *gdp =3D NULL;
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_group_t flex_group;
- =C2=A0 =C2=A0 =C2=A0 unsigned int groups_per_flex =3D 0;
 =C2=A0 =C2=A0 =C2=A0 =C2=A0int i, err;

 =C2=A0 =C2=A0 =C2=A0 =C2=A0sbi->s_log_groups_per_flex =3D sbi->s_es->s=
_log_groups_per_flex;
@@ -1932,7 +1931,6 @@ static int ext4_fill_flex_info(struct super_block=
 *sb)
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sbi->s_log_grou=
ps_per_flex =3D 0;
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;
 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
- =C2=A0 =C2=A0 =C2=A0 groups_per_flex =3D 1U << sbi->s_log_groups_per_=
flex;

 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D ext4_alloc_flex_bg_array(sb, sbi->s=
_groups_count);
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err)
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
