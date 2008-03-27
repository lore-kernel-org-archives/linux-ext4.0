From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: mballoc errors
Date: Thu, 27 Mar 2008 09:18:05 +0530
Message-ID: <20080327034805.GA7137@skywalker>
References: <47EAC302.5040109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:38394 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbYC0DsL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Mar 2008 23:48:11 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m2R3m7Tf029219
	for <linux-ext4@vger.kernel.org>; Thu, 27 Mar 2008 09:18:07 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2R3m6R61229040
	for <linux-ext4@vger.kernel.org>; Thu, 27 Mar 2008 09:18:06 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m2R3mDfC006813
	for <linux-ext4@vger.kernel.org>; Thu, 27 Mar 2008 03:48:13 GMT
Content-Disposition: inline
In-Reply-To: <47EAC302.5040109@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 26, 2008 at 04:41:22PM -0500, Eric Sandeen wrote:
> This report just came in on the fedora list...
> 
> EXT4-fs error (device dm-0): ext4_mb_generate_buddy: EXT4-fs: group 717:
> 23410 blocks in bitmap, 23411 in gd
> 
> EXT4-fs error (device dm-0): ext4_mb_generate_buddy: EXT4-fs: group 721:
> 19309 blocks in bitmap, 19333 in gd
> 
> has anyone else seen this problem in testing?  I guess it means
> freespace accounting got out of sync...?
> 

The bitmap or group desc is corrupt. The number of free blocks counted
via bitmap and found via desc->bg_free_blocks_count are not same. We
fall back to one calculated the bitmap.

-aneesh
