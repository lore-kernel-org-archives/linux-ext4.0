From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47731] Null pointer dereference at strchr
Date: Fri, 21 Sep 2012 04:42:33 +0000 (UTC)
Message-ID: <20120921044233.122FC11FA29@bugzilla.kernel.org>
References: <bug-47731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34862 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab2IUEmg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Sep 2012 00:42:36 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A2B8020273
	for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 04:42:35 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id E2B4D2025C
	for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 04:42:33 +0000 (UTC)
In-Reply-To: <bug-47731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47731





--- Comment #4 from Brad Figg <brad.figg@canonical.com>  2012-09-21 04:42:32 ---
$ uname -a
Linux rizzo 3.5.0-15-generic #22~precise1-Ubuntu SMP Wed Sep 19 22:07:48 UTC
2012 i686 i686 i386 GNU/Linux



$ sudo parted /dev/sdb print
Model: SEAGATE ST3300657SS (scsi)
Disk /dev/sdb: 300GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name  Flags
 1      1049kB  21.0GB  21.0GB  ext4         p1
 2      21.0GB  41.9GB  21.0GB  ext4         p2
 3      41.9GB  62.9GB  21.0GB  ext4         p3
 4      62.9GB  83.9GB  21.0GB  ext4         p4
 5      83.9GB  84.4GB  523MB                p5
 6      84.4GB  84.9GB  523MB                p6


$ sudo TEST_DEV=/dev/sdb1 TEST_DIR=/mnt/xfstests_test_dir
SCRATCH_MNT=/mnt/xfstests_scratch_mnt SCRATCH_DEV=/dev/sdb2 ./check -g auto -x
dangerous

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
