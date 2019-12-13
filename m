Return-Path: <SRS0=cA8i=2D=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32216C341C7
	for <linux-ext4@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 665DF246D0
	for <linux-ext4@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I/5OorDH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbfLMPjT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 13 Dec 2019 10:39:19 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36625 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727904AbfLMPjT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Dec 2019 10:39:19 -0500
Received: by mail-pf1-f196.google.com with SMTP id x184so1669880pfb.3;
        Fri, 13 Dec 2019 07:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5ksn7G5VYv/ryn3yV+sG6Khj5HN3a4JJFcRA1aIqGsc=;
        b=I/5OorDH2s57/ZmXBDm471m9YhattiMARcBWnB/M6vftRZMqyPT4Kyyv3io9GLgGvp
         Gt7XbTaOAzz1RYcbmUNOM3zCC9ooituahSFyhHzi7b8MhflLEB/3fd2UwjWOmU9kJkNL
         U2OGel49zhdPhvxA8TJtddbkaKp4kWLuzfGgyB67ItijYpcLfdqp/+J9HAZDLgwmuM7p
         icduXRqKhRVcF7a/Fmdaefj59VkFCooxn+T+r3oDYwNRXv0lWRCRLrApmjfQt8xu/F79
         /zbEmQzSppK6GjndgnkY5w7Bpvp+ZbryywIFQqUBtVLNdsdwXpoRSojzPXJXavLOzcf8
         sGYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5ksn7G5VYv/ryn3yV+sG6Khj5HN3a4JJFcRA1aIqGsc=;
        b=B7LwEWLdCk8Vu/8XHdufDGMWU17AqSV3L7MEZ14eh4UmPIVPHqxUhx/uOFgA3yEd8E
         KjP6jdasIW2uRkMGaXphZ4kC4+TTzQMhjU23jmretmtmYCLxyYsQOSPeA9c/ciYe8Adw
         ZaeETW1QYhZzHx4SyeheLjr2+45ho3VQv1lI46TnFNM84R3aZcZozfJ1WWL8LU3mN5jg
         BhAYGxsWSsvGO7uPYdA9OEX6ArpoitSQXV9ZKJ2HgzBj3FFiwex0E6F50HUFshyCMoUA
         twgpqy0hKUh1mNrE0yHoGxTrLL3mhZL7XoG43ICpOGzJhdqpQ8jhqNhOIwckbO1mDxCI
         zqWw==
X-Gm-Message-State: APjAAAU0+c6EM+ix9qATq95NVaq/7IMjTw6iNTIQZXbWFHuc4CbYzLjs
        2+yXcY4T8SmcDe5TyFYIxznRDxBdcUE=
X-Google-Smtp-Source: APXvYqwZKvWM4KVEbblUTPfNgKLvrVa397PSCGZfDG1xfH/41foIwCmL2nz/b/MSXUWemPgipOI8rw==
X-Received: by 2002:a65:66da:: with SMTP id c26mr45888pgw.354.1576251558676;
        Fri, 13 Dec 2019 07:39:18 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:48ef:2a83:3099:c3ff:3682])
        by smtp.gmail.com with ESMTPSA id 100sm10702350pjo.17.2019.12.13.07.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 07:39:17 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     paulmck@kernel.org, joel@joelfernandes.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        rcu@vger.kernel.org, Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH V2] ext4: use rcu API in debug_print_tree
Date:   Fri, 13 Dec 2019 22:33:07 +0700
Message-Id: <20191213153306.30744-1-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191213113510.GG15474@quack2.suse.cz>
References: <20191213113510.GG15474@quack2.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

struct ext4_sb_info.system_blks was marked __rcu.
But access the pointer without using RCU lock and dereference.
Sparse warning with __rcu notation:

block_validity.c:139:29: warning: incorrect type in argument 1 (different address spaces)
block_validity.c:139:29:    expected struct rb_root const *
block_validity.c:139:29:    got struct rb_root [noderef] <asn:4> *

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 fs/ext4/block_validity.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

---
change log:
V2: Add Reviewed-by: Jan Kara <jack@suse.cz>

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index d4d4fdfac1a6..1ee04e76bbe0 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -133,10 +133,13 @@ static void debug_print_tree(struct ext4_sb_info *sbi)
 {
 	struct rb_node *node;
 	struct ext4_system_zone *entry;
+	struct ext4_system_blocks *system_blks;
 	int first = 1;
 
 	printk(KERN_INFO "System zones: ");
-	node = rb_first(&sbi->system_blks->root);
+	rcu_read_lock();
+	system_blks = rcu_dereference(sbi->system_blks);
+	node = rb_first(&system_blks->root);
 	while (node) {
 		entry = rb_entry(node, struct ext4_system_zone, node);
 		printk(KERN_CONT "%s%llu-%llu", first ? "" : ", ",
@@ -144,6 +147,7 @@ static void debug_print_tree(struct ext4_sb_info *sbi)
 		first = 0;
 		node = rb_next(node);
 	}
+	rcu_read_unlock();
 	printk(KERN_CONT "\n");
 }
 
-- 
2.20.1

