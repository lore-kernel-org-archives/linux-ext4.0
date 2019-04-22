Return-Path: <SRS0=f4LO=SY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C9CBC10F11
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 20:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3704220859
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 20:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555964956;
	bh=7MY/JfLthhCrmX86f45Xxe4p2QrJ7rV3gSADUA33hbU=;
	h=From:To:Subject:Date:List-ID:From;
	b=XmF+d16Koc9VzcSLgEaG3OD11gOCbw8V7KAiv0/fyrGufBtW3u3N90s7bTOHyyKAK
	 rFI+EmGUJ0vNJqQR8mkwMNgY8lFQ3Pt9f4Bor/My6Q9iGYrHS8Ssljfv+NIC5UIb/w
	 eFsq6rlH5hVck6UpMO8c296EofymTW+FVA64PPN8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfDVU3P (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 22 Apr 2019 16:29:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727190AbfDVU3P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 22 Apr 2019 16:29:15 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D49120859
        for <linux-ext4@vger.kernel.org>; Mon, 22 Apr 2019 20:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555964954;
        bh=7MY/JfLthhCrmX86f45Xxe4p2QrJ7rV3gSADUA33hbU=;
        h=From:To:Subject:Date:From;
        b=dWbqm1zqgBh0qUUPTW3YeqGhY7R5FU4chi+Ey0afZB4PoG95TXcgZTPvZ9dn5KgaL
         mI+1Mne1bsgwE9JKpQKp42VDkZEK/uNnT14roZGMeICTu3uWB15Kox15MY7wVTIARY
         FCRTPfGdeVW/ORg/RHWmDf8LPyH4Ajl7AQ5kYYZ0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Subject: [PATCH] debugfs: avoid ambiguity when printing filenames
Date:   Mon, 22 Apr 2019 13:27:15 -0700
Message-Id: <20190422202715.167750-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The way debugfs escapes filenames is ambiguous because a sequence like
M-A can mean either the byte 'A' + 128 == 0xc1 or the three bytes
{'M', '-', 'A'}.  Similarly, ^A can mean either the byte
'A' ^ 0x40 == 0x01 or the two bytes {'^', 'A'}.

Fix this and simplify the code by switching to a simpler strategy where
all bytes < 32, all bytes >= 127, and backslash are encoded with C-style
hex escape sequences.  E.g., the byte 0xc1 will now be encoded as \xc1
rather than M-A as it was before, while a filename consisting of the
three bytes {'M', '-', 'A'} will continue to be shown as M-A.

I want to fix this mainly because I want to use debugfs to retrieve raw
encrypted filenames for ciphertext verification tests.  But this doesn't
work if the returned filenames are ambiguous.

Fixes: 68a1de3df340 ("debugfs: pretty print encrypted filenames in the ls command")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 debugfs/ls.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/debugfs/ls.c b/debugfs/ls.c
index 41af15d2..4f63bd3f 100644
--- a/debugfs/ls.c
+++ b/debugfs/ls.c
@@ -62,21 +62,15 @@ static int print_filename(FILE *f, struct ext2_dir_entry *dirent, int options)
 	}
 	while (len--) {
 		ch = *cp++;
-		if (ch > 128) {
+		if (ch < 32 || ch >= 127 || ch == '\\') {
 			if (f)
-				fputs("M-", f);
-			ch -= 128;
-			retlen += 2;
-		}
-		if ((ch < 32) || (ch == 0x7f)) {
+				fprintf(f, "\\x%02x", ch);
+			retlen += 4;
+		} else {
 			if (f)
-				fputc('^', f);
-			ch ^= 0x40; /* ^@, ^A, ^B; ^? for DEL */
+				fputc(ch, f);
 			retlen++;
 		}
-		if (f)
-			fputc(ch, f);
-		retlen++;
 	}
 	return retlen;
 }
-- 
2.21.0.593.g511ec345e18-goog

