From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2 3/5] ext4: Fix the race between read_block_bitmap
	and mark_diskspace_used
Date: Mon, 24 Nov 2008 12:10:58 +0530
Message-ID: <20081124064058.GA11584@skywalker>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4926EE3C.7050207@redhat.com> <20081121173135.GF11212@skywalker> <20081123190224.GE26473@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:56914 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYKXGlE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Nov 2008 01:41:04 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id mAO6f1lY017355
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 12:11:01 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAO6eRSp3948726
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 12:10:27 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id mAO6f0r1005742
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 17:41:00 +1100
Content-Disposition: inline
In-Reply-To: <20081123190224.GE26473@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 23, 2008 at 02:02:24PM -0500, Theodore Tso wrote:
> On Fri, Nov 21, 2008 at 11:01:35PM +0530, Aneesh Kumar K.V wrote:
> > Same is true with inode bitmap also.
> > 
> 
> I don't see how this patch could affect any races with the inode
> bitmaps; the patch only affects mballoc.c, and only changes the
> locking around bitmaps.

The intent was to explain why we need
[PATCH -V2 5/5] ext4: Fix the race between read_inode_bitmap
and ext4_new_inode


> 
> This is one that I think we may want to send to Linus soon as a 2.6.28
> bugfix.
> 

Yes.

-aneesh
