From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151491] free space lossage on busy system with bigalloc enabled
 and 128KB cluster
Date: Sat, 06 Aug 2016 12:54:07 +0000
Message-ID: <bug-151491-13602-gZmorI6X7T@https.bugzilla.kernel.org/>
References: <bug-151491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46726 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbcHFUBL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 6 Aug 2016 16:01:11 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DFE0020634
	for <linux-ext4@vger.kernel.org>; Sat,  6 Aug 2016 12:54:08 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B214720631
	for <linux-ext4@vger.kernel.org>; Sat,  6 Aug 2016 12:54:07 +0000 (UTC)
In-Reply-To: <bug-151491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151491

--- Comment #1 from Matthew L. Martin <mlmartin@clearsky-data.com> ---
The fault is in linux 4.4.16. After running the populate script for a few hours
du and df disagree a great deal:

# df -h /mnt/hdd_sd[gh]; du -hs  /mnt/hdd_sd[gh]
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdg        5.5T  129G  5.3T   3% /mnt/hdd_sdg
/dev/sdh        5.5T   20G  5.4T   1% /mnt/hdd_sdh
20G    /mnt/hdd_sdg
20G    /mnt/hdd_sdh

# lsof | grep -e sdg -e sdh
jbd2/sdg- 32609           root  cwd       DIR              9,127      4096     
  192 /
jbd2/sdg- 32609           root  rtd       DIR              9,127      4096     
  192 /
jbd2/sdg- 32609           root  txt   unknown                                  
      /proc/32609/exe
jbd2/sdh- 32614           root  cwd       DIR              9,127      4096     
  192 /
jbd2/sdh- 32614           root  rtd       DIR              9,127      4096     
  192 /
jbd2/sdh- 32614           root  txt   unknown                                  
      /proc/32614/exe

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
