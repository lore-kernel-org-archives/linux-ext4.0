From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/6] ext4: cleanups and regression fixes for grow/shrink logic V2
Date: Fri, 21 Oct 2011 01:08:53 +0400
Message-ID: <1319144939-28801-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org, tytso@mit.edu,
	achender@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47056 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab1JTVIr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Oct 2011 17:08:47 -0400
Received: by bkbzt19 with SMTP id zt19so4002126bkb.19
        for <linux-ext4@vger.kernel.org>; Thu, 20 Oct 2011 14:08:46 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Changes from V1
 - patch queue prepared against ext4.git dcf2d804ed6ffe
 - add cleanup for ext_rm_leaf
                                                                                                 
LOG:                                                                                            
#Following two patches are mostly cleanup 
ext4-cleanup-ext4_ext_grow_indepth-code.patch
ext4-move-inode-indepth-shrink-logic-to-didicated-fu.patch
# Later patches are fixes for real issues.
ext4-Do-not-clear-EOFBLOCKS_FL-too-soon.patch
ext4-remove-messy-logic-from-ext4_ext_rm_leaf.patch
ext4-fix-punch_hole-extend-handler.patch
ext4-update-EOFBLOCKS-flag-on-fallocate-properly.patch
