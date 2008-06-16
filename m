From: Mingming <cmm@us.ibm.com>
Subject: Re:
Date: Mon, 16 Jun 2008 13:55:25 -0700
Message-ID: <1213649725.27507.46.camel@BVR-FS.beaverton.ibm.com>
References: <3.0.6.32.20080616124957.0249f778@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:56325 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbYFPUzD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jun 2008 16:55:03 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5GKoZL4014412
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 16:50:35 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5GKt26R168412
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 14:55:02 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5GKsvXb006124
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 14:55:01 -0600
In-Reply-To: <3.0.6.32.20080616124957.0249f778@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Mon, 2008-06-16 at 12:49 +0000, Gary Hawco wrote:
> Aneesh,
> 
> Thanks for the link.  The Gentoo & Slackware kernels booted fine once this
> patch was applied. (I had to patch the clean kernel source with this patch,
> then apply the ext4-patch-queue, telling it not to override your patch).
> 
> Can we get the ext4-patch-queue updated with this patch?
> 
Hi Gary,

I am not quite clear which kernel oops you saw, and what patch Aneesh
sent to you. I just updated the patch queue with Shen's updated
ext4-make-ext4_ext_find_extent-fills-ext_path-completely.patch , which
fixed a kernel oops issue introduced by the original patch. I assume
that's the one you are referring to... Otherwise, please let me know .

Mingming
> Thanks for your quick assistance,
> 
> Gary Hawco
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

