From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: EXT4_FEATURE_RO_COMPAT_DIR_NLINK and the directory size.
Date: Tue, 12 Feb 2008 20:35:16 +0530
Message-ID: <20080212150516.GC16634@skywalker>
References: <20080212123632.GA16634@skywalker> <20080212135342.GB16634@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:45142 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756057AbYBLPFS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Feb 2008 10:05:18 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m1CF5FTo026363
	for <linux-ext4@vger.kernel.org>; Tue, 12 Feb 2008 20:35:15 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1CF5F0b880856
	for <linux-ext4@vger.kernel.org>; Tue, 12 Feb 2008 20:35:15 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m1CF5EWX017675
	for <linux-ext4@vger.kernel.org>; Tue, 12 Feb 2008 15:05:15 GMT
Content-Disposition: inline
In-Reply-To: <20080212135342.GB16634@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 12, 2008 at 07:23:42PM +0530, Aneesh Kumar K.V wrote:
> On Tue, Feb 12, 2008 at 06:06:32PM +0530, Aneesh Kumar K.V wrote:
> > Also after running fsstress fsck fails with zero size directory on
> > powerpc. I am finding directories with=20
> >=20
> > i_links_count =3D=3D 1
> > i_blocks =3D=3D 0
> >=20
> > I missed to check whether the l_i_blocks_hi was having some value.
>=20
> Ok this is what i have in ext4_inode and super block
>=20
> (gdb) p *inode
> $1 =3D {i_mode =3D 16895, i_uid =3D 0, i_size =3D 4096, i_atime =3D 1=
202822535, i_ctime =3D 1202822535, i_mtime =3D 1202822535, i_dtime =3D =
0,
> i_gid =3D 0, i_links_count =3D 1, i_blocks =3D 0, i_flags =3D 524288,=
 osd1 =3D {linux1 =3D {l_i_version =3D 1}, hurd1 =3D {h_i_translator =3D=
 1},
> masix1 =3D {m_i_reserved1 =3D 1}}, i_block =3D {4077518848, 262144, 0=
 <repeats 13 times>}, i_generation =3D 2950864834, i_file_acl =3D 0,
> i_dir_acl =3D 0, i_faddr =3D 0, osd2 =3D {linux2 =3D {l_i_blocks_hi =3D=
 0, i_pad1 =3D 0, l_i_uid_high =3D 0, l_i_gid_high =3D 0, l_i_reserved2=
 =3D 0},
> hurd2 =3D {h_i_frag =3D 0 '\0', h_i_fsize =3D 0 '\0', h_i_mode_high =3D=
 0, h_i_uid_high =3D 0, h_i_gid_high =3D 0, h_i_author =3D 0}, masix2 =3D=
 {
> m_i_frag =3D 0 '\0', m_i_fsize =3D 0 '\0', m_pad1 =3D 0, m_i_reserved=
2 =3D {0, 0}}}}
>=20
>=20
>=20
> (gdb) p *(struct ext2_super_block *)0x10081088
> $3 =3D {s_inodes_count =3D 612000, s_blocks_count =3D 2443880, s_r_bl=
ocks_count =3D 122194, s_free_blocks_count =3D 2367290,=20
>   s_free_inodes_count =3D 597740, s_first_data_block =3D 0, s_log_blo=
ck_size =3D 2, s_log_frag_size =3D 2, s_blocks_per_group =3D 32768,=20
>   s_frags_per_group =3D 32768, s_inodes_per_group =3D 8160, s_mtime =3D=
 1202819872, s_wtime =3D 1202822940, s_mnt_count =3D 1,=20
>   s_max_mnt_count =3D 31, s_magic =3D 61267, s_state =3D 1, s_errors =
=3D 1, s_minor_rev_level =3D 0, s_lastcheck =3D 1202819860,=20
>   s_checkinterval =3D 15552000, s_creator_os =3D 0, s_rev_level =3D 1=
, s_def_resuid =3D 0, s_def_resgid =3D 0, s_first_ino =3D 11,=20
>   s_inode_size =3D 256, s_block_group_nr =3D 0, s_feature_compat =3D =
60, s_feature_incompat =3D 66, s_feature_ro_compat =3D 3,=20
>   s_uuid =3D "\017=EF=BF=BDK\n=EF=BF=BD\027@\211\2106\210Q\006=EF=BF=BD=
=EF=BF=BD=EF=BF=BD", s_volume_name =3D '\0' <repeats 15 times>, s_last_=
mounted =3D '\0' <repeats 63 times>,=20
>   s_algorithm_usage_bitmap =3D 0, s_prealloc_blocks =3D 0 '\0', s_pre=
alloc_dir_blocks =3D 0 '\0', s_reserved_gdt_blocks =3D 596,=20
>   s_journal_uuid =3D '\0' <repeats 15 times>, s_journal_inum =3D 8, s=
_journal_dev =3D 0, s_last_orphan =3D 0, s_hash_seed =3D {3431749423,=20
>     287196506, 2183301643, 2777289977}, s_def_hash_version =3D 2 '\00=
2', s_jnl_backup_type =3D 1 '\001', s_desc_size =3D 0,=20
>   s_default_mount_opts =3D 0, s_first_meta_bg =3D 0, s_mkfs_time =3D =
1202819860, s_jnl_blocks =3D {1116, 1117, 1118, 1119, 1120, 1121, 1122,=
=20
>     1123, 1124, 1125, 1126, 1127, 1128, 2153, 0, 0, 134217728}, s_blo=
cks_count_hi =3D 0, s_r_blocks_count_hi =3D 0, s_free_blocks_hi =3D 0,=20
>   s_min_extra_isize =3D 0, s_want_extra_isize =3D 0, s_flags =3D 6, s=
_raid_stride =3D 0, s_mmp_update_interval =3D 0, s_mmp_block =3D 0,=20
>   s_raid_stripe_width =3D 0, s_reserve
> -

Right now waiting for the test to finish with this change.

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a9347fb..fd3b031 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1805,7 +1805,7 @@ retry:
 	inode->i_size =3D EXT4_I(inode)->i_disksize =3D inode->i_sb->s_blocks=
ize;
 	dir_block =3D ext4_bread (handle, inode, 0, 1, &err);
 	if (!dir_block) {
-		ext4_dec_count(handle, inode); /* is this nlink =3D=3D 0? */
+		drop_nlink(inode);
 		ext4_mark_inode_dirty(handle, inode);
 		iput (inode);
 		goto out_stop;
