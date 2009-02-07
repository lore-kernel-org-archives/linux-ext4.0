From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] introduce range check for extent pblock references
Date: Sat, 7 Feb 2009 23:02:39 +0530
Message-ID: <20090207173239.GA25942@skywalker>
References: <498DAA9A.8030309@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:37639 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbZBGRdA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Feb 2009 12:33:00 -0500
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id n17HVMP8024485
	for <linux-ext4@vger.kernel.org>; Sun, 8 Feb 2009 04:31:22 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n17HXG5I368778
	for <linux-ext4@vger.kernel.org>; Sun, 8 Feb 2009 04:33:16 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n17HWwmi025877
	for <linux-ext4@vger.kernel.org>; Sun, 8 Feb 2009 04:32:58 +1100
Content-Disposition: inline
In-Reply-To: <498DAA9A.8030309@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 07, 2009 at 04:36:58PM +0100, Thiemo Nagel wrote:
> This time I have aimed to catch all cases in which an invalid physical  
> block might be used and implemented checks directly in ext_pblock() and  
> idx_pblock() following the assumption that most of the times one of  
> these functions is called a device access to that address will follow.  
> If you think this is too heavy, I could also split the check from the  
> pblock calculation, but in that case I could only guess at which of the  
> several accesses to *_pblock() in extents.c a check would be necessary  
> and where it wouldn't and there would be the possibility of missing  
> something.


Do we want to check for validity every time we look at the physical
block of the extent. I guess that would be bad performance wise. I guess
we should check only once when we read the extent from the disk. ??

-aneesh
