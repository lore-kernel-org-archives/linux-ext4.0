Return-Path: <SRS0=temF=BH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D0DC433EA
	for <linux-ext4@archiver.kernel.org>; Tue, 28 Jul 2020 13:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B370720663
	for <linux-ext4@archiver.kernel.org>; Tue, 28 Jul 2020 13:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729979AbgG1NEs (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 28 Jul 2020 09:04:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:42872 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729529AbgG1NEq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 28 Jul 2020 09:04:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 98A3EB133;
        Tue, 28 Jul 2020 13:04:56 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 6EA461E12C7; Tue, 28 Jul 2020 15:04:45 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/6 v3] ext4: Check journal inode extents more carefully
Date:   Tue, 28 Jul 2020 15:04:31 +0200
Message-Id: <20200728130437.7804-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello!

This series changes ext4 to properly check extent tree blocks of journal inode.
Omitting these (which is a limitation of block validity checks) leads to crash
in ext4_cache_extents() in case the extent tree of the journal inode is
suitably corrupted. 

Changes since v1:
* Added Reviewed-by tags from Lukas
* Fixed two more unrelated minor bugs in block validity testing spotted by
  Lukas

Changes since v2:
* Add more Reviewed-by tags from Lukas
* Fix intermediate compilation failure in patch 3/6

								Honza
