From: Jan Kara <jack@suse.cz>
Subject: [PATCH] Make wordwrap.pl work with perl 5.12.1
Date: Thu, 19 Jan 2012 21:19:43 +0100
Message-ID: <1327004383-6959-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60933 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690Ab2ASUTq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jan 2012 15:19:46 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For some reason wordwrap.pl doesn't work with my perl as split doesn't store
its result in $@ by default. Providing array to store output of split fixes it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 wordwrap.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/wordwrap.pl b/wordwrap.pl
index 646bbc3..a7a6651 100644
--- a/wordwrap.pl
+++ b/wordwrap.pl
@@ -9,8 +9,8 @@ while (<>) {
     }
     next if (/^$/);	# skip blank lines
     $linelen = 0;
-    split;
-    while (defined($word = shift @_)) {
+    @broken = split;
+    while (defined($word = shift @broken)) {
 	$word =~ s#\$\(srcdir\)/\.\./version.h#\$\(top_srcdir\)/version.h#;
 	$word =~ s#\$\(srcdir\)/.\.\/\.\./version.h#\$\(top_srcdir\)/version.h#;
 	$word =~ s#\$\(srcdir\)/.\.\/et/com_err.h#\$\(top_srcdir\)/lib/et/com_err.h#;
-- 
1.7.1

