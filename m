From: Jan Kara <jack@suse.com>
Subject: [PATCH 1/4] _filter_fiemap: Avoid awk interval regexps
Date: Wed,  4 Nov 2015 17:31:35 +0100
Message-ID: <1446654698-23577-2-git-send-email-jack@suse.com>
References: <1446654698-23577-1-git-send-email-jack@suse.com>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965576AbbKDQbv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Nov 2015 11:31:51 -0500
In-Reply-To: <1446654698-23577-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Older versions of awk do not accept interval regexps by default. Avoid
them in _filter_fiemap to keep better compatibility since it's pretty
trivial.

Signed-off-by: Jan Kara <jack@suse.com>
---
 common/punch | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/punch b/common/punch
index e8770ab834a7..be193d67ee56 100644
--- a/common/punch
+++ b/common/punch
@@ -208,7 +208,7 @@ _filter_fiemap()
 			print $1, $2, $3;
 			next;
 		}
-		$5 ~ /0x[[:xdigit:]]*8[[:xdigit:]]{2}/ {
+		$5 ~ /0x[[:xdigit:]]*8[[:xdigit:]][[:xdigit:]]/ {
 			print $1, $2, "unwritten";
 			next;
 		}
-- 
2.1.4

