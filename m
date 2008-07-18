From: Josef Bacik <jbacik@redhat.com>
Subject: Re: ext3 on latest -git: BUG: unable to handle kernel NULL pointer
	dereference at 0000000c
Date: Fri, 18 Jul 2008 07:20:03 -0400
Message-ID: <20080718112003.GC15844@unused.rdu.redhat.com>
References: <20080717141333.GC14133@unused.rdu.redhat.com> <19f34abd0807170735p5d2cba31kec3fb65c5b8c7b3f@mail.gmail.com> <20080717141655.GD14133@unused.rdu.redhat.com> <19f34abd0807170744r79e46a78odfcfbd67687d2ceb@mail.gmail.com> <20080717143332.GE14133@unused.rdu.redhat.com> <19f34abd0807170800q13cc021dyed27c665c25ac520@mail.gmail.com> <20080717144342.GA15844@unused.rdu.redhat.com> <20080717230905.GI6239@webber.adilger.int> <20080718105152.GB15844@unused.rdu.redhat.com> <19f34abd0807180432i19567dfal5d7d29bb1916b562@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, Andreas Dilger <adilger@sun.com>,
	Josef Bacik <josef@toxicpanda.com>, linux-ext4@vger.kernel.org,
	sct@redhat.com, akpm@linux-foundation.org,
	Johannes Weiner <hannes@saeurebad.de>,
	linux-kernel@vger.kernel.org
