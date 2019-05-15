Return-Path: <SRS0=I5ct=TP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE5CC04E53
	for <linux-ext4@archiver.kernel.org>; Wed, 15 May 2019 14:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9F7D20873
	for <linux-ext4@archiver.kernel.org>; Wed, 15 May 2019 14:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfEOOBy (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 15 May 2019 10:01:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:43246 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726851AbfEOOBy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 15 May 2019 10:01:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 26A84AF86;
        Wed, 15 May 2019 14:01:53 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 3938C1E3C5A; Wed, 15 May 2019 16:01:51 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-ext4@vger.kernel.org>
Cc:     Chengguang Xu <cgxu519@zoho.com.cn>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3] ext2: Cleanup ext2_xattr_set()
Date:   Wed, 15 May 2019 16:01:41 +0200
Message-Id: <20190515140144.1183-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello,

this series contains updated patch from Chengguang and two additional cleanups
to xattr code in ext2_xattr_set() to remove some duplicated code and useless
checks.

								Honza
