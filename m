From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: [PATCH 0/2] Large EAs for ext4
Date: Tue, 18 Nov 2008 02:06:11 +0530
Message-ID: <1226954171.3972.69.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: TheodoreTso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	Andreas Dilger <adilger@Sun.COM>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-2.sun.com ([192.18.19.7]:36684 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbYKQUqA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Nov 2008 15:46:00 -0500
Received: from fe-apac-05.sun.com (fe-apac-05.sun.com [192.18.19.176] (may be forged))
	by sineb-mail-2.sun.com (8.13.6+Sun/8.12.9) with ESMTP id mAHKZPSp015644
	for <linux-ext4@vger.kernel.org>; Mon, 17 Nov 2008 20:35:26 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0KAH00H01VU6YJ00@mail-apac.sun.com>
 (original mail from Kalpak.Shah@Sun.COM) for linux-ext4@vger.kernel.org; Tue,
 18 Nov 2008 04:35:25 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

These are the updated patches for adding large EA support to ext4.
Changes suggested by Mingming and Andreas for earlier patches have been
incorporated in this version.

Large EAs with values greater than half the filesystem blocksize are
stored in an external inode.

Patch 1/2 - EA inodes are not connected to any directory and hence
ext4_new_inode() cannot make a decision about where to allocate the EA
inode. So we add a new goal argument to ext4_new_inode() so that the EA
inode can be allocated close to the parent inode.

Patch 2/2 - Adds actual support for large EAs.

Thanks,
Kalpak

