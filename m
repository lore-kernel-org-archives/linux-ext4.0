From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: e2fsprogs patches
Date: Wed,  1 Aug 2007 21:04:07 +0530
Message-ID: <11859824513552-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:44938 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbXHAPeX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2007 11:34:23 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l71Fb7X9343102
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 01:37:07 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.250.243])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l71FbpKb205108
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 01:37:51 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l71FYIAJ011362
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 01:34:18 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I have updated the patches to take care of comments posted by Andreas.
I also reworked the undoe2fs to use io_channel rather than open coding
open/write.

Regarding the naming of tdb file i decided to go with
mke2fs-<device_name> instead of mke2fs-<device_name>-<time-stamp>.
I guess having multiple version of this file in the tdb_dir will confuse
the user.

-aneesh
