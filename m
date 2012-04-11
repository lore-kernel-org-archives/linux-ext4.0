From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tests: add test for symlink extent
Date: Wed, 11 Apr 2012 14:07:18 -0400
Message-ID: <20120411180718.GF12044@thunk.org>
References: <1334093657-32559-1-git-send-email-adilger@whamcloud.com>
 <20120411034547.GD12044@thunk.org>
 <1AA51704-1130-44B6-A891-203FDCDBF83D@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56832 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756753Ab2DKSHU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Apr 2012 14:07:20 -0400
Content-Disposition: inline
In-Reply-To: <1AA51704-1130-44B6-A891-203FDCDBF83D@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 10, 2012 at 11:06:50PM -0600, Andreas Dilger wrote:
> 
> My bad.  I had examined some symlinks on an ext4 filesystem to see
> if they had the EXT4_EXTENTS_FL set, but didn't think to check long
> symlinks, so I assumed this was an anachronism and rewrote the patch
> description while submitting it...  Originally it read:
> 
>     Long symlinks with the EXT4_EXTENTS_FL set should no longer be
>     considered as corrupt, since these are created by default with
>     new kernels using ext4 as the filesystem type.  This has not
>     impacted Lustre in the past because extents are only enabled on
>     the OST, while symlinks are only created on the MDT where extents
>     are never enabled.
>     
>     However, now that distros are using ext4 as the base filesystem
>     type, if the lustre-patched e2fsprogs RPM is installed it will
>     incorrectly consider all such long symlinks as bad and remove them.
> 
> We had previously hit problems with Lustre e2fsprogs because we
> originally flagged such symlinks as errors, and there was no
> existing test which had such a symlink.  The description clearly
> wasn't useful for upstream submission, but the test is still useful.

OK, I'll update the commit description and give it a try.  Note that
one of the reasons why we *have* to support extent-mapped long
symlinks is for file systems with > 32-bit block numbers....

	    	     	     	    	   	 - Ted
