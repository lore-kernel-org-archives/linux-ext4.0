From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Segmentation fault in e4defrag -c
Date: Thu, 25 Jun 2009 12:55:58 +0200
Message-ID: <20090625105558.GA21773@uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: a-fujita@rs.jp.nec.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([129.241.93.19]:36495 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZFYLgY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Jun 2009 07:36:24 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I tested e4defrag -c (granted, on a 2.6.30-rc kernel, so it doesn't act=
ually
have the defrag patches, but checking should still work, right?) and it
segfaults with a null pointer deference on certain filesystems. Could y=
ou
please take a look?

pannekake:/home/sesse# gdb ./e4defrag
GNU gdb 6.8-debian
Copyright (C) 2008 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl=
=2Ehtml>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copyi=
ng"
and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu"...
(gdb) r -c /dev/mapper/pannekake-home
Starting program: /home/sesse/e4defrag -c /dev/mapper/pannekake-home

Program received signal SIGSEGV, Segmentation fault.
0x00000000004027b9 in get_physical_count (physical_list_head=3D0x0) at =
e4defrag.c:1055
1055			if ((ext_list_tmp->data.physical + ext_list_tmp->data.len)
(gdb) bt full
#0  0x00000000004027b9 in get_physical_count (physical_list_head=3D0x0)=
 at e4defrag.c:1055
	ret =3D 0
	ext_list_tmp =3D (struct fiemap_extent_list *) 0x0
#1  0x0000000000402f6c in file_statistic (file=3D0x60e260 "/home/sesse/=
Mika - Life In Cartoon Motion/11 - Ring Ring (Bonus Track).mp3",=20
    buf=3D0x7fff33662fd0, flag=3D0, ftwbuf=3D0x7fff33667378) at e4defra=
g.c:1326
	fd =3D 8
	ret =3D 0
	now_ext_count =3D 862335568
	best_ext_count =3D 32767
	physical_ext_count =3D 862352208
	i =3D 32767
	j =3D 32
	ratio =3D 0
	blk_count =3D 0
	msg_buffer =3D "(", '\0' <repeats 15 times>, "\030!f3=C3=BF\177\000\00=
0\000\000\000\000f\000\000\000=C3=80\022a\000\000\000\000\000/home/se/h=
ome/lo\a\000\000\000\000\000\000\000\2200f3=C3=BF\177\000\000\035\000\0=
00\000\000\000\000\000P2f3=C3=BF\177\000\000\004\000\000\000\000\000\00=
0\000=C3=A00f3=C3=BF\177\000\000=C3=91,@\000\000\000\000\000P2f3=C3=BF\=
177\000\000V=C3=AA=C3=9C=C3=A6b\177\000\000Psf3=C3=BF\177\000\000C'@\00=
0\000\000\000\000\020=C3=90`\000\000\000\000\000=C3=A0y\n=C3=A7b\177\00=
0\000xsf3=C3=BF\177\000\000\f\000\000\000\001\000\000\000@1f3=C3=BF\177=
\000\000`=C3=A2`", '\0' <repeats 21 times>, "Psf3=C3=BF\177\000\000"...
	physical_list_head =3D (struct fiemap_extent_list *) 0x0
	logical_list_head =3D (struct fiemap_extent_list *) 0x0
#2  0x00007f62e6e1d73a in ?? () from /lib/libc.so.6
No symbol table info available.
#3  0x00007f62e6e1da85 in ?? () from /lib/libc.so.6
No symbol table info available.
#4  0x00007f62e6e1d67e in ?? () from /lib/libc.so.6
No symbol table info available.
#5  0x00007f62e6e1da85 in ?? () from /lib/libc.so.6
No symbol table info available.
#6  0x00007f62e6e1d67e in ?? () from /lib/libc.so.6
No symbol table info available.
#7  0x00007f62e6e1da85 in ?? () from /lib/libc.so.6
No symbol table info available.
#8  0x00007f62e6e1e2cb in ?? () from /lib/libc.so.6
No symbol table info available.
#9  0x0000000000404a67 in main (argc=3D3, argv=3D0x7fff336689e8) at e4d=
efrag.c:2022
	mount_dir_len =3D 32767
	opt =3D -1
	i =3D 2
	j =3D 0
	flags =3D 3
	arg_type =3D 0
	success_flag =3D 0
	dir_name =3D "/home", '\0' <repeats 4091 times>
	buf =3D {st_dev =3D 64787, st_ino =3D 2, st_nlink =3D 33, st_mode =3D =
16877, st_uid =3D 0, st_gid =3D 0, pad0 =3D 0, st_rdev =3D 0, st_size =3D=
 4096,=20
  st_blksize =3D 4096, st_blocks =3D 8, st_atim =3D {tv_sec =3D 1245891=
895, tv_nsec =3D 968453897}, st_mtim =3D {tv_sec =3D 1245401183,=20
    tv_nsec =3D 304453887}, st_ctim =3D {tv_sec =3D 1245401183, tv_nsec=
 =3D 304453887}, __unused =3D {0, 0, 0}}
	sb =3D {s_inodes_count =3D 2621440, s_blocks_count_lo =3D 10485760, s_=
r_blocks_count_lo =3D 524224, s_free_blocks_count_lo =3D 3310667,=20
  s_free_inodes_count =3D 2377762, s_first_data_block =3D 0, s_log_bloc=
k_size =3D 2, s_obso_log_frag_size =3D 2, s_blocks_per_group =3D 32768,=
=20
  s_obso_frags_per_group =3D 32768, s_inodes_per_group =3D 8192, s_mtim=
e =3D 1243121832, s_wtime =3D 1243121832, s_mnt_count =3D 11,=20
  s_max_mnt_count =3D 38, s_magic =3D 61267, s_state =3D 1, s_errors =3D=
 1, s_minor_rev_level =3D 0, s_lastcheck =3D 1239019329,=20
  s_checkinterval =3D 15552000, s_creator_os =3D 0, s_rev_level =3D 1, =
s_def_resuid =3D 0, s_def_resgid =3D 0, s_first_ino =3D 11,=20
  s_inode_size =3D 256, s_block_group_nr =3D 0, s_feature_compat =3D 60=
, s_feature_incompat =3D 582, s_feature_ro_compat =3D 123,=20
  s_uuid =3D "=C3=80{=C3=93;{rM*\227=C2=B1=C3=83\22742\v2", s_volume_na=
me =3D '\0' <repeats 15 times>, s_last_mounted =3D '\0' <repeats 63 tim=
es>,=20
  s_algorithm_usage_bitmap =3D 0, s_prealloc_blocks =3D 0 '\0', s_preal=
loc_dir_blocks =3D 0 '\0', s_reserved_gdt_blocks =3D 1021,=20
  s_journal_uuid =3D '\0' <repeats 15 times>, s_journal_inum =3D 8, s_j=
ournal_dev =3D 0, s_last_orphan =3D 655808, s_hash_seed =3D {3246912957=
,=20
    3041674718, 1885689521, 1976377087}, s_def_hash_version =3D 2 '\002=
', s_reserved_char_pad =3D 1 '\001', s_desc_size =3D 0,=20
  s_default_mount_opts =3D 0, s_first_meta_bg =3D 0, s_mkfs_time =3D 12=
19499056, s_jnl_blocks =3D {9255, 9256, 9257, 9258, 9259, 9260, 9261,=20
    9262, 9263, 9264, 9265, 9266, 9267, 10292, 0, 0, 134217728}, s_bloc=
ks_count_hi =3D 0, s_r_blocks_count_hi =3D 0,=20
  s_free_blocks_count_hi =3D 0, s_min_extra_isize =3D 28, s_want_extra_=
isize =3D 28, s_flags =3D 1, s_raid_stride =3D 0, s_mmp_interval =3D 0,=
=20
  s_mmp_block =3D 0, s_raid_stripe_width =3D 0, s_log_groups_per_flex =3D=
 4 '\004', s_reserved_char_pad2 =3D 0 '\0', s_reserved_pad =3D 0,=20
  s_reserved =3D {15648, 0 <repeats 161 times>}}

/* Steinar */
--=20
Homepage: http://www.sesse.net/
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
