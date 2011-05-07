From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V2] filefrag: count 0 extents properly when verbose
Date: Sat, 7 May 2011 18:45:24 -0400
Message-ID: <20110507224524.GB6046@thunk.org>
References: <4CEC4C86.1030806@redhat.com>
 <4D9F3B71.2050808@redhat.com>
 <569EBA4C-A6BB-4E64-88B9-F2F946891B56@dilger.ca>
 <4DC2EA94.8040100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36043 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756233Ab1EGWp2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 May 2011 18:45:28 -0400
Content-Disposition: inline
In-Reply-To: <4DC2EA94.8040100@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 05, 2011 at 01:21:08PM -0500, Eric Sandeen wrote:
> # rm -f a; touch a; filefrag a
> /boot/a: 0 extents found
> 
> works properly, but
> 
> # rm -f a; touch a; filefrag -v a
> Filesystem type is: ef53
> Filesystem cylinder groups is approximately 61
> File size of a is 0 (0 blocks, blocksize 1024)
>  ext logical physical expected length flags
> a: 1 extent found
> 
> yields 1 extent when it should be 0.
> 
> Fix this up by special-casing no extents returned in verbose
> mode; skip printing the header for the columns too, since there
> are no columns to print.
> 
> Also, in nonverbose mode we can set fm_extent_count to 0
> so that FIEMAP will just query the extent count without gathering
> details; clarify this with a comment.
> 
> Addresses-redhat-bugzilla: 653234
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, 

applied to the maint branch (which will then get pulled to
master/next) of e2fsprogs.

					- Ted
