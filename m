From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Don't claim block from group which has corrupt
	bitmap
Date: Mon, 11 Feb 2008 17:06:52 +0530
Message-ID: <20080211113652.GA3833@skywalker>
References: <1202729418-5582-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:51913 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752084AbYBKLg7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Feb 2008 06:36:59 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m1BBavAY020285
	for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2008 17:06:57 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1BBavdE815218
	for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2008 17:06:57 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id m1BBauXo023555
	for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2008 11:36:57 GMT
Content-Disposition: inline
In-Reply-To: <1202729418-5582-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 11, 2008 at 05:00:18PM +0530, Aneesh Kumar K.V wrote:
> In ext4_mb_complex_scan_group, if the extent length of the newly
> found extentet is greater than than the total free blocks counted
> in group info, break without claiming the block.
> 
> Document different ext4_error usage, explaining the state with which we
> continue if we mount with errors=continue
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/mballoc.c |   16 +++++++++++++++-
>  1 files changed, 15 insertions(+), 1 deletions(-)


This was actually part of the version 2 of the patch
ext4_avoid_panic_in_case_of_corrupted_bitmap.patch. But we missed it
in the last update. So sending it as a separate patch.


-aneesh
