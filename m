From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext4 errors while runing fsx (2.6.25)
Date: Wed, 23 Apr 2008 14:15:20 +0530
Message-ID: <20080423084520.GA21899@skywalker>
References: <1208823533.17986.48.camel@badari-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Badari Pulavarty <pbadari@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:41109 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbYDWIpo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 04:45:44 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id m3N8je9M028960
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 14:15:40 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3N8jZtm1171684
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 14:15:35 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m3N8jm8L017626
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 08:45:48 GMT
Content-Disposition: inline
In-Reply-To: <1208823533.17986.48.camel@badari-desktop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 21, 2008 at 05:18:53PM -0700, Badari Pulavarty wrote:
> Got these messages while running fsx on ext4.
> Known issue ?
> 
> Thanks,
> Badari
> 
> EXT4 FS on hda1, internal journal
> EXT4-fs: mounted filesystem with ordered data mode.
> EXT4-fs: file extents enabled
> EXT4-fs: mballoc enabled
> pa ffff8101cc8400b0: logic 8, phys. 9065, len 56
> EXT4-fs error (device hda1): ext4_mb_release_inode_pa: free 37, pa_free 38
> 
> pa ffff8101cc8556b0: logic 32, phys. 8935, len 32
> EXT4-fs error (device hda1): ext4_mb_release_inode_pa: free 21, pa_free 22
> 
> pa ffff8101cc85e8b0: logic 9, phys. 8971, len 55
> EXT4-fs error (device hda1): ext4_mb_release_inode_pa: free 43, pa_free 44
> 
> pa ffff81017d0f7330: logic 39, phys. 9131, len 25
> EXT4-fs error (device hda1): ext4_mb_release_inode_pa: free 20, pa_free 21
> 
> pa ffff8101bb1431b0: logic 18, phys. 33438, len 46
> EXT4-fs error (device hda1): ext4_mb_release_inode_pa: free 26, pa_free 27

One thing I observed is free and pa_free are all differing by 1. I
looked at the code and we seems to be counting right. Can I get access
to the machine where it happened ?. I would like to look at the bitmap.

-aneesh
