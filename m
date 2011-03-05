From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Use single thread to perform DIO unwritten
 convertion
Date: Sat, 5 Mar 2011 12:46:39 -0500
Message-ID: <20110305174639.GD11120@thunk.org>
References: <1299180594.2826.6.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <eric.whitney@hp.com>, Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42795 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab1CFANa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Mar 2011 19:13:30 -0500
Content-Disposition: inline
In-Reply-To: <1299180594.2826.6.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 03, 2011 at 11:29:54AM -0800, Mingming Cao wrote:
> While running ext4 testing on multiple core, we found there are per
> cpu ext4-dio-unwritten threads processing conversion from unwritten
> extents to written for IOs completed from async direct IO patch.
> Per filesystem is enough, we don't need per cpu threads to work on
> conversion.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>

Eric, would you be able to do a very quick sanity check on your
48-core machine?  I can definitely see how having a huge number of
threads per file system could be problematic, especially on a system
with 32 or 64 ext4 file systems.  I'm curious though if we'll end up
taking a performance hit on direct I/O workloads.

If I remember correctly we currently have large file create with DIO
turned off, right?  Would it be possible to do a large file create
with DIO enabled, and do a quick run both with and without this patch?

In the future it would also be interesting to see how we are doing
versus other file systems using a DIO workload.  This is a probably
another area where I suspect some lockstat and oprofile runs may give
us opportunities for further optimization.

       	     	  	  	      - Ted
