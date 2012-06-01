From: Ted Ts'o <tytso@mit.edu>
Subject: Re: GIT PULL] ext4 updates for 3.5
Date: Fri, 1 Jun 2012 13:53:19 -0400
Message-ID: <20120601175319.GB15778@thunk.org>
References: <E1SaTSI-0005UV-4B@tytso-glaptop.cam.corp.google.com>
 <4FC8F1A7.2060208@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47062 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757949Ab2FARxX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jun 2012 13:53:23 -0400
Content-Disposition: inline
In-Reply-To: <4FC8F1A7.2060208@teksavvy.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 01, 2012 at 12:45:27PM -0400, Mark Lord wrote:
> On 12-06-01 11:07 AM, Theodore Ts'o wrote:
> > Ext4 updates for 3.5
> > 
> > The major new feature added in this update is Darrick J. Wong's
> > metadata checksum feature, which adds crc32 checksums to ext4's
> > metadata fields.  There is also the usual set of cleanups and bug
> > fixes.
> 
> That sounds vaguely like an on-disk change that may have issues
> with systems that regularly switch between older and newer kernel versions.
> 
> Could you elaborate on it a bit more, thanks!
> 

It's an on-disk change, but it's gated by a superblock "feature flag".
So unless you actually activate the feature, you won't get it.  If you
do activate the feature, then you won't be able to switch between
older and newer kernel versions --- at least not and be able to mount
the file system read/write.  (We have different feature flags that
indicate whether or not the kernel is allowed to mount the file system
read/write, read/only, or not at all, if it doesn't know about a bit
in the COMPAT, COMPAT_RO, or INCOMPAT feature bitmak.)

The e2fsprogs support for this feature is currently only in the
(rewinding) proposed update branch, so it's not something that I
recommend people use just yet.  Even though it's been pretty well
tested, there are probably still some bugs we still need to shake out.

	      	  	   	      	      	    - Ted
