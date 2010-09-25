From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Broken e2fsck i_blocks repair
Date: Sat, 25 Sep 2010 08:24:03 -0400
Message-ID: <20100925122403.GE9597@thunk.org>
References: <AANLkTinT3O20u-iE4Mu2ikSPa4bdhVsM+a82p6Hoeu8K@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33314 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395Ab0IYMYH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 25 Sep 2010 08:24:07 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTinT3O20u-iE4Mu2ikSPa4bdhVsM+a82p6Hoeu8K@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 01, 2010 at 04:01:22PM -0700, Justin Maggard wrote:
> I've mentioned this before on here, but I never verified whether or
> not it was actually broken.  I have done so today.  I manually
> modified the block count of a 3TB file using debugfs, then ran e2fsck
> on it.  e2fsck claimed to repair it, but would throw an error on every
> subsequent e2fsck run for the same issue.  The reason is
> inode->osd2.linux2.l_i_blocks_hi is always set to 0 if e2fsck is told
> to fix it.  This is an issue in both stable 1.41.12, and in master.
> This patch fixes it for me, but is there anything else that needs to
> get checked here?

Sorry for the delay; September has been rather busy for me.  This fix
has been checked in and pushed out to the e2fsprogs git repository.
I've taken a look and there doesn't seem to be any other places where
this mistake could have happened.

Thanks for pointing it out!

						- Ted
