From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/7] ext4: cleanups and regression fixes for grow/shrink logic V3
Date: Fri, 28 Oct 2011 21:00:03 +0400
Message-ID: <1319821210-7374-1-git-send-email-dmonakhov@openvz.org>
Cc: achender@linux.vnet.ibm.com, tytso@mit.edu,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45611 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab1J1RAR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Oct 2011 13:00:17 -0400
Received: by bkbzt4 with SMTP id zt4so624020bkb.19
        for <linux-ext4@vger.kernel.org>; Fri, 28 Oct 2011 10:00:15 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

changes from v2 (in responce to comments from tytso@)
 - split punch_hole handler patch in to reviewable peaces.
 - redesign error path for ext4_ext_map_blocks

##First patch is a fix for real issue
 ext4: Restore old EOFBLOCKS flag state after error
##Code cleanup for shrink logic.
 ext4: move inode indepth shrink logic to didicated function
##The rest are punch hole logic fixes
 ext4: Move punch hole logic to didicated function
 ext4: punch_hole fix extent conversion
 ext4: Update inode's transaction id after punch_hole
 ext4: punch hole should be restarted after transaction restart
 ext4: update EOFBLOCK flags after punch hole
