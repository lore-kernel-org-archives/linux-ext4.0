From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH] libext2fs: add new test: tst_inode_size
Date: Fri, 16 Mar 2012 21:07:34 -0600
Message-ID: <04C1B12A-A408-4BC8-B419-C93934141071@whamcloud.com>
References: <1316020593-19050-1-git-send-email-tytso@mit.edu> <0E958708-A440-43C9-B69F-4E677AB82580@dilger.ca> <20110914221559.GB15782@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: multipart/mixed; boundary=Apple-Mail-26--688347242
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62647 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2CQDHF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Mar 2012 23:07:05 -0400
Received: by iagz16 with SMTP id z16so6303612iag.19
        for <linux-ext4@vger.kernel.org>; Fri, 16 Mar 2012 20:07:04 -0700 (PDT)
In-Reply-To: <20110914221559.GB15782@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail-26--688347242
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On 2011-09-14, at 4:15 PM, Ted Ts'o wrote:
> On Wed, Sep 14, 2011 at 02:47:08PM -0600, Andreas Dilger wrote:
>> One thing I noticed with this check_field() macro is that it doesn't
>> actually detect the case if the size of a field is changed.  This hit
>> me when I was making a cleanup to the large journal patch which renamed
>> s_jnl_blocks[15] to s_jnl_size_lo and s_jnl_blocks[16] to s_jnl_size_hi
>> for clarity.  The tst_super_size test passed just fine, but the e2fsck
>> test scripts failed in weird and wonderful ways.
>> 
>> A better solution might be to explicitly pass the expected field size
>> instead of getting both the size and offset from the structure itself.
>> Since these structures change very rarely it isn't much maintenance,
>> but it would be lousy if code was released that had some incorrect
>> field offset because someone increased or decreased an earlier field
>> without thinking enough, and those fields weren't used in normal tests.
>> 
>> I can submit a patch if you are interested.
> 
> Good point.  Yes, I agree it would be worth while to do this.

Finally had a few minutes to sit down and work on this.  Patch
attached, since I'm offline right now.

Cheers, Andreas
--
Andreas Dilger                       Whamcloud, Inc.
Principal Lustre Engineer            http://www.whamcloud.com/




--Apple-Mail-26--688347242
Content-Disposition: attachment;
	filename=0001-tests-add-field-sizes-to-inode-super-struct-tests.patch
Content-Type: application/octet-stream;
	name="0001-tests-add-field-sizes-to-inode-super-struct-tests.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=2079b3fd2b8f4f6bf071e6373b1e58494992938589=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Andreas=20Dilger=20<adilger@whamcloud.com>=0A=
