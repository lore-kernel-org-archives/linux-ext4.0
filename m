From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: More performance results
Date: Mon, 16 Mar 2009 10:06:07 -0700
Message-ID: <1237223167.8276.16.camel@mingming-laptop>
References: <49871813.8090309@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-btrfs@vger.kernel.org, Steven Pratt <slpratt@austin.ibm.com>
To: tytso <tytso@mit.edu>, linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:35349 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760348AbZCPRGM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Mar 2009 13:06:12 -0400
In-Reply-To: <49871813.8090309@austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=E5=9C=A8 2009-02-02=E4=B8=80=E7=9A=84 09:58 -0600=EF=BC=8CSteven Pratt=
=E5=86=99=E9=81=93=EF=BC=9A
> Finally cleared out a backlog of results to upload.  Main performance=
=20
> page is updated with all the links.  (http://btrfs.boxacle.net/)  Mos=
t=20
> recent results are on 2.6.29-rc2. As usual see analysis directory of=20
> results for oprofile, including call graphs.
>=20
> Single disk results are not too bad.  Raid still falls apart on any=20
> write heavy workload.
>=20
> Steve
>=20
Quick link to the latest single disk IO results:

http://btrfs.boxacle.net/repository/single-disk/2.6.29-rc2/2.6.29-rc2/2=
=2E6.29-rc2.html

Steve's fs performance tests shows performance regression on ext4 compa=
ring with ext3 with O_DIRECT random writes,  about 10% on single disk. =
=20

http://btrfs.boxacle.net/repository/single-disk/2.6.29-rc2/2.6.29-rc2/2=
=2E6.29-rc2_Large_file_random_writes_odirect._num_threads=3D32.html

And looked at the oprofile,  comparing with ext3,  ext4 seems  mark the
inode  diry quit often than ext3 does.=20

62        0.0063  ext3.ko                  ext3_mark_iloc_dirty
367       0.0371  ext4.ko                  ext4_mark_iloc_dirty

This also seen in random read test (with no O_DIRECT) oprfofile data, s=
o
it doesn't seem not a O_DIRECT issue.

Any thoughts?


More detail about the ext3/4 random odirect writes oprofile...


ext3:

:~/ext4$ grep ext3 oprofile-ext3-random-write-odirect.001=20
554       0.0567  ext3.ko                  ext3_get_branch
346       0.0354  ext3.ko                  ext3_file_write
336       0.0344  ext3.ko                  ext3_direct_IO
215       0.0220  ext3.ko                  ext3_get_blocks_handle
125       0.0128  ext3.ko                  ext3_block_to_path
112       0.0115  ext3.ko                  verify_chain
76        0.0078  ext3.ko                  ext3_get_block
62        0.0063  ext3.ko                  ext3_mark_iloc_dirty
39        0.0040  ext3.ko                  __ext3_get_inode_loc
17        0.0017  ext3.ko                  ext3_getblk
14        0.0014  ext3.ko                  ext3_get_group_desc
13        0.0013  ext3.ko
__ext3_journal_get_write_access
13        0.0013  ext3.ko                  ext3_find_entry
13        0.0013  ext3.ko                  ext3_new_blocks
13        0.0013  ext3.ko                  ext3_reserve_inode_write
=2E...

$ grep ext4 oprofile-ext4-random-write-odirect.001=20
warning: could not check that the binary
file /lib/modules/2.6.29-rc2/kernel/fs/ext4/ext4.ko has not been
modified since the profile was taken. Results may be inaccurate.
420       0.0425  ext4.ko                  ext4_direct_IO
411       0.0416  ext4.ko                  ext4_file_write
403       0.0408  ext4.ko                  ext4_ext_find_extent
374       0.0378  ext4.ko                  __ext4_get_inode_loc
367       0.0371  ext4.ko                  ext4_mark_iloc_dirty
202       0.0204  ext4.ko                  ext4_ext_get_blocks
194       0.0196  ext4.ko                  ext4_get_blocks_wrap
179       0.0181  ext4.ko                  __ext4_ext_check_header
178       0.0180  ext4.ko                  ext4_journal_start_sb
117       0.0118  ext4.ko                  ext4_get_block
109       0.0110  ext4.ko                  ext4_get_group_desc
89        0.0090  ext4.ko                  ext4_mark_inode_dirty
84        0.0085  ext4.ko                  ext4_dirty_inode
74        0.0075  ext4.ko                  __ext4_journal_stop
=2E....

:~/ext4$ grep jbd2 oprofile-ext4-random-write-odirect.001=20
450       0.0455  jbd2.ko                  start_this_handle
288       0.0291  jbd2.ko                  do_get_write_access
287       0.0290  jbd2.ko                  jbd2_journal_stop
244       0.0247  jbd2.ko                  jbd2_journal_start
235       0.0238  jbd2.ko                  jbd2_journal_dirty_metadata
214       0.0216  jbd2.ko                  jbd2_journal_add_journal_hea=
d


~/ext4$ grep jbd oprofile-ext3-random-write-odirect.001=20
116       0.0119  jbd.ko                   journal_add_journal_head
94        0.0096  jbd.ko                   do_get_write_access
73        0.0075  jbd.ko                   start_this_handle
68        0.0070  jbd.ko                   journal_clean_one_cp_list
58        0.0059  jbd.ko                   journal_commit_transaction
48        0.0049  jbd.ko                   journal_dirty_metadata
45        0.0046  jbd.ko                   __journal_file_buffer
42        0.0043  jbd.ko                   __journal_temp_unlink_buffer
42        0.0043  jbd.ko                   journal_put_journal_head





> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
