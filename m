From: Jan Kara <jack@suse.cz>
Subject: Re: Delayed allocation and journal locking order inversion.
Date: Wed, 28 May 2008 12:08:33 +0200
Message-ID: <20080528100833.GC8289@duck.suse.cz>
References: <20080528091648.GA15851@skywalker>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="BXVAT5kNtrzKuDFl"
Cc: Mingming Cao <cmm@us.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:56499 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750854AbYE1KIf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 May 2008 06:08:35 -0400
Content-Disposition: inline
In-Reply-To: <20080528091648.GA15851@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi Aneesh,

  Thanks for testing!

On Wed 28-05-08 14:46:48, Aneesh Kumar K.V wrote:
> I am observing hangs with the delalloc with locking order inversion
> patches. I guess we can't start journal and call write_cache_pages.
  This should be fine after the lock inversion...

> The process get stuck as below
> 
> fsstress      D 00000008     0  2520      1
>        c69c9d70 00000046 c69c9d28 00000008 c6a300a0 c69c50e0 c69c5244 c1210d80 
>        00000000 c7a102a0 c69c50e0 c043c960 c69c9da8 c69c9d6c c0246fe8 00000000 
>        00000000 00000000 c69c9da8 c1210d80 c69c9da8 c11c0998 c69c9d7c c043a8cb 
> Call Trace:
>  [<c043c960>] ? _spin_unlock_irqrestore+0x36/0x58
>  [<c0246fe8>] ? blk_unplug+0x63/0x6b
>  [<c043a8cb>] io_schedule+0x1e/0x28
>  [<c014aac1>] sync_page+0x36/0x3a
>  [<c043aa17>] __wait_on_bit_lock+0x30/0x59
>  [<c014aa8b>] ? sync_page+0x0/0x3a
>  [<c014aa77>] __lock_page+0x4e/0x56
>  [<c01325a4>] ? wake_bit_function+0x0/0x43
>  [<c014ffca>] write_cache_pages+0x120/0x296
>  [<c018c516>] ? __mpage_da_writepage+0x0/0x105
>  [<c043c89d>] ? _spin_unlock+0x27/0x3c
>  [<c018bde8>] mpage_da_writepages+0x5c/0x7e
>  [<c01faa8f>] ? jbd2_journal_start+0xce/0xf0
>  [<c01faaa4>] ? jbd2_journal_start+0xe3/0xf0
>  [<c01d893b>] ? ext4_da_get_block_write+0x0/0x151
>  [<c01d8cc6>] ext4_da_writepages+0xbe/0x116
>  [<c01d8c08>] ? ext4_da_writepages+0x0/0x116
>  [<c015018a>] do_writepages+0x23/0x34
>  [<c0180ffa>] __writeback_single_inode+0x12a/0x260
>  [<c0181480>] sync_sb_inodes+0x18d/0x25b
>  [<c01815d0>] sync_inodes_sb+0x82/0x94
>  [<c0181638>] __sync_inodes+0x56/0x9c
>  [<c0181692>] sync_inodes+0x14/0x2c
>  [<c0183bc1>] do_sync+0x14/0x50
>  [<c0183c0a>] sys_sync+0xd/0x13
>  [<c0103931>] sysenter_past_esp+0x6a/0xb1
  The question here is, who is holding the lock from the page we wait
for here. The two processes you show below don't seem to hold it. I'll
check the full log ... searching ... I see!
  The problem is in generic_write_end()! It calls mark_inode_dirty() under
page lock. That can possibly start a new transaction (which happened in
your case) and that violates lock ordering (mark_inode_dirty() got stuck
waiting for journal commit which is stuck waiting for other user to do
journal_stop which waits for the page lock). Actually, there is no real
need to call mark_inode_dirty() from under page lock - we just need to
update i_size there. Something like the patch attached (untested)?

<snip>
> The full dmesg log is at 
> http://www.radian.org/~kvaneesh/ext4/delalloc-lockinversion/dmesg-1.log
> 
> Also starting journal in writepages make unmount throw lockdep errors.
> 
> unlink does journal_start and lock_super.
> umount does lock_super and later it need to sync_inodes does writepages
> which does a journal_start.
  Well, but isn't there this problem even without the lock inversion patch?
This is inversion between lock_super and journal_start. It hasn't been
changed by the lock inversion patch as far as I can tell. If you send me
lockdep traces I can have a look what we could do...

> I guess we will have to rework the delalloc related changes.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--BXVAT5kNtrzKuDFl
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="vfs-2.6.25-generic_write_end.diff"

commit 0553a5f120aeab4365c541d053482eb39e8c2d1a
Author: Jan Kara <jack@suse.cz>
Date:   Wed May 28 11:13:41 2008 +0200

    vfs: Move mark_inode_dirty() from under page lock in generic_write_end()
    
    There's no need to call mark_inode_dirty() under page lock in
    generic_write_end(). It unnecessarily makes hold time of page lock longer
    and more importantly it forces locking order of page lock and transaction
    start for journaling filesystems.
    
    Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/buffer.c b/fs/buffer.c
index 177f2ac..2f86ca5 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2062,6 +2062,7 @@ int generic_write_end(struct file *file, struct address_space *mapping,
 			struct page *page, void *fsdata)
 {
 	struct inode *inode = mapping->host;
+	int i_size_changed = 0;
 
 	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
 
@@ -2074,12 +2075,21 @@ int generic_write_end(struct file *file, struct address_space *mapping,
 	 */
 	if (pos+copied > inode->i_size) {
 		i_size_write(inode, pos+copied);
-		mark_inode_dirty(inode);
+		i_size_changed = 1;
 	}
 
 	unlock_page(page);
 	page_cache_release(page);
 
+	/*
+	 * We don't mark inode dirty under page lock. First, it unnecessarily
+	 * makes the holding time of page lock longer. Second, it forces lock
+	 * ordering of page lock and transaction start for journaling
+	 * filesystems.
+	 */
+	if (i_size_changed)
+		mark_inode_dirty(inode);
+
 	return copied;
 }
 EXPORT_SYMBOL(generic_write_end);

--BXVAT5kNtrzKuDFl--
