From: Eric Sandeen <sandeen@redhat.com>
Subject: FYI: KDE reintroduces KDE_EXTRA_FSYNC
Date: Sat, 11 Apr 2009 21:42:43 -0500
Message-ID: <49E15523.1080401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51768 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbZDLCmp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Apr 2009 22:42:45 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n3C2gjaA010227
	for <linux-ext4@vger.kernel.org>; Sat, 11 Apr 2009 22:42:45 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3C2gkgr010760
	for <linux-ext4@vger.kernel.org>; Sat, 11 Apr 2009 22:42:46 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n3C2giS7002865
	for <linux-ext4@vger.kernel.org>; Sat, 11 Apr 2009 22:42:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Just FYI for the ext4 folks:

http://websvn.kde.org/branches/KDE/4.2/kdelibs/kdecore/io/ksavefile.cpp?r1=949036&r2=949054&pathrev=949054

---
re-introduce KDE_EXTRA_FSYNC for the poor XFS/Ext4/... users

setting this env variable to anything (before kde starts!) will avoid
getting those pesky 0-byte sized files after system crashes - at a
potentially non-trivial performance cost.

BUG: 187172
---

-Eric
