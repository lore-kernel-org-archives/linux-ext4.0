From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH 0/3] jbd: jbd versions of queued jbd2 patches
Date: Sat,  3 May 2008 17:47:12 +0100
Message-ID: <1209833235-30521-1-git-send-email-duaneg@dghda.com>
Cc: Eric Sandeen <sandeen@redhat.com>, cmm@us.ibm.com, sct@redhat.com,
	linux-ext4@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:4038 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757094AbYECQx7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 May 2008 12:53:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

These are jbd versions of the following patches in the ext4 queue:

patches/jbd2-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
patches/jbd2-tidy-up-revoke-cache-initialization-and-destruction.patch
patches/jbd2-replace-potentially-false-assertion-with-if-block.patch

Patches are against v2.6.25-rc8-mm2.
