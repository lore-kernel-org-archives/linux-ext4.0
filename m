From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2 2/5] ext4: unlock group before ext4_error
Date: Sun, 23 Nov 2008 19:29:29 +0530
Message-ID: <20081123135929.GA16127@skywalker>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081123133704.GA26473@mit.edu> <20081123134304.GB26473@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:55571 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904AbYKWOA5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Nov 2008 09:00:57 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id mANE0tCT021031
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 01:00:55 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mANDxviE4243598
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 00:59:58 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mANDxdek010233
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 00:59:39 +1100
Content-Disposition: inline
In-Reply-To: <20081123134304.GB26473@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 23, 2008 at 08:43:04AM -0500, Theodore Tso wrote:
> On Sun, Nov 23, 2008 at 08:37:04AM -0500, Theodore Tso wrote:
> > This looks like it came from the patch
> > aneesh-8-fix-double-free-of-blocks which in a message sent roughly at
> > the same time you told me to drop from the patch queue.  So I'm adding
> > this to the patch queue without this rejected hunk.
> 
> Sorry, I managed to confuse myself.  The patch conflict went away
> after I removed the patch per your e-mail.  I have so many *.rej files
> in my tree from failed patches that I managed to confuse myself.  I'll
> have to clean them out....
> 
> My comments about how difficult it is to figure out where your patches
> apply are still relevant......  I'm still trying to figure this all
> out, but you'll need to check the patch queue afterwards.  Can you
> please give me a status readout about which patches I can move into
> the stable part of the tree, please?  And what the status is of the
> other patches?  Thanks!!!
> 

All the patches I do are mostly after applying all the patches in the
patch queue. I would wait for some review and wider testing
on the patches before they can be moved to stable part of the
patch queue.

-aneesh
