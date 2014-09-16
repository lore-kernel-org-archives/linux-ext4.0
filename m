From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 84201] mount doesn't clear usrjquota / grpjqouta options
Date: Tue, 16 Sep 2014 12:18:17 +0000
Message-ID: <bug-84201-13602-KcYtaespPh@https.bugzilla.kernel.org/>
References: <bug-84201-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37532 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbaIPMSV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Sep 2014 08:18:21 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BE7DB20259
	for <linux-ext4@vger.kernel.org>; Tue, 16 Sep 2014 12:18:19 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 640D420121
	for <linux-ext4@vger.kernel.org>; Tue, 16 Sep 2014 12:18:17 +0000 (UTC)
In-Reply-To: <bug-84201-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=84201

--- Comment #7 from Robin <robinedgar@gmail.com> ---
Hi Jan, thanks. I'm using kernel:

3.2.0-4-amd64 #1 SMP Debian 3.2.46-1 x86_64

dmesg gave:

EXT4-fs (vda1): journaled quota format specified with no journaling enabled

which is strange because:

# tune2fs -l /dev/disk/by-uuid/2ceaad1e-7ca8-42f9-b657-ce689beba638 | grep -i
journal
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg
dir_nlink extra_isize
Journal inode:            8
Journal backup:           inode blocks

(and just to make sure)

# tune2fs -l /dev/vda1 | grep -i journal                        
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg
dir_nlink extra_isize
Journal inode:            8
Journal backup:           inode blocks

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
