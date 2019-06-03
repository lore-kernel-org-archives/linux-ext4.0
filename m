Return-Path: <SRS0=I4sj=UC=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51CA1C04AB5
	for <linux-ext4@archiver.kernel.org>; Mon,  3 Jun 2019 13:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2637525C0B
	for <linux-ext4@archiver.kernel.org>; Mon,  3 Jun 2019 13:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbfFCNWE (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 3 Jun 2019 09:22:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:40904 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727592AbfFCNWE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 3 Jun 2019 09:22:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F3037AB91;
        Mon,  3 Jun 2019 13:22:02 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 4B8571E3C24; Mon,  3 Jun 2019 15:22:00 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-ext4@vger.kernel.org>
Cc:     Ted Tso <tytso@mit.edu>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] fs: Hole punch vs page cache filling races
Date:   Mon,  3 Jun 2019 15:21:53 +0200
Message-Id: <20190603132155.20600-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello,

Amir has reported a that ext4 has a potential issues when reads can race with
hole punching possibly exposing stale data from freed blocks or even corrupting
filesystem when stale mapping data gets used for writeout. The problem is that
during hole punching, new page cache pages can get instantiated in a punched
range after truncate_inode_pages() has run but before the filesystem removes
blocks from the file.  In principle any filesystem implementing hole punching
thus needs to implement a mechanism to block instantiating page cache pages
during hole punching to avoid this race. This is further complicated by the
fact that there are multiple places that can instantiate pages in page cache.
We can have regular read(2) or page fault doing this but fadvise(2) or
madvise(2) can also result in reading in page cache pages through
force_page_cache_readahead().

This patch set fixes the problem for ext4 by protecting all page cache filling
opearation with EXT4_I(inode)->i_mmap_lock. To be able to do that for
readahead, we introduce new ->readahead file operation and corresponding
vfs_readahead() helper. Note that e.g. ->readpages() cannot be used for getting
the appropriate lock - we also need to protect ordinary read path using
->readpage() and there's no way to distinguish ->readpages() called through
->read_iter() from ->readpages() called e.g. through fadvise(2).

Other filesystems (e.g. XFS, F2FS, GFS2, OCFS2, ...) need a similar fix. I can
write some (e.g. for XFS) once we settle that ->readahead operation is indeed a
way to fix this.

								Honza

[1] https://lore.kernel.org/linux-fsdevel/CAOQ4uxjQNmxqmtA_VbYW0Su9rKRk2zobJmahcyeaEVOFKVQ5dw@mail.gmail.com/
