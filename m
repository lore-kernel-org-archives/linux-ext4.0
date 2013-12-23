From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] debugfs: silence build warning and remove incorrect error
 message
Date: Sun, 22 Dec 2013 21:30:35 -0500
Message-ID: <20131223023035.GA2396@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:37458 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712Ab3LWCak (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 22 Dec 2013 21:30:40 -0500
Received: by mail-qc0-f170.google.com with SMTP id x13so4422076qcv.15
        for <linux-ext4@vger.kernel.org>; Sun, 22 Dec 2013 18:30:39 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit fe56188b07 modified the code used to check the block number
argument to the command line -s switch, adding a call to com_err().
This causes a compile time warning because the third argument to
com_err() isn't a string.  Also, when the block number argument is
bad it outputs an incorrect error message - "Operation not permitted".

Fix these minor problems by removing the call to com_err().  Other
code provides enough error reporting information in this case.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 debugfs/debugfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 6982ff6..095741f 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2458,10 +2458,8 @@ int main(int argc, char **argv)
 			break;
 		case 's':
 			retval = strtoblk(argv[0], optarg, &superblock);
-			if (retval) {
-				com_err(argv[0], retval, 0, debug_prog_name);
+			if (retval)
 				return 1;
-			}
 			break;
 		case 'c':
 			catastrophic = 1;
-- 
1.8.3.2

