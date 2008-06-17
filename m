From: Mingming <cmm@us.ibm.com>
Subject: Re: Ordered data mode vs. writeback mode
Date: Tue, 17 Jun 2008 11:42:07 -0700
Message-ID: <1213728127.27507.62.camel@BVR-FS.beaverton.ibm.com>
References: <3.0.6.32.20080616225930.01b86a60@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:50766 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133AbYFQSlq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jun 2008 14:41:46 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5HIfiMM013477
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 14:41:44 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5HIfaLR117314
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 12:41:38 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5HIfZiN016771
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 12:41:35 -0600
In-Reply-To: <3.0.6.32.20080616225930.01b86a60@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Mon, 2008-06-16 at 22:59 +0000, Gary Hawco wrote:
> Noticed that the newest set of patches in ext4-patch-queue has ordered data
> mode as the default mode again. Tune2fs is now able to switch modes again.
> 
> What is the preferred mode for a home desktop system with ext4? Is
> writeback still the fastest, but ordered data has more data integrity?  And
> does delalloc only work when writeback is enabled?

The update patch queue has patch to support delalloc on new ordered
mode. There seems an issue, Aneesh is debugging it now.

>  And does the commit=XX
> seconds still only work with writeback mode, ala ext3, or is it a valid
> option with ordered data mode?
> 
Should work for both mode.


Mingming

