From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: resize2fs: Should never happen: resize inode corrupt! - lost key
 inodes
Date: Thu, 13 Aug 2015 09:27:16 -0400
Message-ID: <20150813132716.GB26095@thunk.org>
References: <55CA3BDE.7020401@harvyl.se>
 <20150811224718.GD20658@thunk.org>
 <55CBC212.6000507@harvyl.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Johan Harvyl <johan@harvyl.se>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56751 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbbHMN1S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Aug 2015 09:27:18 -0400
Content-Disposition: inline
In-Reply-To: <55CBC212.6000507@harvyl.se>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 13, 2015 at 12:00:50AM +0200, Johan Harvyl wrote:

> >I'm not aware of any offline resize with 1.42.13, but it sounds like
> >you were originally using mke2fs and resize2fs 1.42.10, which did have
> >some bugs, and so the question is what sort of might it might have
> >left things.
> What kind of bugs are we talking about, mke2fs? resize2fs? e2fsck? Any
> specific commits of interest?

I suspect it was caused by a bug in resize2fs 1.42.10.  The problem is
that off-line resize2fs is much more powerful; it can handle moving
file system metadata blocks around, so it can grow file systems in
cases which aren't supported by online resize --- and it can shrink
file systems when online resize doesn't support any kind of file
system shrink.  As such, the code is a lot more complicated, whereas
the online resize code is much simpler, and ultimately, much more
robust.

> Can you think of why it would zero out the first thousands of
> inodes, like the root inode, lost+found and so on? I am thinking
> that would help me assess the potential damage to the files. Could I
> perhaps expect the same kind of zeroed out blocks at regular
> intervals all over the device?

I didn't realize that the first thousands of inodes had been zeroed;
either you didn't mention this earier or I had missed that from your
e-mail.  I suspect the resize inode before the resize was pretty
terribly corrupted, but in a way that e2fsck didn't complain.

I'll have to try to reproduce the problem based how you originally
created and grew the file system and see if I can somehow reproduce
the problem.  Obviously e2fsck and resize2fs should be changed to make
this operation much more robust.  If you can tell me the exact
original size (just under 16TB is probably good enough, but if you
know the exact starting size, that might be helpful), and then steps
by which the file system was grown, and which version of e2fsprogs was
installed at the time, that would be quite helpful.

Thanks,

						- Ted
