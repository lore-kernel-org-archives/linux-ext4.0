From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: EXT4_FEATURE_RO_COMPAT_DIR_NLINK and the directory size.
Date: Tue, 12 Feb 2008 19:23:42 +0530
Message-ID: <20080212135342.GB16634@skywalker>
References: <20080212123632.GA16634@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:34102 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757928AbYBLNx5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Feb 2008 08:53:57 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m1CDsAXd001760
	for <linux-ext4@vger.kernel.org>; Wed, 13 Feb 2008 00:54:10 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1CDvXmN278012
	for <linux-ext4@vger.kernel.org>; Wed, 13 Feb 2008 00:57:33 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1CDrt78009699
	for <linux-ext4@vger.kernel.org>; Wed, 13 Feb 2008 00:53:55 +1100
Content-Disposition: inline
In-Reply-To: <20080212123632.GA16634@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 12, 2008 at 06:06:32PM +0530, Aneesh Kumar K.V wrote:
> Also after running fsstress fsck fails with zero size directory on
> powerpc. I am finding directories with=20
>=20
> i_links_count =3D=3D 1
> i_blocks =3D=3D 0
>=20
> I missed to check whether the l_i_blocks_hi was having some value.

Ok this is what i have in ext4_inode and super block

(gdb) p *inode
$1 =3D {i_mode =3D 16895, i_uid =3D 0, i_size =3D 4096, i_atime =3D 120=
2822535, i_ctime =3D 1202822535, i_mtime =3D 1202822535, i_dtime =3D 0,
i_gid =3D 0, i_links_count =3D 1, i_blocks =3D 0, i_flags =3D 524288, o=
sd1 =3D {linux1 =3D {l_i_version =3D 1}, hurd1 =3D {h_i_translator =3D =
1},
masix1 =3D {m_i_reserved1 =3D 1}}, i_block =3D {4077518848, 262144, 0 <=
repeats 13 times>}, i_generation =3D 2950864834, i_file_acl =3D 0,
i_dir_acl =3D 0, i_faddr =3D 0, osd2 =3D {linux2 =3D {l_i_blocks_hi =3D=
 0, i_pad1 =3D 0, l_i_uid_high =3D 0, l_i_gid_high =3D 0, l_i_reserved2=
 =3D 0},
hurd2 =3D {h_i_frag =3D 0 '\0', h_i_fsize =3D 0 '\0', h_i_mode_high =3D=
 0, h_i_uid_high =3D 0, h_i_gid_high =3D 0, h_i_author =3D 0}, masix2 =3D=
 {
m_i_frag =3D 0 '\0', m_i_fsize =3D 0 '\0', m_pad1 =3D 0, m_i_reserved2 =
=3D {0, 0}}}}



(gdb) p *(struct ext2_super_block *)0x10081088
$3 =3D {s_inodes_count =3D 612000, s_blocks_count =3D 2443880, s_r_bloc=
ks_count =3D 122194, s_free_blocks_count =3D 2367290,=20
  s_free_inodes_count =3D 597740, s_first_data_block =3D 0, s_log_block=
_size =3D 2, s_log_frag_size =3D 2, s_blocks_per_group =3D 32768,=20
  s_frags_per_group =3D 32768, s_inodes_per_group =3D 8160, s_mtime =3D=
 1202819872, s_wtime =3D 1202822940, s_mnt_count =3D 1,=20
  s_max_mnt_count =3D 31, s_magic =3D 61267, s_state =3D 1, s_errors =3D=
 1, s_minor_rev_level =3D 0, s_lastcheck =3D 1202819860,=20
  s_checkinterval =3D 15552000, s_creator_os =3D 0, s_rev_level =3D 1, =
s_def_resuid =3D 0, s_def_resgid =3D 0, s_first_ino =3D 11,=20
  s_inode_size =3D 256, s_block_group_nr =3D 0, s_feature_compat =3D 60=
, s_feature_incompat =3D 66, s_feature_ro_compat =3D 3,=20
  s_uuid =3D "\017=EF=BF=BDK\n=EF=BF=BD\027@\211\2106\210Q\006=EF=BF=BD=
=EF=BF=BD=EF=BF=BD", s_volume_name =3D '\0' <repeats 15 times>, s_last_=
mounted =3D '\0' <repeats 63 times>,=20
  s_algorithm_usage_bitmap =3D 0, s_prealloc_blocks =3D 0 '\0', s_preal=
loc_dir_blocks =3D 0 '\0', s_reserved_gdt_blocks =3D 596,=20
  s_journal_uuid =3D '\0' <repeats 15 times>, s_journal_inum =3D 8, s_j=
ournal_dev =3D 0, s_last_orphan =3D 0, s_hash_seed =3D {3431749423,=20
    287196506, 2183301643, 2777289977}, s_def_hash_version =3D 2 '\002'=
, s_jnl_backup_type =3D 1 '\001', s_desc_size =3D 0,=20
  s_default_mount_opts =3D 0, s_first_meta_bg =3D 0, s_mkfs_time =3D 12=
02819860, s_jnl_blocks =3D {1116, 1117, 1118, 1119, 1120, 1121, 1122,=20
    1123, 1124, 1125, 1126, 1127, 1128, 2153, 0, 0, 134217728}, s_block=
s_count_hi =3D 0, s_r_blocks_count_hi =3D 0, s_free_blocks_hi =3D 0,=20
  s_min_extra_isize =3D 0, s_want_extra_isize =3D 0, s_flags =3D 6, s_r=
aid_stride =3D 0, s_mmp_update_interval =3D 0, s_mmp_block =3D 0,=20
  s_raid_stripe_width =3D 0, s_reserve
