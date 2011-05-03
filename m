From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Factor common code from convert and split-unwritten.
Date: Mon,  2 May 2011 19:04:58 -0700
Message-ID: <1304388301-9452-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu, achender@linux.vnet.ibm.com, cmm@us.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f170.google.com ([209.85.212.170]:55352 "EHLO
	mail-px0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab1ECCIz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 May 2011 22:08:55 -0400
Received: by pxi19 with SMTP id 19so2589779pxi.1
        for <linux-ext4@vger.kernel.org>; Mon, 02 May 2011 19:08:54 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

v1->v2:
   Remove optimization in v1.

v0->v1:
   Fix a bug in ext4_ext_convert_to_initialized() reported by
   Allison Henderson <achender@linux.vnet.ibm.com>

   optimize ext4_ext_convert_to_initialized().

The patch series factor common code from ext4_ext_convert_to_initialized()
and ext4_split_unwritten_extents() so that extent-move-on-write in snapshot
and punch-hole can be built on the common code.

[PATCH v2 1/3] ext4:Add a function merging extent right and left.
[PATCH v2 2/3] ext4:Add two functions splitting an extent.
[PATCH v2 3/3] ext4:Reimplement convert and split_unwritten.