Date:=20Thu,=2015=20Mar=202012=2022:16:04=20-0600=0ASubject:=20[PATCH]=20=
tests:=20add=20field=20sizes=20to=20inode/super=20struct=20tests=0A=0AIn=20=
addition=20to=20validating=20the=20ordering=20of=20fields=20within=20the=20=
inode=0Aand=20superblock=20structures,=20also=20validate=20the=20field=20=
sizes.=20=20Otherwise=0Ait=20is=20possible=20to=20incorrectly=20change=20=
the=20size=20of=20one=20of=20these=20fields=0Awithout=20getting=20any=20=
kind=20of=20error=20from=20these=20tests.=20=20Failures=20would=0Aonly=20=
show=20up=20later=20in=20the=20test=20image=20checks=20if=20the=20field=20=
that=20is=0Achanged=20is=20before=20another=20in-use=20field.=0A=0A=
Signed-off-by:=20Andreas=20Dilger=20<adilger@whamcloud.com>=0A---=0A=20=
lib/ext2fs/tst_inode_size.c=20|=20=20=2097=20++++++++++----------=0A=20=
lib/ext2fs/tst_super_size.c=20|=20=20209=20=
+++++++++++++++++++++----------------------=0A=202=20files=20changed,=20=
151=20insertions(+),=20155=20deletions(-)=0A=0Adiff=20--git=20=
a/lib/ext2fs/tst_inode_size.c=20b/lib/ext2fs/tst_inode_size.c=0Aindex=20=
86e3227..3e43d9f=20100644=0A---=20a/lib/ext2fs/tst_inode_size.c=0A+++=20=
b/lib/ext2fs/tst_inode_size.c=0A@@=20-16,67=20+16,70=20@@=0A=20=0A=20=
#include=20"ext2_fs.h"=0A=20=0A-struct=20ext2_inode=20inode;=0A+struct=20=
ext2_inode_large=20inode;=0A=20=0A-int=20verbose=20=3D=200;=0A+#define=20=
offsetof(type,=20member)=20=20__builtin_offsetof(type,=20member)=0A=
+#define=20check_field(x,=20s)=20cur_offset=20=3D=20do_field(#x,=20s,=20=
sizeof(inode.x),=09=20=20=20=20=20=20=20\=0A+=09=09=09=09=09=
offsetof(struct=20ext2_inode_large,=20x),=20=20\=0A+=09=09=09=09=09=
cur_offset)=0A=20=0A-#define=20offsetof(type,=20member)=20=20=
__builtin_offsetof=20(type,=20member)=0A-#define=20check_field(x)=20=
cur_offset=20=3D=20do_field(#x,=20sizeof(inode.x),=09\=0A-=09=09=09=09=
offsetof(struct=20ext2_inode,=20x),=20\=0A-=09=09=09=09cur_offset)=0A-=0A=
-static=20int=20do_field(const=20char=20*field,=20size_t=20size,=20int=20=
offset,=20int=20cur_offset)=0A+static=20int=20do_field(const=20char=20=
*field,=20unsigned=20size,=20unsigned=20cur_size,=0A+=09=09=20=20=20=20=
unsigned=20offset,=20unsigned=20cur_offset)=0A=20{=0A+=09if=20(size=20!=3D=
=20cur_size)=20{=0A+=09=09printf("error:=20%s=20size=20%u=20should=20be=20=
%u\n",=0A+=09=09=20=20=20=20=20=20=20field,=20cur_size,=20size);=0A+=09=09=
exit(1);=0A+=09}=0A=20=09if=20(offset=20!=3D=20cur_offset)=20{=0A-=09=09=
printf("Warning!=20=20Unexpected=20offset=20at=20%s\n",=20field);=0A+=09=09=
printf("error:=20%s=20offset=20%u=20should=20be=20%u\n",=0A+=09=09=20=20=20=
=20=20=20=20field,=20cur_offset,=20offset);=0A=20=09=09exit(1);=0A=20=09=
}=0A=20=09printf("%8d=20%-30s=20%3u\n",=20offset,=20field,=20(unsigned)=20=
size);=0A=20=09return=20offset=20+=20size;=0A=20}=0A=20=0A-void=20=
check_structure_fields()=0A+int=20main(int=20argc,=20char=20**argv)=0A=20=
{=0A=20#if=20(__GNUC__=20>=3D=204)=0A=20=09int=20cur_offset=20=3D=200;=0A=
=20=0A=20=09printf("%8s=20%-30s=20%3s\n",=20"offset",=20"field",=20=
"size");=0A-=09check_field(i_mode);=0A-=09check_field(i_uid);=0A-=09=
check_field(i_size);=0A-=09check_field(i_atime);=0A-=09=
check_field(i_ctime);=0A-=09check_field(i_mtime);=0A-=09=
check_field(i_dtime);=0A-=09check_field(i_gid);=0A-=09=
check_field(i_links_count);=0A-=09check_field(i_blocks);=0A-=09=
check_field(i_flags);=0A-=09check_field(osd1.linux1.l_i_version);=0A-=09=
check_field(i_block);=0A-=09check_field(i_generation);=0A-=09=
check_field(i_file_acl);=0A-=09check_field(i_size_high);=0A-=09=
check_field(i_faddr);=0A-=09check_field(osd2.linux2.l_i_blocks_hi);=0A-=09=
check_field(osd2.linux2.l_i_file_acl_high);=0A-=09=
check_field(osd2.linux2.l_i_uid_high);=0A-=09=
check_field(osd2.linux2.l_i_gid_high);=0A-=09=
check_field(osd2.linux2.l_i_checksum_lo);=0A-=09=
check_field(osd2.linux2.l_i_reserved);=0A-=09printf("Ending=20offset=20=
is=20%d\n\n",=20cur_offset);=0A+=09check_field(i_mode,=202);=0A+=09=
check_field(i_uid,=202);=0A+=09check_field(i_size,=204);=0A+=09=
check_field(i_atime,=204);=0A+=09check_field(i_ctime,=204);=0A+=09=
check_field(i_mtime,=204);=0A+=09check_field(i_dtime,=204);=0A+=09=
check_field(i_gid,=202);=0A+=09check_field(i_links_count,=202);=0A+=09=
check_field(i_blocks,=204);=0A+=09check_field(i_flags,=204);=0A+=09=
check_field(osd1.linux1.l_i_version,=204);=0A+=09check_field(i_block,=20=
15=20*=204);=0A+=09check_field(i_generation,=204);=0A+=09=
check_field(i_file_acl,=204);=0A+=09check_field(i_size_high,=204);=0A+=09=
check_field(i_faddr,=204);=0A+=09check_field(osd2.linux2.l_i_blocks_hi,=20=
2);=0A+=09check_field(osd2.linux2.l_i_file_acl_high,=202);=0A+=09=
check_field(osd2.linux2.l_i_uid_high,=202);=0A+=09=
check_field(osd2.linux2.l_i_gid_high,=202);=0A+=09=
check_field(osd2.linux2.l_i_checksum_lo,=202);=0A+=09=
check_field(osd2.linux2.l_i_reserved,=202);=0A+=09do_field("Small=20=
inode=20end",=200,=200,=20cur_offset,=20128);=0A+=09=
check_field(i_extra_isize,=202);=0A+=09check_field(i_checksum_hi,=202);=0A=
+=09check_field(i_ctime_extra,=204);=0A+=09check_field(i_mtime_extra,=20=
4);=0A+=09check_field(i_atime_extra,=204);=0A+=09check_field(i_crtime,=20=
4);=0A+=09check_field(i_crtime_extra,=204);=0A+=09=
check_field(i_version_hi,=204);=0A+=09/*=20This=20size=20will=20change=20=
as=20new=20fields=20are=20added=20*/=0A+=09do_field("Large=20inode=20=
end",=200,=200,=20cur_offset,=20sizeof(inode));=0A=20#endif=0A-}=0A-=0A-=0A=
-int=20main(int=20argc,=20char=20**argv)=0A-{=0A-=09int=20l=20=3D=20=
sizeof(struct=20ext2_inode);=0A-=0A-=09check_structure_fields();=0A-=09=
printf("Size=20of=20struct=20ext2_inode=20is=20%d\n",=20l);=0A-=09if=20=
(l=20!=3D=20128)=20{=0A-=09=09exit(1);=0A-=09}=0A-=09exit(0);=0A+=09=
return=200;=0A=20}=0Adiff=20--git=20a/lib/ext2fs/tst_super_size.c=20=
b/lib/ext2fs/tst_super_size.c=0Aindex=206593652..76e6e6f=20100644=0A---=20=
a/lib/ext2fs/tst_super_size.c=0A+++=20b/lib/ext2fs/tst_super_size.c=0A@@=20=
-21,127=20+21,120=20@@=0A=20=0A=20struct=20sb_struct=20sb;=0A=20=0A-int=20=
verbose=20=3D=200;=0A-=0A=20#define=20offsetof(type,=20member)=20=20=
__builtin_offsetof=20(type,=20member)=0A-#define=20check_field(x)=20=
cur_offset=20=3D=20do_field(#x,=20sizeof(sb.x),=09=09\=0A-=09=09=09=09=09=
=20=20=20=20=20=20offsetof(struct=20sb_struct,=20x),=20\=0A-=09=09=09=09=09=
=20=20=20=20=20=20cur_offset)=0A+#define=20check_field(x,=20s)=20=
cur_offset=20=3D=20do_field(#x,=20s,=20sizeof(sb.x),=09=20=20=20=20=20=20=
=20\=0A+=09=09=09=09=09=09offsetof(struct=20sb_struct,=20x),=20\=0A+=09=09=
=09=09=09=09cur_offset)=0A=20=0A-static=20int=20do_field(const=20char=20=
*field,=20size_t=20size,=20int=20offset,=20int=20cur_offset)=0A+static=20=
int=20do_field(const=20char=20*field,=20unsigned=20size,=20unsigned=20=
cur_size,=0A+=09=09=20=20=20=20unsigned=20offset,=20unsigned=20=
cur_offset)=0A=20{=0A+=09if=20(size=20!=3D=20cur_size)=20{=0A+=09=09=
printf("error:=20%s=20size=20%u=20should=20be=20%u\n",=0A+=09=09=20=20=20=
=20=20=20=20field,=20cur_size,=20size);=0A+=09=09exit(1);=0A+=09}=0A=20=09=
if=20(offset=20!=3D=20cur_offset)=20{=0A-=09=09printf("Warning!=20=20=
Unexpected=20offset=20at=20%s\n",=20field);=0A+=09=09printf("error:=20%s=20=
offset=20%u=20should=20be=20%u\n",=0A+=09=09=20=20=20=20=20=20=20field,=20=
cur_offset,=20offset);=0A=20=09=09exit(1);=0A=20=09}=0A-=09printf("%8d=20=
%-30s=20%3u\n",=20offset,=20field,=20(unsigned)=20size);=0A+=09=
printf("%8d=20%-30s=20%3u\n",=20offset,=20field,=20size);=0A=20=09return=20=
offset=20+=20size;=0A=20}=0A=20=0A-void=20check_superblock_fields()=0A=
+int=20main(int=20argc,=20char=20**argv)=0A=20{=0A=20#if=20(__GNUC__=20=
>=3D=204)=0A=20=09int=20cur_offset=20=3D=200;=0A=20=0A=20=09printf("%8s=20=
%-30s=20%3s\n",=20"offset",=20"field",=20"size");=0A-=09=
check_field(s_inodes_count);=0A-=09check_field(s_blocks_count);=0A-=09=
check_field(s_r_blocks_count);=0A-=09check_field(s_free_blocks_count);=0A=
-=09check_field(s_free_inodes_count);=0A-=09=
check_field(s_first_data_block);=0A-=09check_field(s_log_block_size);=0A=
-=09check_field(s_log_cluster_size);=0A-=09=
check_field(s_blocks_per_group);=0A-=09=
check_field(s_clusters_per_group);=0A-=09=
check_field(s_inodes_per_group);=0A-=09check_field(s_mtime);=0A-=09=
check_field(s_wtime);=0A-=09check_field(s_mnt_count);=0A-=09=
check_field(s_max_mnt_count);=0A-=09check_field(s_magic);=0A-=09=
check_field(s_state);=0A-=09check_field(s_errors);=0A-=09=
check_field(s_minor_rev_level);=0A-=09check_field(s_lastcheck);=0A-=09=
check_field(s_checkinterval);=0A-=09check_field(s_creator_os);=0A-=09=
check_field(s_rev_level);=0A-=09check_field(s_def_resuid);=0A-=09=
check_field(s_def_resgid);=0A-=09check_field(s_first_ino);=0A-=09=
check_field(s_inode_size);=0A-=09check_field(s_block_group_nr);=0A-=09=
check_field(s_feature_compat);=0A-=09check_field(s_feature_incompat);=0A=
-=09check_field(s_feature_ro_compat);=0A-=09check_field(s_uuid);=0A-=09=
check_field(s_volume_name);=0A-=09check_field(s_last_mounted);=0A-=09=
check_field(s_algorithm_usage_bitmap);=0A-=09=
check_field(s_prealloc_blocks);=0A-=09=
check_field(s_prealloc_dir_blocks);=0A-=09=
check_field(s_reserved_gdt_blocks);=0A-=09check_field(s_journal_uuid);=0A=
-=09check_field(s_journal_inum);=0A-=09check_field(s_journal_dev);=0A-=09=
check_field(s_last_orphan);=0A-=09check_field(s_hash_seed);=0A-=09=
check_field(s_def_hash_version);=0A-=09check_field(s_jnl_backup_type);=0A=
-=09check_field(s_desc_size);=0A-=09check_field(s_default_mount_opts);=0A=
-=09check_field(s_first_meta_bg);=0A-=09check_field(s_mkfs_time);=0A-=09=
check_field(s_jnl_blocks);=0A-=09check_field(s_blocks_count_hi);=0A-=09=
check_field(s_r_blocks_count_hi);=0A-=09check_field(s_free_blocks_hi);=0A=
-=09check_field(s_min_extra_isize);=0A-=09=
check_field(s_want_extra_isize);=0A-=09check_field(s_flags);=0A-=09=
check_field(s_raid_stride);=0A-=09check_field(s_mmp_update_interval);=0A=
-=09check_field(s_mmp_block);=0A-=09check_field(s_raid_stripe_width);=0A=
-=09check_field(s_log_groups_per_flex);=0A-=09=
check_field(s_reserved_char_pad);=0A-=09check_field(s_reserved_pad);=0A-=09=
check_field(s_kbytes_written);=0A-=09check_field(s_snapshot_inum);=0A-=09=
check_field(s_snapshot_id);=0A-=09=
check_field(s_snapshot_r_blocks_count);=0A-=09=
check_field(s_snapshot_list);=0A-=09check_field(s_error_count);=0A-=09=
check_field(s_first_error_time);=0A-=09check_field(s_first_error_ino);=0A=
-=09check_field(s_first_error_block);=0A-=09=
check_field(s_first_error_func);=0A-=09check_field(s_first_error_line);=0A=
-=09check_field(s_last_error_time);=0A-=09check_field(s_last_error_ino);=0A=
-=09check_field(s_last_error_line);=0A-=09=
check_field(s_last_error_block);=0A-=09check_field(s_last_error_func);=0A=
-=09check_field(s_mount_opts);=0A-=09check_field(s_usr_quota_inum);=0A-=09=
check_field(s_grp_quota_inum);=0A-=09check_field(s_overhead_blocks);=0A-=09=
check_field(s_reserved);=0A-=09check_field(s_checksum);=0A-=09=
printf("Ending=20offset=20is=20%d\n\n",=20cur_offset);=0A+=09=
check_field(s_inodes_count,=204);=0A+=09check_field(s_blocks_count,=20=
4);=0A+=09check_field(s_r_blocks_count,=204);=0A+=09=
check_field(s_free_blocks_count,=204);=0A+=09=
check_field(s_free_inodes_count,=204);=0A+=09=
check_field(s_first_data_block,=204);=0A+=09=
check_field(s_log_block_size,=204);=0A+=09=
check_field(s_log_cluster_size,=204);=0A+=09=
check_field(s_blocks_per_group,=204);=0A+=09=
check_field(s_clusters_per_group,=204);=0A+=09=
check_field(s_inodes_per_group,=204);=0A+=09check_field(s_mtime,=204);=0A=
+=09check_field(s_wtime,=204);=0A+=09check_field(s_mnt_count,=202);=0A+=09=
check_field(s_max_mnt_count,=202);=0A+=09check_field(s_magic,=202);=0A+=09=
check_field(s_state,=202);=0A+=09check_field(s_errors,=202);=0A+=09=
check_field(s_minor_rev_level,=202);=0A+=09check_field(s_lastcheck,=20=
4);=0A+=09check_field(s_checkinterval,=204);=0A+=09=
check_field(s_creator_os,=204);=0A+=09check_field(s_rev_level,=204);=0A+=09=
check_field(s_def_resuid,=202);=0A+=09check_field(s_def_resgid,=202);=0A=
+=09check_field(s_first_ino,=204);=0A+=09check_field(s_inode_size,=202);=0A=
+=09check_field(s_block_group_nr,=202);=0A+=09=
check_field(s_feature_compat,=204);=0A+=09=
check_field(s_feature_incompat,=204);=0A+=09=
check_field(s_feature_ro_compat,=204);=0A+=09check_field(s_uuid,=2016);=0A=
+=09check_field(s_volume_name,=2016);=0A+=09check_field(s_last_mounted,=20=
64);=0A+=09check_field(s_algorithm_usage_bitmap,=204);=0A+=09=
check_field(s_prealloc_blocks,=201);=0A+=09=
check_field(s_prealloc_dir_blocks,=201);=0A+=09=
check_field(s_reserved_gdt_blocks,=202);=0A+=09=
check_field(s_journal_uuid,=2016);=0A+=09check_field(s_journal_inum,=20=
4);=0A+=09check_field(s_journal_dev,=204);=0A+=09=
check_field(s_last_orphan,=204);=0A+=09check_field(s_hash_seed,=204=20*=20=
4);=0A+=09check_field(s_def_hash_version,=201);=0A+=09=
check_field(s_jnl_backup_type,=201);=0A+=09check_field(s_desc_size,=20=
2);=0A+=09check_field(s_default_mount_opts,=204);=0A+=09=
check_field(s_first_meta_bg,=204);=0A+=09check_field(s_mkfs_time,=204);=0A=
+=09check_field(s_jnl_blocks,=2017=20*=204);=0A+=09=
check_field(s_blocks_count_hi,=204);=0A+=09=
check_field(s_r_blocks_count_hi,=204);=0A+=09=
check_field(s_free_blocks_hi,=204);=0A+=09check_field(s_min_extra_isize,=20=
2);=0A+=09check_field(s_want_extra_isize,=202);=0A+=09=
check_field(s_flags,=204);=0A+=09check_field(s_raid_stride,=202);=0A+=09=
check_field(s_mmp_update_interval,=202);=0A+=09check_field(s_mmp_block,=20=
8);=0A+=09check_field(s_raid_stripe_width,=204);=0A+=09=
check_field(s_log_groups_per_flex,=201);=0A+=09=
check_field(s_reserved_char_pad,=201);=0A+=09check_field(s_reserved_pad,=20=
2);=0A+=09check_field(s_kbytes_written,=208);=0A+=09=
check_field(s_snapshot_inum,=204);=0A+=09check_field(s_snapshot_id,=20=
4);=0A+=09check_field(s_snapshot_r_blocks_count,=208);=0A+=09=
check_field(s_snapshot_list,=204);=0A+=09check_field(s_error_count,=20=
4);=0A+=09check_field(s_first_error_time,=204);=0A+=09=
check_field(s_first_error_ino,=204);=0A+=09=
check_field(s_first_error_block,=208);=0A+=09=
check_field(s_first_error_func,=2032);=0A+=09=
check_field(s_first_error_line,=204);=0A+=09=
check_field(s_last_error_time,=204);=0A+=09check_field(s_last_error_ino,=20=
4);=0A+=09check_field(s_last_error_line,=204);=0A+=09=
check_field(s_last_error_block,=208);=0A+=09=
check_field(s_last_error_func,=2032);=0A+=09check_field(s_mount_opts,=20=
64);=0A+=09check_field(s_usr_quota_inum,=204);=0A+=09=
check_field(s_grp_quota_inum,=204);=0A+=09check_field(s_overhead_blocks,=20=
4);=0A+=09check_field(s_reserved,=20108=20*=204);=0A+=09=
check_field(s_checksum,=204);=0A+=09do_field("Superblock=20end",=200,=20=
0,=20cur_offset,=201024);=0A=20#endif=0A-}=0A-=0A-=0A-int=20main(int=20=
argc,=20char=20**argv)=0A-{=0A-=09int=20s=20=3D=20sizeof(struct=20=
sb_struct);=0A-=0A-=09check_superblock_fields();=0A-=09printf("Size=20of=20=
struct=20%s=20is=20%d\n",=20sb_struct_name,=20s);=0A-=09if=20(s=20!=3D=20=
1024)=20{=0A-=09=09exit(1);=0A-=09}=0A-=09exit(0);=0A+=09return=200;=0A=20=
}=0A--=20=0A1.7.2=0A=0A=

--Apple-Mail-26--688347242--
