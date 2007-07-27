From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] e2fsprogs: Support for large inode migration.
Date: Fri, 27 Jul 2007 08:29:31 +0530
Message-ID: <46A95F93.3020001@linux.vnet.ibm.com>
References: <bee58d48110eee4d5cd133167245b99644148d96.1185341470.git.aneesh.kumar@linux.vnet.ibm.com> <3ae4c55b831a13f9fbb9a187efcd65d29434bf09.1185341470.git.aneesh.kumar@linux.vnet.ibm.com> <20070725143209.GA23613@thunk.org> <46A8895A.5000308@linux.vnet.ibm.com> <20070726161325.GB12895@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:57486 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbXG0C7j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Jul 2007 22:59:39 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.18.232])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l6R3N7O2234594
	for <linux-ext4@vger.kernel.org>; Fri, 27 Jul 2007 13:23:09 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6R2wtxe208396
	for <linux-ext4@vger.kernel.org>; Fri, 27 Jul 2007 12:58:55 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6R2xYQF001265
	for <linux-ext4@vger.kernel.org>; Fri, 27 Jul 2007 12:59:35 +1000
In-Reply-To: <20070726161325.GB12895@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Theodore Tso wrote:
> On Thu, Jul 26, 2007 at 05:15:30PM +0530, Aneesh Kumar K.V wrote:
>>> Let me guess, you're testing with a filesystem with two block groups,
>>> right?  And to date you've tested *only* by doubling the size of the
>>> inode.
>> I tested this with multiple ( 1 and 7 ) groups. But yes all the
>> testing was to change inode size from 128 to 256.
> 
> Your patch comments stated "As a part of increasing the inode size we
> throw away the free inodes in the last block group."  This is *only*
> true if the filesystem has two (and exactly two) block groups.  Hence
> my guess that only tested on filesystems with two block groups.
> 

Okey i didn't stress the "last" part in the above sentence. What i wanted
to convey was inodes in the block groups towards the end (well more than one).



> If you tested with larger numbers of block groups, the filesystem must
> have been mostly empty, or at least not a large number of directories,
> or else you would have noticed that most of the time that your
> algorithm wouldn't work.
> 
>> I guess Undo I/O manager can go in because I have been using it for
>> the ext3 -> ext4 inode migration testing and for testing the above patch.
> 
> Well, I really want a valid use case for undo code, and right now the
> above patch is IMHO not suitable for merging into mainline, given all
> of the problems that it has.
> 

What are the issues you see with PATCH 1 and PATCH 2 which implement 
Undo I/O Manager and undoe2fs other than it is not hooked into any of
the existing tools. I will try to add it to mke2fs as you suggested. But
should that prevent it from going in ?


-aneesh
