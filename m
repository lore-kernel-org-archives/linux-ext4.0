From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Re: BUG_ON at mballoc.c:3752
Date: Fri, 8 Feb 2008 16:31:35 +0100
Message-ID: <20080208153135.GB9111@alice>
References: <20080131140137.GA20780@alice> <20080131154207.GA22201@alice> <20080204060055.GC7494@skywalker> <1202335188.6886.15.camel@norville.austin.ibm.com> <20080207125548.GA8701@skywalker> <20080208150705.GA9111@alice> <47AC7492.1050907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45810 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753250AbYBHPbi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Feb 2008 10:31:38 -0500
Content-Disposition: inline
In-Reply-To: <47AC7492.1050907@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Eric Sandeen (sandeen@redhat.com) wrote:
> Eric Sesterhenn wrote:
> >> Eric ,
> >> can you run the test with below patch and see if this makes any
> >> difference ?. I know we are not fixing any bugs in the below patch.
> > 
> > ok, i checked out the old version again and applied both patches,
> > the BUG is gone (no surprise)
> > In the case where it would have hit the BUG i now get the following message:
> > 
> > [  740.400288] Aborting journal on device loop0.
> 
> No message before that about *why* it aborted?

assumed the stuff was from the previous runs


[  113.318700] Aborting journal on device loop0.
[  113.324237] ext4_abort called.
[  113.324312] EXT4-fs error (device loop0): ext4_journal_start_sb:
Detected aborted journal
[  113.324394] Remounting filesystem read-only
[  113.330324] EXT4-fs error (device loop0) in ext4_dirty_inode: IO
failure
[  113.330438] EXT4-fs error (device loop0) in ext4_ordered_write_end:
IO failure
[  114.884485] EXT4-fs error (device loop0): ext4_mb_generate_buddy:
EXT4-fs: group 0: 6590 blocks in bitmap, 6600 in gd
[  116.193424] Aborting journal on device loop0.
[  116.196910] ext4_abort called.
[  116.197064] EXT4-fs error (device loop0): ext4_journal_start_sb:
Detected aborted journal
[  116.197147] Remounting filesystem read-only
[  118.031066] EXT4-fs error (device loop0): ext4_mb_generate_buddy:
EXT4-fs: group 0: 6590 blocks in bitmap, 6600 in gd
[  119.692812] Buffer I/O error on device loop0, logical block 20729
[  121.968397] Buffer I/O error on device loop0, logical block 20729
[  123.124070] Aborting journal on device loop0.
[  123.125550] ext4_abort called.
[  123.125654] EXT4-fs error (device loop0): ext4_journal_start_sb:
Detected aborted journal
[  123.125736] Remounting filesystem read-only
[  123.145792] pa cba56770: logic 32, phys. 3649, len 32
[  123.145861] EXT4-fs error (device loop0): ext4_mb_release_inode_pa:
free 30, pa_free 29
[  123.145943] EXT4-fs error (device loop0) in ext4_mb_free_blocks:
Journal has aborted
[  123.153174] EXT4-fs error (device loop0) in ext4_dirty_inode: IO
failure
[  123.153287] EXT4-fs error (device loop0) in ext4_reserve_inode_write:
Journal has aborted
[  123.153363] pa cba56198: logic 16, phys. 2113, len 16
[  123.153387] EXT4-fs error (device loop0): ext4_mb_release_inode_pa:
free 15, pa_free 14
[  123.153488] EXT4-fs error (device loop0) in ext4_mb_free_blocks:
Journal has aborted
[  125.193083] EXT4-fs error (device loop0): ext4_mb_generate_buddy:
EXT4-fs: group 0: 6590 blocks in bitmap, 6600 in gd
[  127.683441] Aborting journal on device loop0.
[  127.685090] EXT4-fs error (device loop0) in ext4_reserve_inode_write:
Journal has aborted
[  127.687548] pa cba56330: logic 16, phys. 1969, len 16
[  127.687585] EXT4-fs error (device loop0): ext4_mb_release_inode_pa:
free 16, pa_free 15
[  127.687687] BUG: sleeping function called from invalid context at
include/linux/buffer_head.h:325
[  127.688494] BUG: scheduling while atomic: fstest/4447/0x00000002
[  127.712616] EXT4-fs error (device loop0) in ext4_reserve_inode_write:
Journal has aborted
[  127.713055] BUG: scheduling while atomic: fstest/4447/0x00000002
[  127.715557] EXT4-fs error (device loop0) in ext4_orphan_add: Journal
has aborted
[  127.735782] EXT4-fs error (device loop0) in ext4_reserve_inode_write:
Journal has aborted
[  127.735883] BUG: scheduling while atomic: fstest/4447/0x00000002
[  127.736851] EXT4-fs error (device loop0) in ext4_setattr: Journal has
aborted
[  127.758924] ext4_abort called.
[  127.759044] EXT4-fs error (device loop0): ext4_journal_start_sb:
Detected aborted journal
[  127.759125] Remounting filesystem read-only
[  127.762504] EXT4-fs error (device loop0) in ext4_mb_free_blocks:
Journal has aborted
[  130.003586] EXT4-fs error (device loop0): ext4_mb_generate_buddy:
EXT4-fs: group 0: 6590 blocks in bitmap, 6600 in gd
[  133.104600] Aborting journal on device loop0.
[  133.109459] ext4_abort called.
[  133.109528] EXT4-fs error (device loop0): ext4_journal_start_sb:
Detected aborted journal
[  133.109683] Remounting filesystem read-only
[  133.128537] EXT4-fs error (device loop0) in ext4_dirty_inode: IO
failure
[  133.128766] EXT4-fs error (device loop0) in ext4_reserve_inode_write:
Journal has aborted
[  133.128803] EXT4-fs error (device loop0) in ext4_mb_free_blocks:
Journal has aborted
[  135.037160] EXT4-fs error (device loop0): ext4_mb_generate_buddy:
EXT4-fs: group 0: 6590 blocks in bitmap, 6600 in gd
[  135.995986] Aborting journal on device loop0.
[  135.999977] ext4_abort called.
[  136.000049] EXT4-fs error (device loop0): ext4_journal_start_sb:
Detected aborted journal
[  136.000129] Remounting filesystem read-only
[  136.005258] pa cba56440: logic 32, phys. 2081, len 32
[  136.005312] EXT4-fs error (device loop0): ext4_mb_release_inode_pa:
free 30, pa_free 29
[  136.005478] EXT4-fs error (device loop0) in ext4_mb_free_blocks:
Journal has aborted
[  136.011164] EXT4-fs error (device loop0) in ext4_reserve_inode_write:
Journal has aborted
[  136.011280] pa cba56088: logic 16, phys. 1857, len 16
[  136.011304] EXT4-fs error (device loop0): ext4_mb_release_inode_pa:
free 7, pa_free 6
[  136.011403] EXT4-fs error (device loop0) in ext4_mb_free_blocks:
Journal has aborted
[  137.489878] EXT4-fs error (device loop0): ext4_mb_generate_buddy:
EXT4-fs: group 0: 6590 blocks in bitmap, 6600 in gd
[  139.140550] Aborting journal on device loop0.
[  139.144889] ext4_abort called.
[  139.145015] EXT4-fs error (device loop0): ext4_journal_start_sb:
Detected aborted journal
[  139.145098] Remounting filesystem read-only
[  141.115285] EXT4-fs error (device loop0): ext4_mb_generate_buddy:
EXT4-fs: group 0: 6590 blocks in bitmap, 6600 in gd
[  142.790793] Buffer I/O error on device loop0, logical block 13239314
[  673.819560] EXT4-fs error (device loop0): ext4_mb_generate_buddy:
EXT4-fs: group 0: 6590 blocks in bitmap, 6600 in gd
[  675.794735] Buffer I/O error on device loop0, logical block
4060087480
[  676.048909] Aborting journal on device loop0.
[  676.050604] ext4_abort called.
[  676.050670] EXT4-fs error (device loop0): ext4_journal_start_sb:
Detected aborted journal
[  676.050752] Remounting filesystem read-only
[  676.065725] EXT4-fs error (device loop0) in ext4_ordered_write_end:
IO failure
[  697.154481] EXT4-fs error (device loop0): ext4_mb_generate_buddy:
EXT4-fs: group 0: 6590 blocks in bitmap, 6600 in gd
[  701.149256] Aborting journal on device loop0.
[  701.150812] ext4_abort called.
[  701.150856] EXT4-fs error (device loop0): ext4_journal_start_sb:
Detected aborted journal
[  701.151010] Remounting filesystem read-only
[  701.171010] EXT4-fs error (device loop0) in ext4_ordered_write_end:
IO failure
[  728.261874] EXT4-fs error (device loop0): ext4_mb_generate_buddy:
EXT4-fs: group 0: 6590 blocks in bitmap, 6600 in gd
[  729.913716] Aborting journal on device loop0.
[  729.917148] ext4_abort called.
[  729.917216] EXT4-fs error (device loop0): ext4_journal_start_sb:
Detected aborted journal
[  729.917298] Remounting filesystem read-only
[  729.933777] EXT4-fs error (device loop0) in ext4_reserve_inode_write:
Journal has aborted
[  729.933858] EXT4-fs error (device loop0) in ext4_mb_free_blocks:
Journal has aborted
[  729.941235] EXT4-fs error (device loop0) in ext4_mb_free_blocks:
Journal has aborted
[  729.941314] EXT4-fs error (device loop0) in ext4_reserve_inode_write:
Journal has aborted
[  729.941343] EXT4-fs error (device loop0) in ext4_reserve_inode_write:
Journal has aborted
[  729.941398] EXT4-fs error (device loop0) in ext4_ext_remove_space:
Journal has aborted
[  729.941431] EXT4-fs error (device loop0) in ext4_reserve_inode_write:
Journal has aborted
[  729.941481] EXT4-fs error (device loop0) in ext4_orphan_del: Journal
has aborted
[  735.424574] EXT4-fs error (device loop0): ext4_mb_generate_buddy:
EXT4-fs: group 0: 6590 blocks in bitmap, 6600 in gd
[  740.400288] Aborting journal on device loop0.
[  740.405032] ext4_abort called.
[  740.405097] EXT4-fs error (device loop0): ext4_journal_start_sb:
Detected aborted journal
[  740.405178] Remounting filesystem read-only
[  740.410974] EXT4-fs error (device loop0) in ext4_ordered_write_end:
IO failure
[  740.414300] EXT4-fs error (device loop0) in ext4_reserve_inode_write:
Journal has aborted
[  740.414422] pa cba56990: logic 16, phys. 1953, len 16
[  740.414447] EXT4-fs error (device loop0): ext4_mb_release_inode_pa:
free 4, pa_free 3
[  740.414548] EXT4-fs error (device loop0) in ext4_mb_free_blocks:
Journal has aborted


Greetings, Eric
