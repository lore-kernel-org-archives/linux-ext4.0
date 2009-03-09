From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] fix header check in ext4_ext_search_right() for deep
	extent trees.
Date: Mon, 9 Mar 2009 21:31:35 +0530
Message-ID: <20090309160135.GA30654@skywalker>
References: <49B18CAB.5020605@redhat.com> <20090309113619.GH5578@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	David Dindorp <ddi@dubex.dk>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:35499 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZCIQBu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Mar 2009 12:01:50 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp08.au.ibm.com (8.13.1/8.13.1) with ESMTP id n29G1ljp025925
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2009 03:01:47 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n29G24Wg1118318
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2009 03:02:05 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n29G1kqa023736
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2009 03:01:47 +1100
Content-Disposition: inline
In-Reply-To: <20090309113619.GH5578@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 09, 2009 at 07:36:19AM -0400, Theodore Tso wrote:
> On Fri, Mar 06, 2009 at 02:50:51PM -0600, Eric Sandeen wrote:
> > This should resolve kernel.org bugzilla 12821
> > 
> > I've not actually crafted a workload to exercise this code; 
> > this is from inspection...
> 
> Hmm, so I've been trying to create a test case, but the test cases
> I've created (which e2fsck say are fine) aren't causing complaints by
> the kernel.
> 
> Please see:
> 
>        http://master.kernel.org/~tytso/deep-tree/
> 
> deep-tree.img.gz contains an extent tree of depth 3, and

With depth 3 we would have path->p_depth = 2 and with middle
index block would have eh->eh_depth = 1 and depth variable also
will be having value 1. (also path->p_depth - depth)


> deep-tree-2.img.gz contains an extent tree of depth 4....
> 

So what is the logical block number with which you trying to allocate
blocks in deep-tree-2.img.gz 

-aneesh
