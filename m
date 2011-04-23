From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH RFC v1 0/5]Factor common code from convert and split unwritten.
Date: Sat, 23 Apr 2011 01:44:14 -0700
Message-ID: <1303548259-28311-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: achender@linux.vnet.ibm.com, cmm@us.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54962 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab1DWIrF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Apr 2011 04:47:05 -0400
Received: by pvg12 with SMTP id 12so602376pvg.19
        for <linux-ext4@vger.kernel.org>; Sat, 23 Apr 2011 01:47:05 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

v0->v1:
   fix a bug in ext4_ext_convert_to_initialized() reported by
   Allison <achender@linux.vnet.ibm.com>.

   optimize ext4_ext_convert_to_initialized().

-- factor common code
   These patches factor common code from ext4_ext_convert_to_initialized() and
   ext4_split_unwritten_extents() so that extent-move-on-write in snapshot and
   punch hole can be built on the common code.

-- optimization
   the 4th and the 5th patch optimize ext4_ext_convert_to_initialized() by
   zeroing out in memory.


[PATCH RFC v1 1/5] ext4:Add a function merging extent right and left.
[PATCH RFC v1 2/5] ext4:Add two functions splitting an extent.
[PATCH RFC v1 3/5] ext4:Reimplement convert and split_unwritten.
[PATCH RFC v1 4/5] ext4: Add a function ext4_ext_zeroout_mem().
[PATCH RFC v1 5/5] ext4: optimize ext4_ext_convert_to_initialized().
