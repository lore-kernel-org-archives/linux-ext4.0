From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: resize2fs unresponsive
Date: Sat, 27 Feb 2016 14:56:03 -0500
Message-ID: <20160227195603.GA24887@thunk.org>
References: <1531dc8e596.f715a7bd144008.4814276246115556854@slu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jakob Lagerstedt <jakob.lagerstedt@slu.se>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34440 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756710AbcB0T4J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 27 Feb 2016 14:56:09 -0500
Content-Disposition: inline
In-Reply-To: <1531dc8e596.f715a7bd144008.4814276246115556854@slu.se>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 26, 2016 at 02:33:38PM +0100, Jakob Lagerstedt wrote:
> Dear developers,
> 
> We started a resize2fs (version 1.42.9) on Ubuntu 14.04 against a unmounted raid. 
> 
> It has taken a long time and not much seems to be happening. We have
> not found any answers to these questions in the documentation and
> conflicting answers from forums.

So a couple of things.  resize2fs using a mounted raid is safer than
an unmounted filesystems.  There were bugs with older versions of
resize2fs that could cause corruption, specifically with doing
resize2fs for large file systems while unmounted.  So I strongly
recommend that you not try to do unmounted resize2fs except with the
very lastest version of e2fsprogs (1.42.13).

Unfortunately, killing an resize2fs while unmounted while _usually_
safe, *can* cause damage while it is relocating the inode table
blocks.  This normally wouldn't happen, since we reserve space to
avoid needing to do this, but without knowing how big the file system
was when it was originally created, and how big you are trying to
resize it to.  If you send it an interrupt signal (e.g., type
control-C) it will try to stop at a clean point.  But if you send it a
kill -9 or there is a power failure while it is relocating the inode
table, you can lose data.  (This is not a problem if you use resize2fs
while it is mounted, since when it is mounted it uses the journal to
make sure things stay consistent even if the sytem crashes.)

Given the balance of risks, it's probably better to interrupt it with
a control C, and then run e2fsck on the file system afterwards.

> Can the resize be restarted if we kill it?

No, it can't be restarted.

						- Ted
