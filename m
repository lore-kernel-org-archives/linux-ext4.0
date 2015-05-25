From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH e2fsprogs] rename configure.in to configure.ac
Date: Mon, 25 May 2015 05:32:32 -0400
Message-ID: <1432546352-1855-1-git-send-email-vapier@gentoo.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:49103 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbbEYJcf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 May 2015 05:32:35 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id DE1B6340BDD
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2015 09:32:34 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Mike Frysinger <vapier@chromium.org>

Newer versions of autotools have started warning when using the old
configure.in name.

Signed-off-by: Mike Frysinger <vapier@chromium.org>
---
 configure.in => configure.ac | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename configure.in => configure.ac (100%)

diff --git a/configure.in b/configure.ac
similarity index 100%
rename from configure.in
rename to configure.ac
-- 
2.4.1

