From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/4] ext3[34] barrier changes
Date: Fri, 16 May 2008 09:37:18 -0500
Message-ID: <1210948642-12171-1-git-send-email-sandeen@redhat.com>
To: sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760553AbYEPO4T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 May 2008 10:56:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


A collection of patches to make ext3 & 4 use barriers by
default, and to call blkdev_issue_flush on fsync if they
are enabled.
