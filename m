From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH REC 0/3] ext4:Factor common code from convert and split unwritten.
Date: Wed, 13 Apr 2011 22:40:48 -0700
Message-ID: <1302759651-21222-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: achender@linux.vnet.ibm.com, cmm@us.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54504 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab1DNFml (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Apr 2011 01:42:41 -0400
Received: by iyb14 with SMTP id 14so1156431iyb.19
        for <linux-ext4@vger.kernel.org>; Wed, 13 Apr 2011 22:42:40 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

These patches factor common code from ext4_ext_convert_to_initialized() and
ext4_split_unwritten_extents(), so that extent-move-on-write in snapshot and
punch-hole can be built on the common code as well.

ext4:Add a function merging extent right and left.
ext4:Add two functions splitting an extent.
ext4:Reimplement convert and split_unwritten.

