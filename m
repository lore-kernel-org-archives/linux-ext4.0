From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Please reserve INCOMPAT flags
Date: Sat, 5 Dec 2009 09:55:56 +0530
Message-ID: <20091205042556.GA7426@skywalker.linux.vnet.ibm.com>
References: <20090906092546.GU4197@webber.adilger.int>
 <853282DF-4A37-4677-9E4C-F7C26A00C890@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:47574 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669AbZLEE0B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Dec 2009 23:26:01 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.31.245])
	by e23smtp01.au.ibm.com (8.14.3/8.13.1) with ESMTP id nB54OQJo011035
	for <linux-ext4@vger.kernel.org>; Sat, 5 Dec 2009 15:24:26 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nB54Q6cc1237176
	for <linux-ext4@vger.kernel.org>; Sat, 5 Dec 2009 15:26:06 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nB54Q5aH001269
	for <linux-ext4@vger.kernel.org>; Sat, 5 Dec 2009 15:26:06 +1100
Content-Disposition: inline
In-Reply-To: <853282DF-4A37-4677-9E4C-F7C26A00C890@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 30, 2009 at 12:15:11PM -0700, Andreas Dilger wrote:
> On 2009-09-06, at 03:25, Andreas Dilger wrote:
> >in addition to the data-in-dirent INCOMPAT flag Rahul sent the patches
> >for last week, I would like to ensure that we also have the INCOMPAT
> >flag for large EA-in-inode flag reserved.  This patch is going into
> >testing at one of our large customers, and I want to make sure that
> >we don't accidentally get a conflicting INCOMPAT flag assignment.
> >
> >#define EXT4_FEATURE_INCOMPAT_EA_INODE	0x0400
> >#define EXT4_FEATURE_INCOMPAT_DIRDATA   0x1000
> >
> >#define EXT4_EA_INODE_FL	0x00200000 /* Inode uses large EA */
> 
> 
> Hi Ted,
> I noticed Aneesh proposing to use the 0x0400 INCOMPAT flag for the
> NFSv4 ACL support, but this conflicts with the large EA feature we
> had previously discussed.  We now have a couple of customers using
> the large EA feature at this point, and I wouldn't want to break
> their filesystem as a result of an avoidable conflict.
> 
> I'll attach patches for this, which will hopefully make it easier,
> and the patch tracking tool will keep this visible.
> 
> Aneesh, maybe you can use 0x0800 for the INCOMPAT_RICHACL?
> 
> 

I have updated richacl patches to use 0x0800.

-aneesh
