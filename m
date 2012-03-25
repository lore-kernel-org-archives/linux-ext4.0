From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext2: No longer export ext2_fs.h to user space
Date: Sat, 24 Mar 2012 21:16:13 -0400
Message-ID: <20120325011613.GB32554@thunk.org>
References: <20120322183135.GC4028@thunk.org>
 <1332494856-31943-1-git-send-email-thierry.reding@avionic-design.de>
 <20120323131331.GA29631@thunk.org>
 <20120323175534.GI6589@ZenIV.linux.org.uk>
 <20120324215152.GA32554@thunk.org>
 <4F6E47C5.6040306@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Andreas Dilger <aedilger@gmail.com>, linux-ext4@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43822 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab2CYBQ0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Mar 2012 21:16:26 -0400
Content-Disposition: inline
In-Reply-To: <4F6E47C5.6040306@zytor.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 24, 2012 at 03:16:37PM -0700, H. Peter Anvin wrote:
> > Someone who was compiling "the latest version" of syslinux has
> > submitted a kernel bugzilla entry that this was breaking due to
> > ext2_fs.h using umode_t which was no longer being exported by the
> > kernel header files.  Given that ext2_fs.h is about to go ***poof***
> > (Al already has the changes in his vfs git tree), I thought I should
> > give you a heads up....
> > 
> 
> Thanks.  Syslinux already includes a private copy of ext2_fs.h, but I
> need to scrub the umode_t inclusion.

Ah, good.  I'll close the kernel bugzilla report in that case.

Thanks,

    	   	   	      	  	 - Ted

