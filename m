From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12551] end_request: I/O error, dev cciss/c0d0, sector 87435720
Date: Tue, 27 Jan 2009 06:52:35 -0800 (PST)
Message-ID: <20090127145235.2F279108040@picon.linux-foundation.org>
References: <bug-12551-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443AbZA0Owx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2009 09:52:53 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0REqZbN015227
	for <linux-ext4@vger.kernel.org>; Tue, 27 Jan 2009 06:52:36 -0800
In-Reply-To: <bug-12551-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12551





------- Comment #1 from ralf.hildebrandt@charite.de  2009-01-27 06:52 -------
[    5.928545] EXT4-fs: barriers enabled
[    5.937105] kjournald2 starting: pid 703, dev cciss!c0d0p8:8, commit
interval 5 seconds
[    5.946272] EXT4 FS on cciss!c0d0p8, internal journal on cciss!c0d0p8:8
[    5.946331] EXT4-fs: delayed allocation enabled
[    5.946392] EXT4-fs: file extents enabled
[    5.946592] EXT4-fs: mballoc enabled
[    5.946646] EXT4-fs: mounted filesystem cciss!c0d0p8 with ordered data mode
[    5.976729] EXT4-fs: barriers enabled
[    5.985294] kjournald2 starting: pid 704, dev cciss!c0d0p9:8, commit
interval 5 seconds
[    5.989773] EXT4 FS on cciss!c0d0p9, internal journal on cciss!c0d0p9:8
[    5.989833] EXT4-fs: delayed allocation enabled
[    5.989889] EXT4-fs: file extents enabled
[    5.990093] EXT4-fs: mballoc enabled
[    5.990148] EXT4-fs: mounted filesystem cciss!c0d0p9 with ordered data mode
[    6.011721] EXT4-fs: barriers enabled
[    6.012150] kjournald2 starting: pid 705, dev cciss!c0d0p10:8, commit
interval 5 seconds
[    6.020273] EXT4 FS on cciss!c0d0p10, internal journal on cciss!c0d0p10:8
[    6.020332] EXT4-fs: delayed allocation enabled
[    6.020387] EXT4-fs: file extents enabled
[    6.020604] EXT4-fs: mballoc enabled
[    6.020659] EXT4-fs: mounted filesystem cciss!c0d0p10 with ordered data mode


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
