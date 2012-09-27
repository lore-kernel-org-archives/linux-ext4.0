From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: fix potential deadlock in ext4_nonda_switch()
Date: Thu, 27 Sep 2012 22:16:15 +0400
Message-ID: <87fw63ib68.fsf@openvz.org>
References: <1348111390-23083-1-git-send-email-tytso@mit.edu> <505CE635.6060101@redhat.com> <20120921235912.GA27207@thunk.org> <87ipaziduh.fsf@openvz.org> <20120927180949.GA6862@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58221 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab2I0SQS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Sep 2012 14:16:18 -0400
In-Reply-To: <20120927180949.GA6862@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 27 Sep 2012 14:09:49 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Sep 27, 2012 at 09:18:30PM +0400, Dmitry Monakhov wrote:
> > Hmm... even this '!' patch is still not good. I've got that complain
> > WARNING: at fs/fs-writeback.c:1316 writeback_inodes_sb_nr+0x1a3/0x200()
> 
> This WARN_ON checking to make sure the s_umount mutex is grabbed.
> 
> What kernel are you applying this patch against?  Commit 14da92001:
I use b1725167c38ab current ext4.git/dev head.
> "fs: Protect write paths by sb_start_write - sb_end_write" adds a call
> to sb_start_write() in generic_file_aio_write() which means by the
> time we call ext4_nonda_switch(), s_umount is grabbed, which probably
> explains why I'm not seeing this --- 14da92001 was added to mainline
> as of 3.6-rc1, and I'm guessing you're using an older kernel?
> 

> This is something we need to consider, though, since "ext4: fix
> potential deadlock in ext4_nonda_switch()" is currently marked for
> stable, but commit 14da92001 is not marked for stable.  So if this
> commit gets backported w/o 14da92001, stable kernel users will see
> this warning.
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
