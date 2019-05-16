Return-Path: <SRS0=9AJ9=TQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38EBDC04E87
	for <linux-ext4@archiver.kernel.org>; Thu, 16 May 2019 10:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1590820848
	for <linux-ext4@archiver.kernel.org>; Thu, 16 May 2019 10:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfEPKD0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 16 May 2019 06:03:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:48414 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727156AbfEPKDZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 16 May 2019 06:03:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 69622AFA4;
        Thu, 16 May 2019 10:03:24 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id BE1E21E3ED7; Thu, 16 May 2019 12:03:23 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-ext4@vger.kernel.org>
Cc:     cgxu519@zoho.com.cn, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3 v2] ext2: Cleanup ext2_xattr_set()
Date:   Thu, 16 May 2019 12:03:19 +0200
Message-Id: <20190516100322.12632-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello,

this series contains updated patch from Chengguang and two additional cleanups
to xattr code in ext2_xattr_set() to remove some duplicated code and useless
checks.

Changes since v1:
* fixed patch 2 to maintain sorting of xattrs in ext2_xattr_set
* made loops in ext2_xattr_get() and ext2_xattr_list() also check all seen
  xattr entries

								Honza
