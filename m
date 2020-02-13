Return-Path: <SRS0=bpHE=4B=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C37C2BA83
	for <linux-ext4@archiver.kernel.org>; Thu, 13 Feb 2020 15:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1735420675
	for <linux-ext4@archiver.kernel.org>; Thu, 13 Feb 2020 15:50:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CdYnWy14"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgBMPu3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 13 Feb 2020 10:50:29 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41772 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387560AbgBMP02 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Feb 2020 10:26:28 -0500
Received: by mail-pf1-f194.google.com with SMTP id j9so3231088pfa.8;
        Thu, 13 Feb 2020 07:26:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3YsWsylZ4489Gb3tnUr9kkkeFg/lh1zGRWfBEejFiwA=;
        b=CdYnWy14vgKMDE8saobSvrpuwdjIw7BGvH3RroVir3x/MBhrWIMYWQXHeaV5pbj1a+
         bLeq+kKlKdPsWosW3KD3WQrSBY2/ToqH8gIsQMljOcMAj4NIMIEMYVyki1iYe38Lm9zn
         jEb9voFR6JAun43lFlu0Sn2B/uEnHoMryDTh/BWQdOirvc6eez1/JumX8NtoxfdZen+r
         6wcKFEooJ47FjLHBDddTPHoXeun6W1qEMYCpPHFKiglaClnP6iBBwg5BBSO0wG/TzsgL
         3MFtjslnEKVUBdcAhUb0yw34mCgVSg/S1/E7RIlCciQRkNczx1/+V7HglHxTi70Ehwjm
         s+5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3YsWsylZ4489Gb3tnUr9kkkeFg/lh1zGRWfBEejFiwA=;
        b=PkTOaVxRg69dHD+e3WcyRT0YEsQnmU5fZ3burjFRYhgR2ulOmEUabaGh4p0TG+6gsS
         LTeu3aaA6lLsfNp+V9Fvxb8eVpQEdWJNzAw2rkemXZxj1i0R1pM6VrV1FnnyfI+cRDXZ
         mx5CD9otTryQ3Fp39OtsJVedkxjClq9lH+rPtf+KeF+IEQ4VnOGVZ0LdHHHr4kiBCg45
         QHXmpnH7jnQKs4FGd7h641yj1+I6OI6JOAusHVbzit99v8gPeKw1g97K9Tiv8bUg8uWP
         oC95LyvpNEbXcmF+8sg+HuUlTy7naMK2OeeeMuCTyWhg/tJmPD7hYvKfHDQvjh0xJRNf
         822A==
X-Gm-Message-State: APjAAAUQVupEqTPmDOg0bi5dGYW4xZGwFA/p7tIvd+FMSZneOjh7zVw3
        LBLDY+EqqaK88eKAYLMJRw==
X-Google-Smtp-Source: APXvYqxb1gt5GdQ7FxVEv5Kv5nacrmWzCQlAA3YUYdxzXLhKbg4wJSto+u81h9uRby9JM7fcpafvlA==
X-Received: by 2002:a62:e91a:: with SMTP id j26mr14805034pfh.189.1581607587813;
        Thu, 13 Feb 2020 07:26:27 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:1ee8:f65a:fc5b:5bfd:1ab4:4848])
        by smtp.gmail.com with ESMTPSA id z3sm3609082pfz.155.2020.02.13.07.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 07:26:27 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] fs: ext4: mballoc.c: Use built-in RCU list checking
Date:   Thu, 13 Feb 2020 20:55:58 +0530
Message-Id: <20200213152558.7070-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

list_for_each_entry_rcu() has built-in RCU and lock checking.

Pass cond argument to list_for_each_entry_rcu() to silence
false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled
by default.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 fs/ext4/mballoc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a3e2767bdf2f..70418e13e9e8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4280,7 +4280,7 @@ ext4_mb_discard_lg_preallocations(struct super_block *sb,
 
 	spin_lock(&lg->lg_prealloc_lock);
 	list_for_each_entry_rcu(pa, &lg->lg_prealloc_list[order],
-						pa_inode_list) {
+						pa_inode_list, lockdep_is_held(&lg->lg_prealloc_lock)) {
 		spin_lock(&pa->pa_lock);
 		if (atomic_read(&pa->pa_count)) {
 			/*
@@ -4363,7 +4363,7 @@ static void ext4_mb_add_n_trim(struct ext4_allocation_context *ac)
 	/* Add the prealloc space to lg */
 	spin_lock(&lg->lg_prealloc_lock);
 	list_for_each_entry_rcu(tmp_pa, &lg->lg_prealloc_list[order],
-						pa_inode_list) {
+						pa_inode_list, lockdep_is_held(&lg->lg_prealloc_lock)) {
 		spin_lock(&tmp_pa->pa_lock);
 		if (tmp_pa->pa_deleted) {
 			spin_unlock(&tmp_pa->pa_lock);
-- 
2.17.1

