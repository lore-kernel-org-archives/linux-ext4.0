From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: [PATCH, e2fsprogs] libext2fs: Add ext2fs_block_iterate3() which has 64-bit support
Date: Fri, 10 Oct 2008 18:02:49 -0400
Message-ID: <20081010220249.GA28360@shell>
References: <E1KoOpr-0003FT-2f@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759655AbYJJWCw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Oct 2008 18:02:52 -0400
Content-Disposition: inline
In-Reply-To: <E1KoOpr-0003FT-2f@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 10, 2008 at 04:43:43PM -0400, Theodore Ts'o wrote:
> 
> There was discussion about how to do 64-bit ABI conversation, and an
> assertion that it might be hard to do ext2fs_block_iterate3.  So I
> decided give an example of how I believe the most efficient way to do
> this sort of thing.

I'm afraid there's been a misunderstanding; I wasn't saying it was
hard, just pointing out that different versions of interfaces are
profilerating as a result of continuing to support the old ABI at the
same time as the new 64-bit ABI - perhaps more versions of more
functions than was originally anticipated. (I wrote a similar patch
and I agree it's not hard, just more cruft to maintain.)

Eagerly awaiting ext2fs_block_iterate4,

-VAL
