From: Mingming <cmm@us.ibm.com>
Subject: Re: Using delalloc with ordered data mode
Date: Wed, 18 Jun 2008 14:31:53 -0700
Message-ID: <1213824713.27507.83.camel@BVR-FS.beaverton.ibm.com>
References: <3.0.6.32.20080617200116.02418a50@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:52233 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbYFRVbW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Jun 2008 17:31:22 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5ILVLsx028111
	for <linux-ext4@vger.kernel.org>; Wed, 18 Jun 2008 17:31:21 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5ILVLOO142676
	for <linux-ext4@vger.kernel.org>; Wed, 18 Jun 2008 15:31:21 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5ILVKEh021335
	for <linux-ext4@vger.kernel.org>; Wed, 18 Jun 2008 15:31:21 -0600
In-Reply-To: <3.0.6.32.20080617200116.02418a50@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Tue, 2008-06-17 at 20:01 +0000, Gary Hawco wrote:
> I was reviewing your patches from 9 hours ago and was confused as to
> whether delalloc still needs writeback mode.  I see the
> enable-delalloc-by-default-patch that quickly followed the
> delalloc-ext4-writeback mode. Does this mean that data=writeback mode must
> be used, and if this condition is met, then delalloc is enabled, or is
> delalloc enabled even if ordered data mode? Any clarification on this would
> be most appreciated.
> 

Hi Gary, thanks for looking into this.  Currently, if you apply the
whole the patch queue patches, you should have a ext4 fs with delalloc
over ordered mode by default. Previously without the delayed allocation
support for ordered mode, the patch queue enabled delalloc over
writeback mode by default. 

To clarify, the delayed allocation patches in the series are:

# New delayed allocation patch
delalloc-vfs.patch
delalloc-ext4-writeback-mode.patch

#delalloc support for reverse locking
Add-range_cont-mode-for-writeback.patch
delalloc-ext4-reserve-locking-order-support.patch

#delalloc block reservation(ENOSPC) handling
percpucounter-add-sum-and-set-function.patch
delalloc-ext4-ENOSPC-handling.patch

#delalloc new ordered mode
delalloc-new-ordered-mode.patch

enable-delalloc-by-default.patch
show-delalloc-option.patch


So, with delalloc-ext4-writeback-mode.patch, it has delalloc support for
writeback mode, but you need to enable this feature clearly with mount
option -o delalloc, data=writeback,

With delalloc-new-ordered-mode.patch, it add delalloc support for
ordered mode (the new ordered mode, patches in the patch queue). If you
only apply to here, you need to enable delalloc on ordered mode by mount
-o delalloc, data=ordered

With the enable-delalloc-by-default.patch, it enables delalloc over new
ordered mode by default (no need to specifying delalloc and ordered
mount options), which exercise the new ordered code and also delayed
allocation both.

Mingming

