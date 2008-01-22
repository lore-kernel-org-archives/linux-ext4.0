From: Mathieu Segaud <mathieu.segaud@regala.cx>
Subject: [RESENT] Fix previously extX_ioctl() patches
Date: Tue, 22 Jan 2008 14:09:33 +0100
Message-ID: <1201007375-27914-1-git-send-email-mathieu.segaud@regala.cx>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	sct@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bde.crans.org ([138.231.137.76]:47787 "EHLO bde.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbYAVNJk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jan 2008 08:09:40 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This two patches discards and replaces 2 previously sent patches
they convert ext3/4_ioctl()s to unlocked_ioctl's
