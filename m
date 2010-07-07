From: Lukas Czerner <lczerner@redhat.com>
Subject: Ext3: batched discard support
Date: Wed,  7 Jul 2010 15:18:45 +0200
Message-ID: <1278508727-29135-1-git-send-email-lczerner@redhat.com>
Cc: lczerner@redhat.com, jmoyer@redhat.com, rwheeler@redhat.com,
	eshishki@redhat.com, sandeen@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab0GGNSx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Jul 2010 09:18:53 -0400
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o67DIrtp021068
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 7 Jul 2010 09:18:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hello again,

I have composed a set of patches to add batched discard support for Ext3 file
system. Functionality is basically the same as in "batched discard support
for Ext4" (see http://www.spinics.net/lists/linux-ext4/msg19827.html ).

There are two patches:

[PATCH 1/2] Add discard/nodiscard mount option for ext3
 fs/ext3/super.c         |   14 +++++++++++++-
 include/linux/ext3_fs.h |    1 +
 2 files changed, 14 insertions(+), 1 deletions(-)

[PATCH 2/2] Add batched discard support for ext3
 fs/ext3/balloc.c        |  145 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext3/super.c         |    1 +
 include/linux/ext3_fs.h |    1 +
 3 files changed, 147 insertions(+), 0 deletions(-)

The first one adds mount option to specify whether or not the discard should
be performed (default is nodiscard), and the second one adds discard support
itself.

Note that you will need one more patch for this to work "Add ioctl FITRIM" see
(http://www.spinics.net/lists/linux-ext4/msg19828.html) which adds ioctl to
issue discard itself.

Regards.

-Lukas

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
