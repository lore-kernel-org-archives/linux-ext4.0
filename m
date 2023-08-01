Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5BAAC001DF
	for <linux-ext4@archiver.kernel.org>; Tue,  1 Aug 2023 14:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbjHAOlo (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 1 Aug 2023 10:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234590AbjHAOll (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Aug 2023 10:41:41 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7DF9C;
        Tue,  1 Aug 2023 07:41:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 398301F45A;
        Tue,  1 Aug 2023 14:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690900899; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=L4scspEofNFZsqaoPa/uagvn9jfb5SNDwDcPebxybj8=;
        b=wbpIQRBA4leKtrWq52bsLBPy3dasXNlM83tBFXuy6DKfjbbfTiHo+axech1TR9YcAjNFxm
        rruFVUXEQoNC/kW3TJ9jrT4seEJpEv75/6nSGYF7FSYR7vzHmoB1sl/CZWr5a5BTiUG5Sj
        0PBJqhyyRCZJsfr0YQPhrvRKReLjLMQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690900899;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=L4scspEofNFZsqaoPa/uagvn9jfb5SNDwDcPebxybj8=;
        b=3suknXgZXNbb7oxlw6YY9Gz9wN78Da5aPmMCq+EIw5P0h66ZrtxdI+PODTd1UhKripPE6m
        m03MKfp5kmaluABg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C7F8A139BD;
        Tue,  1 Aug 2023 14:41:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8CbhLaIZyWSOawAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 01 Aug 2023 14:41:38 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 3bec45b3;
        Tue, 1 Aug 2023 14:41:37 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH] ext4: fix memory leak in ext4_fname_setup_filename() error path
Date:   Tue,  1 Aug 2023 15:41:36 +0100
Message-Id: <20230801144136.23565-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

If casefolding the filename fails, we'll be leaking fscrypt_buf name.
Make sure we free it in the error path.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 fs/ext4/crypto.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index e20ac0654b3f..9e4503b051c4 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -33,6 +33,8 @@ int ext4_fname_setup_filename(struct inode *dir, const struct qstr *iname,
 
 #if IS_ENABLED(CONFIG_UNICODE)
 	err = ext4_fname_setup_ci_filename(dir, iname, fname);
+	if (err)
+		fscrypt_free_filename(&name);
 #endif
 	return err;
 }
