From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC] ext4: add an io-tree to track block allocation
Date: Thu, 21 Jun 2012 17:46:49 +0800
Message-ID: <20120621094648.GA17503@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56322 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535Ab2FUJk7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2012 05:40:59 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This year at ext4 workshop a new idea that calls io-tree is proposed to
solve some problmes in ext4 [1].  I summarize the problems that are
needed to solve by io-tree in here:
1. reserve quota calculation in bigalloc
2. simplify puch hole implementation
3. simplify fiemap implementation
4. SEEK_DATA/HOLE implementation

Meanwhile with io-tree, some codes can be improved as following:
1. accelerate get_block functions
2. simplify uninitialized extent conversion
3. fine granularity locking (extent lock)

I make a plan to implement io-tree that can be divided into three-steps.
Now I describe it in detailed.

* Step 1
The following problems will be solved in this step:
1. reserve quota calculation in bigalloc
2. simplify puch hole implementation
3. simplify fiemap implementation
4. SEEK_DATA/HOLE implementation

Currently a patch set has been submitted to the mailing list by
Yongqiang and Allison, which called status extent tree, and it has
simplified fiemap implementation.  But it only works when delay
allocation is enabled.  I will pick up this work.  Now I have rebased
this patch set to 3.5-rc3, and renamed it to extent status tree as
Darrick advised.

Next I will try to solve the above problems and make it run in
nodelalloc mode.

* Step 2
To be improved:
1. accelerate get_block functions
2. simplify uninitialized extent conversion

For the above improvements, a status member will be added in extent
status tree to indicate the current status of this extent.  I think that
the status includes dealloc, allocated, uninit, and hole.  Then we can
let get_block functions to lookup extent status tree firstly to
accelerate get_block.  Meanwhile uninitialized extent conversion can be
modified to reduce lock contention of i_mutex.

* Step 3
To be done:
1. fine granularity locking (extent lock)

Now in ext4 it does some operations with i_mutex locking.  After adding
extent status tree, we can avoid to take this lock as much as possible.
It seems that a new member needs to be added to indicate the type of
locking.  We can take a range lock with shared or exclusive, and, when a
range is locked, it cannot be merged by other processes and other types
extent lock.

Dave Chinner said that maybe range lock can be used in xfs too.  So I
will try to implement a generic extent locking as much as possible after
step 3.

Please review this RFC, and any feedbacks are appreciated.  Thanks.

In addition, I remember that at ext4 workshop Ted mentions that a big
extent tree has been implemented to improve extent cache.  So we need to
consider whether need to merge big extent tree and io-tree or not after
both big extent tree and io-tree have been done.

1. http://www.spinics.net/lists/linux-ext4/msg31742.html

Regards,
Zheng
