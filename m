From: "Ryan, Michael" <Michael.Ryan2@lenovoemc.com>
Subject: Please summarize state of ext4 resize >16TB
Date: Wed, 8 Jan 2014 12:14:17 -0700
Message-ID: <BBC8F4C34A7B5A4DB487459885025E7F018A0BAE0391@EXCLUSTER.iomegacorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.bemta7.messagelabs.com ([216.82.254.111]:5205 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861AbaAHTVT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jan 2014 14:21:19 -0500
Received: from mailhub1.iomegacorp.com (mailhub1.iomegacorp.com [147.178.68.19])
	by dmzmail2.iomega.com (Postfix) with ESMTP id ED036200D1
	for <linux-ext4@vger.kernel.org>; Wed,  8 Jan 2014 19:08:23 +0000 (UTC)
Received: from EXCAS01.iomegacorp.com (excas01.iomegacorp.com [147.178.90.117])
	by mailhub1.iomegacorp.com (Postfix) with ESMTP id 838093E0057
	for <linux-ext4@vger.kernel.org>; Wed,  8 Jan 2014 19:14:25 +0000 (UTC)
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've been searching for info on the ability to resize ext4 from <16TB to >16TB.  This was not supported in the past and I've received conflicting information as to if/when this is/will be supported.  I've also seen indications that on disk data structures must be changed for this resize to work.

Is this capability currently supported?  
If so, what kernel level (and resize2fs level) is necessary?  Are there restrictions as to options at mkfs time?
If not, is this planned for a future release?  Or is this just not possible or practical due to on disk structures and is likely to never be supported?

Thank you.
