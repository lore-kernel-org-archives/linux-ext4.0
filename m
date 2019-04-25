Return-Path: <SRS0=y8r3=S3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2594DC43218
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 21:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C35120675
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 21:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbfDYVcj (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Apr 2019 17:32:39 -0400
Received: from smtp-out-no.shaw.ca ([64.59.134.13]:52386 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfDYVcj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Apr 2019 17:32:39 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Apr 2019 17:32:39 EDT
Received: from cabot.adilger.int ([70.77.216.213])
        by shaw.ca with ESMTP
        id Jlr2h9zIhldkPJlr4hWEiT; Thu, 25 Apr 2019 15:24:31 -0600
X-Authority-Analysis: v=2.3 cv=Ko4zJleN c=1 sm=1 tr=0
 a=BQvS1EmAg2ttxjPVUuc1UQ==:117 a=BQvS1EmAg2ttxjPVUuc1UQ==:17 a=RPJ6JBhKAAAA:8
 a=lUF8FztOljBvnABUD3EA:9 a=xKMNMwCAcWKw66YE:21 a=C9may7e5q5gKfMoS:21
 a=fa_un-3J20JGBB2Tu-mn:22
From:   Andreas Dilger <adilger@dilger.ca>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] mke2fs: fix check for absurdly large devices
Date:   Thu, 25 Apr 2019 23:24:30 +0200
Message-Id: <1556227470-47076-1-git-send-email-adilger@dilger.ca>
X-Mailer: git-send-email 1.8.0
X-CMAE-Envelope: MS4wfOs6jwg3bq3yhT4dThgNXbbVsdwvV7eZZfPJwG+KDaxOeqxEfl06YZYD+oAdi40I5QCHhfPBWvGMaYQlHAOFgPuiSDCa8vkbz1gO9gJNB7Rmfo7GVUwn
 VHIabZm9rx5b2YftURS1iYEhObJzdUqjuxKK96m3TiDmMpc8rdi2anRt7xkNuTN+FAaD60HjA9BIZQWvDKYvkprPfbydyIR6tBttdP/tDWnYbZtAdWtEqLUq
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The check in mke2fs is intended to be for the number of blocks in the
filesystem exceeding the maximum number of addressable blocks in 2^32
bitmaps, which is (2^32 * 8 bits/byte * blocksize) = 2^47 blocks,
or 2^59 bytes = 512PiB for the common 4KiB blocksize.

However, s_log_blocksize holds log2(blocksize_in_kb), so the current
calculation is a factor of 2^10 too small.  This caused mke2fs to fail
while trying to format a 900TB filesystem.

Fixes: 101ef2e93c25 ("mke2fs: Avoid crashes / infinite loops for absurdly large devices")
Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 misc/mke2fs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index be3586c..23e313c 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2190,9 +2190,11 @@ profile_error:
 	}
 	/*
 	 * Guard against group descriptor count overflowing... Mostly to avoid
-	 * strange results for absurdly large devices.
+	 * strange results for absurdly large devices.  This is in log2:
+	 * (blocksize) * (bits per byte) * (maximum number of block groups)
 	 */
-	if (fs_blocks_count > ((1ULL << (fs_param.s_log_block_size + 3 + 32)) - 1)) {
+	if (fs_blocks_count >
+	    (1ULL << (EXT2_BLOCK_SIZE_BITS(&fs_param) + 3 + 32)) - 1) {
 		fprintf(stderr, _("%s: Size of device (0x%llx blocks) %s "
 				  "too big to create\n\t"
 				  "a filesystem using a blocksize of %d.\n"),
-- 
1.8.0

