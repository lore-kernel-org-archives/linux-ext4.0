From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] resize2fs: fix overhead calculation for meta_bg file
 systems
Date: Wed, 5 Sep 2012 01:38:15 -0400
Message-ID: <20120905053815.GB29950@thunk.org>
References: <20120903164525.GD5066@thunk.org>
 <1346690758-21072-1-git-send-email-tytso@mit.edu>
 <1346690758-21072-2-git-send-email-tytso@mit.edu>
 <CAGBYx2a8J1ZvWDjgv3snTCE59nqurF_sGYJ0pxSy2anXjzfBRg@mail.gmail.com>
 <20120904021412.GG5066@thunk.org>
 <504634D6.20608@iki.fi>
 <CAGBYx2ZRUdY1CFVnpqB-3LOr5Gs5Cs7UBv2SDxXW9Xqps_m6vQ@mail.gmail.com>
 <20120905045548.GA29950@thunk.org>
 <CAGBYx2YgL6h2-EfHKrWe7dMXjS2u7a=F39gCL3VeCjJKFDYq7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Anssi Hannula <anssi.hannula@iki.fi>,
	Kevin Liao <kevinlia@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48835 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab2IEFiW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Sep 2012 01:38:22 -0400
Content-Disposition: inline
In-Reply-To: <CAGBYx2YgL6h2-EfHKrWe7dMXjS2u7a=F39gCL3VeCjJKFDYq7A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

BTW, it looks like your 2/2 patch does not have a dependency on the
rest of the resize patches, and fixes a problem which exists today
with the flex_bg resizing.  So you'll see I moved it to the beginning
of the patch series, and added a "Cc: stable@vger.kernel.org", since
it's a patch that should be backported to older stable kernels.

This kind of applicability statement is helpful for me, since I don't
have to try to figure it out (and because I might get it wrong as I
try to figure out the reasoning behind a patch, and the priority of
the patch).  Things that are useful to include is whether it is fixing
a recent regression, or if it is fixing a bug that is in older
kernels, how long has the bug been present, so we know which older
kernels need the patch, and in particular, whether enterprise
distributions need to worry about backporting the patch.

And as I mentioned earlier, if it causes user data loss/corruption, or
causes the kernel to crash, please make a note of this in the commit
description, since that's also important information when trying to
decide if a patch needs priority handling or needs to be backported to
older stable kernels.

Thanks, regards,

					- Ted
