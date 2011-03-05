From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Use sing thread to perform DIO unwritten
 convertion
Date: Sat, 5 Mar 2011 11:54:11 -0500
Message-ID: <20110305165411.GC11120@thunk.org>
References: <1299180594.2826.6.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42803 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab1CFANc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Mar 2011 19:13:32 -0500
Content-Disposition: inline
In-Reply-To: <1299180594.2826.6.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 03, 2011 at 11:29:54AM -0800, Mingming Cao wrote:
> While running ext4 testing on multiple core, we found there are per cpu ext4-dio-unwritten threads processing
> conversion from unwritten extents to written for IOs completed from async direct IO patch.
> Per filesystem is enough, we don't need per cpu threads to work on conversion.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>

Thanks, added to the ext4 patch queue.

						- Ted
