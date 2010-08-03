From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Any qualms about reverting 3d0518f4, ext4: New rec_len
 encoding for very large blocksizes ?
Date: Tue, 3 Aug 2010 19:12:19 -0400
Message-ID: <20100803231219.GH9453@thunk.org>
References: <4C58987B.2040602@redhat.com>
 <38BC6435-5556-422C-BFA3-A964F6C6E6B9@dilger.ca>
 <4C589CF2.9030406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Wei Yongjun <yjwei@cn.fujitsu.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48447 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756417Ab0HCXMU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Aug 2010 19:12:20 -0400
Content-Disposition: inline
In-Reply-To: <4C589CF2.9030406@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 03, 2010 at 05:49:22PM -0500, Eric Sandeen wrote:
> 
> As far as I know, reverting it won't break 64kb dir blocks...?

I seem to recall there was some confusion about what was the correct
way of recording a rec_len of 64k --- 0 or 65535.  So after reverting
the patch, we need to make sure we didn't end up breaking
compatibility with (a) existing file systems and (b) what older
versions of mke2fs may have generated.

> >> (this does 200 iterations) and got this for the file creations:
> >> 
> >> ext4 stock:   Average = 21206.8 files/s
> >> ext4 patched: Average = 22822.1 files/s
> >> 
> >> This is a 7.6% improvement...

Wow.  I assume that was because actually ending up burning enough CPU
time that it slowed bonnie's performance?  I'm not sure how how
realistic is a benchmark that is simply creating vast numbers of small
files in a tight loop, but certainly on non-Itanium systems where the
page size is nowhere near 64k, it's arguably pointless.  (Can you even
configure an Itanic to have to have a page size > 64k?)

So one way of dealing wih this is making it an inline, and then
#ifdef'ing out the more complex code if the page size is < 64k....

	       	   		     	    - Ted
