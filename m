From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Thu, 03 Dec 2015 01:18:54 +0000
Message-ID: <bug-89511-13602-XkvQVgnPLL@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42601 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757872AbbLCBS7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Dec 2015 20:18:59 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DB9F9205DF
	for <linux-ext4@vger.kernel.org>; Thu,  3 Dec 2015 01:18:57 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id BF17520551
	for <linux-ext4@vger.kernel.org>; Thu,  3 Dec 2015 01:18:55 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

bradhaack@fastmail.us <bradhaack@fastmail.us> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bradhaack@fastmail.us

--- Comment #69 from bradhaack@fastmail.us <bradhaack@fastmail.us> ---
This bug affects me.   I'm trying the workaround shown here
https://bugzilla.kernel.org/show_bug.cgi?id=89511#c19

sudo echo 'temporary write through'
>/sys/block/sdb/device/scsi_disk/6\:0\:0\:0/cache_type 

and I'm getting an operation not permitted error no matter how I try it.  If I
run lsatter, I get
lsattr: Inappropriate ioctl for device While reading flags on cache_type

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
