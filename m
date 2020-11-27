Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C42C2D0E4
	for <linux-ext4@archiver.kernel.org>; Fri, 27 Nov 2020 11:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07DF420B80
	for <linux-ext4@archiver.kernel.org>; Fri, 27 Nov 2020 11:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgK0LeJ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 27 Nov 2020 06:34:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:51526 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727952AbgK0LeJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 27 Nov 2020 06:34:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 238F5AD21;
        Fri, 27 Nov 2020 11:34:08 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id A577B1E1318; Fri, 27 Nov 2020 12:34:07 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 00/12] ext4: Various fixes of ext4 handling of fs errors
Date:   Fri, 27 Nov 2020 12:33:53 +0100
Message-Id: <20201127113405.26867-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello,

this patches addresses problems in handling of filesystem errors in ext4.
When we hit metadata error, we want to store information about the error
in the superblock. Currently we do it through direct superblock modification
which can lead to lost information, checksum failures, or DIF/DIX failures.
Fix various races in the error handling so that the superblock update is
reliable.

The patches have passed xfstests for me in various configurations and some
targetted manual testing of the error handling.

								Honza
