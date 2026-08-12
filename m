Received: from out203-205-221-202.mail.qq.com (out203-205-221-202.mail.qq.com [203.205.221.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980D0430CE1
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2026 11:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786533514; cv=none; b=DlN0Cq3rkcDkW/HIDvtpvGO8ivVhFOqwTTGE1g90bEZ0kTlbLCXpPtogQKvG23VFgSJCJoR6wYLIFKTvPFNpMd8HKSpxU56iARig3AH4ALxOsflZaeGZZuVLfwj2kGakcOBIxZHA+ez4uWYNtbSk74a67AubVRycdyx6C8EiTas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786533514; c=relaxed/simple;
	bh=Cr4ejiH4ji1x8hHhFjyfk0+Hr5mIBgFoIg7S15lZ8sk=;
	h=Message-ID:Date:From:To:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IllGZX98LGIUm9adLucyLVrIO4AmRyzEyVH0E8VkbS8Ltiak8bvm99n3Vh68Yj2sRDXYTBHhzf787/LavRoAokP6yojKHlH0llkowv4+IMt9aYYB2UQKJRt0KV1qikI1ZCBiFo6t2WO4TjcQyuE+r/I1zJSx3RtbWOV3CWP3U0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=wmvuTFGT; arc=none smtp.client-ip=203.205.221.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="wmvuTFGT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786533502; bh=RW3rsbRg/EvlYrmJPaJEkOeufQlAZT00FBVPuMaeJmo=;
	h=Date:From:To:Subject:References:In-Reply-To;
	b=wmvuTFGTvAkbcCRh0wgdpm9Fd0ARf88aGKirxCaBjZu29n1Oc9UzHFQj/H+xp4Cz5
	 YcPWHI33btxRuEl6BjomjRBPmIU/SQzNqLPzAKFtexi7NcFJ35H+PE2iDkhOzC+2yJ
	 OozKjsviJIXU9Dj/C57iaHF41hkcmL8UQI3C0Yes=
Received: from DESKTOP-AT5F202.localdomain ([183.242.132.32])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 44A9B647; Wed, 12 Aug 2026 19:17:10 +0800
X-QQ-mid: xmsmtpt1786533430t36xh5zqe
Message-ID: <tencent_5E70D721FD1077C689D59A12B297AB46B207@qq.com>
X-QQ-XMAILINFO: Ncyz9M6n7cjdnHEG8WS9WEJ46z+SgiE2Tx4WuqWpkhNpTK4eOJChMQd4xTz5vg
	 lRw7DjnI4h7BfJlmo2X4IVBFYIMuIN63Zakg2VV4MdBb19KJa7vw8MPWvP2WwJNkG3UNiJ1oqq66
	 nn6eekIVofSQDDON0U3EosumZFh1gxmRrjUZC6qkJiKAuKpbZFKcvWP7ZGXSXc/AyAqNfIN7FRat
	 damQJUrJ43QI4Wp01P5g7sECcvfwS+4EG0uwItHDTo4m4ciFhHvtMjFbxZr5NRYkPxBFNgiPFQhL
	 aPeaYzVql/z8PW9dT7GIWotzJAVqP9le/2nkgNjctB0jOrQl5nA5jbgeWw8xpxb/VKzWvddi/tBR
	 DI8JXA2WYgNE5/Dlh6dDJW4b7ScoLVNCt+GHm2CJ3hWgzugdDjEkJXhXq6YYXxZXS/sQi20TcD0f
	 gc6OrIZ3mUB+WvNlW9AFQ/2T8kgGyRGHY5hFVs+Z5zLxs+JXqvzjwRJsoJYR3jMxdkqWUEnjcIJY
	 YK7esdVcL4WaaLeqaO3N1boNb13XC3ZyCZikj6c78EICONCOP5DbhdQNEWGeYWIk6pMyZ6LAv3Jz
	 jWVSv58xZb1Y4jkZYzVbh7phT71KQTdZwfyTGhN2kNHmWANlRlIRjyRDgCNX949jGs/CezhZit3H
	 bJH+uTwVNORUfSw9yO+BjitPNlmVAEVJx05znvcCZx00VFEubWr3KgSSOkwzZGKcWlnwf/kQNeW2
	 cRLnDMIq3DAeojjlrgUzJ0REs+lQLrEU+vcWzGDT/hJlfw8lXaAD/J5/76DTDnm/qN3Auv+r7KRr
	 5dp6YjIC8B/LVy4XNG4P7EC/8hqVb3aZhjwBotBEccDpixT+0ys12US6oFUNXIH3W7SjVBP5NPlw
	 O3JUVHMztkRsXd7wwsdM7V/X8ejZc4l0ZplXvtTF/gs/6+INzu1gp/E01YBQ3yOsMgDlM79CBLhE
	 OtIrnToka2CL2vAQfzB8gmIB5WcfCiP0qCWEkU8t4O1n2zprmIKvZg4mjoksUCEMTwjy+aZAn58l
	 YM+13Qz2UnwgOE+nLQhwiqls32apY1LLwKYxTPSRR9KtZJ+U9myKAi8lw0eQguVWNvwDOO4gq4Ip
	 k5DtuyItpYSCqthbM9Tot6CXwCGSRR4/30cLBU1mqo2N6vE3U=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
Date: Wed, 12 Aug 2026 19:17:11 +0800
From: shuo chen <1289151713@qq.com>
To: ZW Tang <tangzw515@gmail.com>, linux-ext4@vger.kernel.org
Subject: Re: [BUG] ext4: possible circular locking dependency between
 xattr_sem and s_writepages_rwsem
X-OQ-MSGID: <anxWN8QMyEO-r5Y9@DESKTOP-AT5F202.localdomain>
References: <CAA2SOT5a_Lo4E7nWNoWk9Re5dx-vYDmQpCi_8cJjVps7DDL-rQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA2SOT5a_Lo4E7nWNoWk9Re5dx-vYDmQpCi_8cJjVps7DDL-rQ@mail.gmail.com>

On Tue, Aug 11, 2026 at 11:55:35AM +0800, ZW Tang wrote:
> Hi,
> 
> I am reporting a possible circular locking dependency triggered by a
> syzkaller reproducer on Linux 7.2-rc3.
> 
> The warning is reported by lockdep in the ext4 writeback / xattr path.
> The task is mounting a crafted ext4 image and enters orphan cleanup
> during ext4_fill_super(). During inode eviction, ext4_evict_inode()
> calls __ext4_mark_inode_dirty(), which holds &ei->xattr_sem. The same
> path then reaches ext4_xattr_block_set(), iput(), write_inode_now(),
> writeback_single_inode(), do_writepages(), and finally
> ext4_writepages(), where it tries to acquire &sbi->s_writepages_rwsem.
> 
> Lockdep reports that this creates a circular dependency, because
> another dependency chain already exists in the reverse order:
> ext4_writepages() / ext4_do_writepages() can acquire
> &sbi->s_writepages_rwsem first and later acquire &ei->xattr_sem
> through ext4_destroy_inline_data().
> 
> This looks like a potential ext4 lock-ordering issue between inode
> xattr expansion / inline-data handling and writeback during mount-time
> orphan cleanup, rather than a generic VFS or lockdep issue.
> 
> Reproducer:
> syz reproducer: https://pastebin.com/raw/FspxvagG
I can't open the reproducer URL. It returns a 404 error.
> console output: https://pastebin.com/raw/kQeWyFgs
> kernel config: https://pastebin.com/raw/XUJkfYA0
> 
> Kernel:
> kernel version: 7.2.0-rc3 #1 PREEMPT(full)
> HEAD commit: 1137d8b5df06137fb49513cc923b3b24d94cb809
> environment: QEMU Ubuntu 24.10
> taint: Not tainted
> 
> Relevant warning:
> 
> WARNING: possible circular locking dependency detected
> 7.2.0-rc3 #1 Not tainted
> 
> syz.4.27/12346 is trying to acquire lock:
> &sbi->s_writepages_rwsem, at: do_writepages+0x241/0x5b0
> 
> but task is already holding lock:
> &ei->xattr_sem, at: __ext4_mark_inode_dirty+0x5c6/0x860
> 
> Existing dependency chain:
> 
> -> #1 (&ei->xattr_sem):
> down_write
> ext4_destroy_inline_data
> ext4_do_writepages
> ext4_writepages
> do_writepages
> filemap_writeback
> file_write_and_wait_range
> mmb_fsync_noflush
> ext4_fsync_nojournal
> ext4_sync_file
> vfs_fsync_range
> ext4_buffered_write_iter
> ext4_file_write_iter
> vfs_write
> ksys_pwrite64
Why is there a task writing to a file before the mount is complete?
> 
> -> #0 (&sbi->s_writepages_rwsem):
> ext4_writepages
> do_writepages
> __writeback_single_inode
> writeback_single_inode
> write_inode_now
> iput
> ext4_xattr_block_set
> ext4_expand_extra_isize_ea
> __ext4_expand_extra_isize
> __ext4_mark_inode_dirty
> ext4_evict_inode
> evict
> iput
> ext4_orphan_cleanup
> ext4_fill_super
> get_tree_bdev_flags
> vfs_get_tree
> fc_mount
> path_mount
> do_mount
> __x64_sys_mount
> 
> Lockdep also reports the following possible unsafe locking scenario:
> 
> CPU0 CPU1
> 
> lock(&ei->xattr_sem);
> lock(&sbi->s_writepages_rwsem);
> lock(&ei->xattr_sem);
> rlock(&sbi->s_writepages_rwsem);
> 
> *** DEADLOCK ***
> 
> The reproducer mounts crafted ext4 images with options including
> grpid, auto_da_alloc, lazytime, dioread_nolock, init_itable,
> debug_want_extra_isize, bsdgroups, and min_batch_time, and then
> performs a pwrite64() before mounting another crafted ext4 image. The
> log also shows ext4 metadata errors before the warning, including
> invalid indirect mapped block, invalid block bitmap, delayed block
> allocation failures, and bad extra_isize, which appear to drive the
> mount/orphan-cleanup and xattr expansion paths.
> 
> Thanks

