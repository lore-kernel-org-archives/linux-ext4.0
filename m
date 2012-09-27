From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix potential deadlock in ext4_nonda_switch()
Date: Thu, 27 Sep 2012 14:09:49 -0400
Message-ID: <20120927180949.GA6862@thunk.org>
References: <1348111390-23083-1-git-send-email-tytso@mit.edu>
 <505CE635.6060101@redhat.com>
 <20120921235912.GA27207@thunk.org>
 <87ipaziduh.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52723 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab2I0SJy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Sep 2012 14:09:54 -0400
Content-Disposition: inline
In-Reply-To: <87ipaziduh.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 27, 2012 at 09:18:30PM +0400, Dmitry Monakhov wrote:
> Hmm... even this '!' patch is still not good. I've got that complain
> WARNING: at fs/fs-writeback.c:1316 writeback_inodes_sb_nr+0x1a3/0x200()

This WARN_ON checking to make sure the s_umount mutex is grabbed.

What kernel are you applying this patch against?  Commit 14da92001:
"fs: Protect write paths by sb_start_write - sb_end_write" adds a call
to sb_start_write() in generic_file_aio_write() which means by the
time we call ext4_nonda_switch(), s_umount is grabbed, which probably
explains why I'm not seeing this --- 14da92001 was added to mainline
as of 3.6-rc1, and I'm guessing you're using an older kernel?

This is something we need to consider, though, since "ext4: fix
potential deadlock in ext4_nonda_switch()" is currently marked for
stable, but commit 14da92001 is not marked for stable.  So if this
commit gets backported w/o 14da92001, stable kernel users will see
this warning.

						- Ted
