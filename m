From: Jan Kara <jack@suse.cz>
Subject: Re: crash in __jbd2_journal_file_buffer
Date: Wed, 31 Jul 2013 21:02:45 +0200
Message-ID: <20130731190245.GC28018@quack.suse.cz>
References: <alpine.DEB.2.00.1307301540110.12830@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Sage Weil <sage@inktank.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab3GaTCs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Jul 2013 15:02:48 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1307301540110.12830@cobra.newdream.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Tue 30-07-13 15:41:40, Sage Weil wrote:
> Hit this on 3.10.  Is this a known issue?
  No, I haven't seen it. Why did the kernel crash?

								Honza
> 
> Thanks-
> sage
> 
> 
> Stack traceback for pid 23944
> 0xffff8802206edeb0    23944    23840  1    2   R  0xffff8802206ee338 
> *ceph-osd
>  ffff88020bf17b78 0000000000000018 ffffffff81267398 ffff8802256d40c0
>  ffff88020b5a1230 ffff88020bf17bb8 ffffffff81325d9c ffff88020b5a1230
>  ffff8802256d40c0 ffff88020b5a1230 00000000698a8d24 ffff88020bf17be8
> Call Trace:
>  [<ffffffff81267398>] ? __jbd2_journal_file_buffer+0x188/0x260
>  [<ffffffff81325d9c>] ? do_raw_spin_lock+0x10c/0x150
>  [<ffffffff81268118>] ? do_get_write_access+0x448/0x650
>  [<ffffffff81213caf>] ? ext4_read_inode_bitmap+0x9f/0x5f0
>  [<ffffffff81167849>] ? kmem_cache_alloc+0x39/0x160
>  [<ffffffff81268490>] ? jbd2_journal_get_write_access+0x30/0x50
>  [<ffffffff81244d43>] ? __ext4_journal_get_write_access+0x43/0x90
>  [<ffffffff812143d7>] ? ext4_free_inode+0x1d7/0x5d0
>  [<ffffffff8121e601>] ? ext4_evict_inode+0x341/0x4d0
>  [<ffffffff8121b268>] ? ext4_mark_inode_dirty+0x88/0x230
>  [<ffffffff8121e610>] ? ext4_evict_inode+0x350/0x4d0
>  [<ffffffff8118a098>] ? evict+0xb8/0x1c0
>  [<ffffffff8118a9d5>] ? iput+0x105/0x190
>  [<ffffffff8117d341>] ? do_unlinkat+0x201/0x270
>  [<ffffffff8131e9be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff81180356>] ? SyS_unlink+0x16/0x20
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
