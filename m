Return-Path: <SRS0=bpHE=4B=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0672C3B188
	for <linux-ext4@archiver.kernel.org>; Thu, 13 Feb 2020 10:16:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6E8C2051A
	for <linux-ext4@archiver.kernel.org>; Thu, 13 Feb 2020 10:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbgBMKQI (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 13 Feb 2020 05:16:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:51206 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729428AbgBMKQH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Feb 2020 05:16:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 86A2CAD63;
        Thu, 13 Feb 2020 10:16:05 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 260CE1E0E01; Thu, 13 Feb 2020 11:16:05 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/7 v2] e2fsprogs: Better handling of indexed directories
Date:   Thu, 13 Feb 2020 11:15:55 +0100
Message-Id: <20200213101602.29096-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello,

Currently, libext2fs does not implement adding entry into htree directory. It
just bluntly clears EXT2_INDEX_FL and then treats the directory as non-indexed.
This breaks when metadata checksums are enabled and although ext2fs_link()
tries to fixup the directory, it doesn't always fixup all the checksums and
I have some doubts about practicality of just discarding htree information for
really large directories. This patch series implements full support for adding
entry into htree directory and some tests to test the functionality.

The first patch in the series is somewhat unrelated, it just clarifies handling
of overflown directory i_nlink handling in e2fsck which confused me initially
when analyzing the issue.

The second patch fixes a bug in e2fsck when rehashing indexed directories which
I've found during testing my series.

The third patch prepares ext2fs_mkdir() and ext2fs_symlink() to safely work
with ext2fs_link() - this demonstrates there's a breakage potential in the
following changes to ext2fs_link() for external applications using
ext2fs_link() because it can now modify the directory inode and allocate
blocks. If people are concerned about this, we could create ext2fs_link2()
with the new behavior and just restrict ext2fs_link() to bail with error
when called on indexed directory with metadata_csum enabled.

Next three patches implement the support for linking into indexed directories
and tests.

The last patch then fixes tune2fs to properly recompute directory checksums
when disabling dir_index feature.

Changes since v1:
* Fixed growing of h-tree to 3-levels
* Added e2fsck fix
* Added tune2fs fix
* Fixed ext2fs_mkdir() and ext2fs_symlink() to work with new ext2fs_link()
* Reworked tests

								Honza
