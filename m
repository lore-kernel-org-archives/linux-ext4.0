From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: high write latency bug in ext3 / jbd in 3.4
Date: Mon, 13 Jan 2014 16:16:10 -0500
Message-ID: <20140113211610.GE1214@kvack.org>
References: <20140113201320.GD1214@kvack.org> <99F82313-71DA-43E6-A071-05507183D481@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:46388 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbaAMVQN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jan 2014 16:16:13 -0500
Content-Disposition: inline
In-Reply-To: <99F82313-71DA-43E6-A071-05507183D481@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 13, 2014 at 02:01:08PM -0700, Andreas Dilger wrote:
> Not to be flippant, but is there any reason NOT to just mount the
> filesystem with ext4?  There are a large number of improvements in
> the ext4 code that don't require on-disk format changes (e.g. delayed
> allocation, multi-block allocation, etc) if there is a concern about
> being able to downgrade to an ext3-type mount in case of problems.

I'm leaning towards doing this.  The main reason for not doing so was 
primarily that a few of the tweaks that I had been made to ext3 would 
have to be ported to ext4.  Thankfully, I think we're still in an early 
enough stage of release that I should be able to do so.  The changes 
are pretty specific, mostly allocator tweaks to improve the on-disk 
layout for our specific use-case.

> There are further improvements in ext4 that can be used on upgraded
> ext3 filesystems if the feature bit is enabled (in particular extent
> mapped files).  However, extent mapped files are not accessible under
> ext3, so it makes sense to run with ext4 w/o any new features for a
> while until you are sure it is working for you.

I had hoped to use ext4, but the recommended fsck after changing the 
various feature bits is a non-starter during our upgrade process (a 22 
minute outage isn't acceptable).

> Using delalloc, mballoc, and extents can reduce application visible
> read, write, and unlink latency significantly, because the blocks are
> being allocated and freed in contiguous chunks after the file is
> written from userspace.
> 
> We've been discussing deleting the ext3 code in favour of ext4 for
> a while already, and newer Fedora and RHEL kernels are using the
> ext4 code to mount ext2- and ext3-formatted filesystems for a while
> already.

That is reassuring to hear.  I'll give it a try and see what happens.

		-ben

> Cheers, Andreas
> 
> 
> 
> 
> 



-- 
"Thought is the essence of where you are now."
