From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext2: Don't export ext2_mask_flags() to user space
Date: Thu, 22 Mar 2012 12:28:25 -0400
Message-ID: <20120322162825.GA4028@thunk.org>
References: <1332366608-2695-1-git-send-email-thierry.reding@avionic-design.de>
 <20120321222357.GB24330@quack.suse.cz>
 <20120321231651.GC32041@thunk.org>
 <20120322055354.GA3942@avionic-0098.mockup.avionic-design.de>
 <1332396053.3058.2.camel@koala>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	stable@vger.kernel.org
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36692 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab2CVQ2g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Mar 2012 12:28:36 -0400
Content-Disposition: inline
In-Reply-To: <1332396053.3058.2.camel@koala>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 22, 2012 at 08:00:41AM +0200, Artem Bityutskiy wrote:
> On Thu, 2012-03-22 at 06:53 +0100, Thierry Reding wrote:
> > What's the recommended fix for packages that cannot or will not use
> > libext2fs, like busybox? Copy the required parts into a private header
> > and use that instead?
> 
> The normal way is to just keep a private copy of the whole header file.
> Because the on-disk format stays compatible, those programs do not have
> to update the header very often - only rarely if they want to support
> some new feature.

Even if they're not iwlling to use libext2fs (for space reasons, I
would assume?  It can't be because of license compatibility issues
since they are both GPLv2), they could just simply grab the ext2_fs.h
from e2fsprogs.  That has all of the file system definitions for ext2,
ext3, and ext4.

Regards,

						- Ted
