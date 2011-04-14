From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH REC 0/3] ext4:Factor common code from convert and split
 unwritten.
Date: Thu, 14 Apr 2011 10:14:24 -0400
Message-ID: <20110414141424.GG3682@thunk.org>
References: <1302759651-21222-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com,
	cmm@us.ibm.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42411 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757200Ab1DNOO3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Apr 2011 10:14:29 -0400
Content-Disposition: inline
In-Reply-To: <1302759651-21222-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 13, 2011 at 10:40:48PM -0700, Yongqiang Yang wrote:
> These patches factor common code from ext4_ext_convert_to_initialized() and
> ext4_split_unwritten_extents(), so that extent-move-on-write in snapshot and
> punch-hole can be built on the common code as well.
> 
> ext4:Add a function merging extent right and left.
> ext4:Add two functions splitting an extent.
> ext4:Reimplement convert and split_unwritten.

Hi Yongqiang,

I'd like to hear back from Mingming and Allison about whether these
patches conflict with their punch patches, since my understanding was
they were planning on doing very similar things (and at least would be
working in the very similar parts of the code).

I agree that the extents code here could definitely use this cleanup,
and I'm really glad that you worked on this; thank you!  I just want
to make sure work you are doing is coordinated with the work that
Allison and Mingming are working on.

						- Ted
