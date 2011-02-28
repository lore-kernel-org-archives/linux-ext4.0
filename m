From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] mksparse: build sparse file from compressed
 e2image file.
Date: Mon, 28 Feb 2011 13:26:04 -0500
Message-ID: <20110228182604.GC28617@thunk.org>
References: <1298860514-615-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43307 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab1B1S0H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Feb 2011 13:26:07 -0500
Content-Disposition: inline
In-Reply-To: <1298860514-615-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 28, 2011 at 10:35:13AM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> [Purpose]
> After we make a image-file by e2image like:
> #e2image -r /dev/hda1 - | bzip2 > hda1.bz2
> we copy the bz2 file to remote host and extract it:
> #bunzip2 hda1.bz2 
> the unzipped hda1 file will not be a sparse file and the space occupied
> by it is as large as the real /dev/hda1 filesystem.
> 
> Therefore a tool to transform a raw-file to a sparse-file is necessary.
> This Patch is a first attempt to provide such a tool which is called
> 'mksparse' so far.

I guess you didn't find /usr/src/e2fsprogs/contrib/make-sparse.c file
that I had written a while back.  I never did write a man page or
usage manual, or the rest of the niceties that go into a supported
program, but it's there.  :-)

I've never been completely convinced this was functionality was one
that should be included in the e2fsprogs as a supported program and
shipped with distributions.  It is useful, though, and I've certainly
used make-sparse.c many times in the past, so I'm willing to be
convinced otherwise.

						- Ted