To: Vegard Nossum <vegard.nossum@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971AbYGRLjj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jul 2008 07:39:39 -0400
Content-Disposition: inline
In-Reply-To: <19f34abd0807180432i19567dfal5d7d29bb1916b562@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2008 at 01:32:10PM +0200, Vegard Nossum wrote:
> On Fri, Jul 18, 2008 at 12:51 PM, Josef Bacik <jbacik@redhat.com> wrote:
> > On Thu, Jul 17, 2008 at 05:09:05PM -0600, Andreas Dilger wrote:
> >> On Jul 17, 2008  10:43 -0400, Josef Bacik wrote:
> >> > Yeah thats a hard to answer question, one that I will leave up to others
> >> > who have been doing this much longer than I.  My thought is remount-ro
> >> > is there to keep you from crashing, so if you have errors=continue then
> >> > you expect to live with the consequences.  Course if that bit gets flipped
> >> > via corruption thats not good either.
> >>
> >> It shouldn't cause the kernel to crash, but it should definitely return
> >> an error to the application.  This is probably one of the code paths
> >> that the Coverity folks were reporting on in FAST this year where on-disk
> >> errors are not propagated to the application.
> >
> > Ok, please revert the previous patch and apply this one.  On errors=continue we
> > will just abort the handle which should keep the NULL pointer dereference from
> > happening and return an error back to the application.  Please let me know how
> > this works Vegard, and thanks alot for testing all this.
> >
> > Signed-off-by: Josef Bacik <jbacik@redhat.com>
> 
> Thanks for doing the patches :-)
> 
> I still got this:
> 
> loop0: rw=0, want=4294967298, limit=24576
> EXT3-fs error (device loop0): ext3_free_branches: Read failure,
> inode=74, block=2147483648
> EXT3-fs error (device loop0) in ext3_reserve_inode_write: Readonly filesystem
> EXT3-fs error (device loop0) in ext3_truncate: IO failure
> EXT3-fs error (device loop0) in ext3_reserve_inode_write: Readonly filesystem
> EXT3-fs error (device loop0) in ext3_orphan_del: Readonly filesystem
> EXT3-fs error (device loop0) in ext3_reserve_inode_write: Readonly filesystem
> EXT3-fs error (device loop0) in ext3_delete_inode: IO failure
> EXT3-fs unexpected failure: !jh->b_committed_data;
> inconsistent data on disk
> ext3_forget: aborting transaction: IO failure in __ext3_journal_forget
> BUG: unable to handle kernel paging request at f1e79ffc
> IP: [<c02224d6>] read_block_bitmap+0xc6/0x180
> *pde = 33cc5163 *pte = 31e79160
> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> Pid: 4257, comm: rm Not tainted (2.6.26-03416-g11155ca #46)
> EIP: 0060:[<c02224d6>] EFLAGS: 00210297 CPU: 1
> EIP is at read_block_bitmap+0xc6/0x180
> EAX: ffffffff EBX: f1e7a000 ECX: f3c20000 EDX: 00000001
> ESI: f5663c30 EDI: f1e7a800 EBP: f62e3cdc ESP: f62e3cac
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process rm (pid: 4257, ti=f62e2000 task=f637dfa0 task.ti=f62e2000)
> Stack: 00000400 f637e4c0 f637dfa0 f62e3cd4 00200246 00000000 f3d2c860 00000000
>        f1e7a000 f3c20098 00000000 f56c4b7c f62e3d3c c0222704 c025efd3 f637dfa0
>        c015addb f77aa050 f3d2db0c 00000031 00000000 00000032 f3d2c860 f77aa050
> Call Trace:
>  [<c0222704>] ? ext3_free_blocks_sb+0xd4/0x620
>  [<c025efd3>] ? journal_forget+0x213/0x220
>  [<c015addb>] ? trace_hardirqs_on+0xb/0x10
>  [<c0222c7a>] ? ext3_free_blocks+0x2a/0xa0
>  [<c0228d85>] ? ext3_clear_blocks+0x145/0x160
>  [<c0228e67>] ? ext3_free_data+0xc7/0x100
>  [<c02290b3>] ? ext3_free_branches+0x213/0x220
>  [<c01c9160>] ? sync_buffer+0x0/0x40
>  [<c0228f4e>] ? ext3_free_branches+0xae/0x220
>  [<c0228f4e>] ? ext3_free_branches+0xae/0x220
>  [<c0229688>] ? ext3_truncate+0x5c8/0x940
>  [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
>  [<c02606f3>] ? journal_start+0xd3/0x110
>  [<c02606d0>] ? journal_start+0xb0/0x110
>  [<c0229ad7>] ? ext3_delete_inode+0xd7/0xe0
>  [<c0229a00>] ? ext3_delete_inode+0x0/0xe0
>  [<c01b9ba1>] ? generic_delete_inode+0x81/0x120
>  [<c01b9d67>] ? generic_drop_inode+0x127/0x180
>  [<c01b8be7>] ? iput+0x47/0x50
>  [<c01af1bc>] ? do_unlinkat+0xec/0x170
>  [<c01b185b>] ? vfs_readdir+0x6b/0xa0
>  [<c01b1540>] ? filldir64+0x0/0xf0
>  [<c04309a8>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
>  [<c01af383>] ? sys_unlinkat+0x23/0x50
>  [<c010407f>] ? sysenter_past_esp+0x78/0xc5
>  =======================
> Code: 00 00 00 8b 45 e8 8b 1f 8b 55 e4 8b 88 ac 02 00 00 8b 41 34 0f
> af 51 10 03 50 14 89 5d ec 8b 46 18 89 45 f0 89 d8 8b 5d f0 29 d0 <0f>
> a3 03 19 c0 85 c0 74 11 8b 47 04 89 45 ec 29 d0 0f a3 03 19
> EIP: [<c02224d6>] read_block_bitmap+0xc6/0x180 SS:ESP 0068:f62e3cac
> Kernel panic - not syncing: Fatal exception
> ------------[ cut here ]------------
> 
> This was with error=continue.
> 
> $ addr2line -e vmlinux -i c02224d6
> include/asm/bitops.h:305
> fs/ext3/balloc.c:98
> fs/ext3/balloc.c:167
> 
> It looks similar to the ext2 crash which I just reported:
> http://lkml.org/lkml/2008/7/18/136
> 
> Which had this EIP:
> 
> $ addr2line -e vmlinux -i c026ee46
> include/asm/bitops.h:305
> fs/ext2/balloc.c:87
> fs/ext2/balloc.c:153
> 
> You can see the full log at
> http://folk.uio.no/vegardno/linux/log-1216380709.txt which shows that
> it already survived a lot of failures, so I'm guessing your patch was
> correct and we just hit a different case. What do you think?
>

Yeah you are right, its like a shitty game of wack-a-mole.  Heres another patch,
same thing as last time, pull the other one out put this one on.  Thanks,

Josef

 
Index: linux-2.6/fs/ext3/inode.c
===================================================================
--- linux-2.6.orig/fs/ext3/inode.c
+++ linux-2.6/fs/ext3/inode.c
@@ -2023,13 +2023,27 @@ static void ext3_clear_blocks(handle_t *
 		unsigned long count, __le32 *first, __le32 *last)
 {
 	__le32 *p;
+	int ret;
+
 	if (try_to_extend_transaction(handle, inode)) {
 		if (bh) {
 			BUFFER_TRACE(bh, "call ext3_journal_dirty_metadata");
-			ext3_journal_dirty_metadata(handle, bh);
+			ret = ext3_journal_dirty_metadata(handle, bh);
+			if (ret) {
+				ext3_std_error(inode->i_sb, ret);
+				return;
+			}
 		}
-		ext3_mark_inode_dirty(handle, inode);
-		ext3_journal_test_restart(handle, inode);
+		ret = ext3_mark_inode_dirty(handle, inode);
+		if (ret)
+			return;
+
+		ret = ext3_journal_test_restart(handle, inode);
+		if (ret) {
+			ext3_std_error(inode->i_sb, ret);
+			return;
+		}
+
 		if (bh) {
 			BUFFER_TRACE(bh, "retaking write access");
 			ext3_journal_get_write_access(handle, bh);
@@ -2051,7 +2065,9 @@ static void ext3_clear_blocks(handle_t *
 
 			*p = 0;
 			bh = sb_find_get_block(inode->i_sb, nr);
-			ext3_forget(handle, 0, inode, bh, nr);
+			ret = ext3_forget(handle, 0, inode, bh, nr);
+			if (ret)
+				return;
 		}
 	}
 
Index: linux-2.6/fs/ext3/balloc.c
===================================================================
--- linux-2.6.orig/fs/ext3/balloc.c
+++ linux-2.6/fs/ext3/balloc.c
@@ -498,6 +498,7 @@ void ext3_free_blocks_sb(handle_t *handl
 		ext3_error (sb, "ext3_free_blocks",
 			    "Freeing blocks not in datazone - "
 			    "block = "E3FSBLK", count = %lu", block, count);
+		err = -EIO;
 		goto error_return;
 	}
 
@@ -535,6 +536,7 @@ do_more:
 			    "Freeing blocks in system zones - "
 			    "Block = "E3FSBLK", count = %lu",
 			    block, count);
+		err = -EIO;
 		goto error_return;
 	}
 
Index: linux-2.6/fs/ext3/super.c
===================================================================
--- linux-2.6.orig/fs/ext3/super.c
+++ linux-2.6/fs/ext3/super.c
@@ -167,7 +167,15 @@ static void ext3_handle_error(struct sup
 		EXT3_SB(sb)->s_mount_opt |= EXT3_MOUNT_ABORT;
 		if (journal)
 			journal_abort(journal, -EIO);
+	} else {
+		handle_t *handle = current->journal_info;
+		if (handle && !is_handle_aborted(handle)) {
+			if (!handle->h_err)
+				handle->h_err = -EIO;
+			journal_abort_handle(handle);
+		}
 	}
+
 	if (test_opt (sb, ERRORS_RO)) {
 		printk (KERN_CRIT "Remounting filesystem read-only\n");
 		sb->s_flags |= MS_RDONLY;
