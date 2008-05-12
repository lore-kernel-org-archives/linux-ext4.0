From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH 0/3][v2] jbd: jbd versions of queued jbd2 patches
Date: Mon, 12 May 2008 17:57:38 +0100
Message-ID: <1210611461-8526-1-git-send-email-duaneg@dghda.com>
Cc: Eric Sandeen <sandeen@redhat.com>, cmm@us.ibm.com, sct@redhat.com,
	linux-ext4@vger.kernel.org, Duane Griffin <duaneg@dghda.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:1936 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbYELQ5p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2008 12:57:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

These are jbd versions of the following patches currently in the -stable queue:

patches/jbd2-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
patches/jbd2-tidy-up-revoke-cache-initialization-and-destruction.patch
patches/jbd2-replace-potentially-false-assertion-with-if-block.patch

Patches are against v2.6.25-rc8-mm2.

This second attempt fixes a stupid crash on boot bug in the previous one.
