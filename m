From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 0/4][e2fsprogs] Enable FLEX_BG support
Date: Thu, 02 Aug 2007 23:00:41 -0500
Message-ID: <20070803040041.29456.31454.stgit@gara>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38527 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbXHCEDQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Aug 2007 00:03:16 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7343FM8030421
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 00:03:15 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l7343FeC538934
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 00:03:15 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7343E0s000431
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 00:03:15 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l73436DN000360
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 00:03:06 -0400
Received: from [127.0.1.1] (sig-9-65-28-26.mts.ibm.com [9.65.28.26])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l73433RT062350
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 23:03:04 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The following series of patches add support creating and checking
filesystems with the FLEX_BG feature.  This feature currently groups
meta-data from a series of groups at the beginning of a flex group in
order to improve performance during heavy meta-data operations.

Some light testing on meta-data filesystem and fsck times already show
some improvements.

This is still very experimental code I meant mostly as a prototype, but
comments are welcome.


-JRS
