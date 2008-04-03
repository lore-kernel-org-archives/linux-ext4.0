From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: 2.6.25-rc8-mm1 ext4 ?
Date: Thu, 03 Apr 2008 10:18:43 -0800
Message-ID: <1207246724.30407.55.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:55017 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760562AbYDCRSM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Apr 2008 13:18:12 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m33HGSUA010990
	for <linux-ext4@vger.kernel.org>; Thu, 3 Apr 2008 13:16:28 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m33HIBd0053860
	for <linux-ext4@vger.kernel.org>; Thu, 3 Apr 2008 11:18:11 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m33HIBG4018542
	for <linux-ext4@vger.kernel.org>; Thu, 3 Apr 2008 11:18:11 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andrew,

ext4 is marked BROKEN in rc8-mm1. Wondering why ?
Mingming is on vacation for a week. Is there anything
we can help with to fix it ?

Thanks,
Badari

config EXT4DEV_FS
        tristate "Ext4dev/ext4 extended fs support development
(EXPERIMENTAL)"
        depends on EXPERIMENTAL
        depends on BROKEN


