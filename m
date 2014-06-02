From: Benno Schulenberg <bensberg@justemail.net>
Subject: [PATCH 1/4] po: describe more precisely the %B expansion
Date: Mon,  2 Jun 2014 21:48:41 +0200
Message-ID: <1401738524-11455-1-git-send-email-bensberg@justemail.net>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:56760 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752385AbaFBTx7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2014 15:53:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Benno Schulenberg <bensberg@justemail.net>
---
 po/at-expand.pl |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/po/at-expand.pl b/po/at-expand.pl
index d4427b5..bc1a744 100644
--- a/po/at-expand.pl
+++ b/po/at-expand.pl
@@ -21,10 +21,13 @@ my @translator_help = (
  "#. on.  A table of these expansions can be found below.  Note that\n",
  "#. %-expressions that begin with \"%D\" and \"%I\" are two-character\n",
  "#. expansions; so for example, \"%Iu\" expands to the inode's user id\n",
- "#. ownership field (inode->i_uid).\n",
+ "#. ownership field (inode->i_uid).  Also the \"%B\" expansion is special:\n",
+ "#. it can expand to either the string \"indirect block\" (possibly preceded\n",
+ "#. by the word \"double\" or \"triple\"), or the string \"block #\" immediately\n",
+ "#. followed by an integer indicating a block sequence number.\n",
  "#.  \n",
  "#.	%b	<blk>			block number\n",
- "#.	%B	<blkcount>		integer\n",
+ "#.	%B	\"indirect block\" | \"block #\"<blkcount>	string | string+integer\n",
  "#.	%c	<blk2>			block number\n",
  "#.	%Di	<dirent> -> ino		inode number\n",
  "#.	%Dn	<dirent> -> name	string\n",
-- 
1.7.0.4

