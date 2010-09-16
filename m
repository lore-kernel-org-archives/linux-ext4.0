From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 0/6 v4] Lazy itable initialization for Ext4
Date: Thu, 16 Sep 2010 14:47:25 +0200
Message-ID: <1284641251-24531-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, rwheeler@redhat.com, sandeen@redhat.com,
	adilger@dilger.ca, lczerner@redhat.com, snitzer@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab0IPMrk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Sep 2010 08:47:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

as Mike suggested I have rebased the patch #1 against Jens'
linux-2.6-block.git 'for-next' branch and changed sb_issue_zeroout()
to cope with the new blkdev_issue_zeroout(), and changed
sb_issue_zeroout() to the new syntax everywhere I am using it.
Also some typos gets fixed.

-Lukas


