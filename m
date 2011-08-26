From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/5 v6] ext4: fix partial page writes
Date: Fri, 26 Aug 2011 11:47:13 -0400
Message-ID: <20110826154713.GB5176@thunk.org>
References: <1314212842-16741-1-git-send-email-achender@linux.vnet.ibm.com>
 <1314212842-16741-6-git-send-email-achender@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37652 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab1HZPrV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Aug 2011 11:47:21 -0400
Content-Disposition: inline
In-Reply-To: <1314212842-16741-6-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 24, 2011 at 12:07:22PM -0700, Allison Henderson wrote:
> While running extended fsx tests to verify the preceeding patches,
> a similar bug was also found in the write operation
> 
> When ever a write operation begins or ends in a hole,
> or extends EOF, the partial page contained in the hole
> or beyond EOF needs to be zeroed out.
> 
> To correct this the new ext4_discard_partial_page_buffers_no_lock
> routine is used to zero out the partial page, but only for buffer
> heads that are already unmapped.
> 
> Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>

I haven't had a chance to debug this yet, but FYI, with this patch
applied, xfstests #224 causes OOM's to result when running under KVM
with 1024megs.  I tried doubling the memory to 2048 megs, and it
passed in 4k standard ext4 mode, but then got hit with the OOM killer
on test #224 in ext3 emulation mode (nodealloc, and with extents not
enabled in the file system).  Without this patch, and the first four
patches in the v6 patch series applied, xfstests #224 passes in all of
the standard configurations (4k, ext3, 1k, data=journal, etc.)

I don't know why this is happening, but I'll try to dig into it in the
next day or two.  Any thoughts or fixes you might suggest would be
much appreciated.

						- Ted
