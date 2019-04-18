Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71641C10F14
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 14:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 409EA2083D
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 14:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389190AbfDROGC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:06:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50142 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388392AbfDROGC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Apr 2019 10:06:02 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CBFEF307CB3F;
        Thu, 18 Apr 2019 14:06:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-121-98.rdu2.redhat.com [10.10.121.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 606D260857;
        Thu, 18 Apr 2019 14:05:57 +0000 (UTC)
Subject: [RFC PATCH 0/6] vfs: Make icache searchable under RCU
From:   David Howells <dhowells@redhat.com>
To:     viro@zeniv.linux.org.uk
Cc:     Jan Harkes <jaharkes@cs.cmu.edu>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        codalist@coda.cs.cmu.edu, coda@cs.cmu.edu,
        linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org,
        dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-ext4@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 18 Apr 2019 15:05:51 +0100
Message-ID: <155559635133.21702.4737487773869377967.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 18 Apr 2019 14:06:02 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


Hi Al

Here are some patches that make the icache searchable under RCU.  This
benefits ext4 (which can use it to find an inode to update the timestamps on)
and afs (which can use it to find a vnode to invalidate the callback promise
on).

It might also benefit NTFS, if its use ilookup5_nowait() can be substituted
for.  I'm not sure whether it actually needs to wait for inodes that are
undergoing deletion.

The first patch in the series attempts to fix the non-use of locking in Coda
when it moves an inode between buckets because it needs to update the search
key.

Thanks,
David
---
David Howells (6):
      vfs, coda: Fix the lack of locking in FID replacement inode rehashing
      vfs: Change inode_hash_lock to a seqlock
      vfs: Allow searching of the icache under RCU conditions
      afs: Use RCU inode cache search for callback resolution
      ext4: Search for an inode to update under the RCU lock if we can
      vfs: Delete find_inode_nowait()


 fs/afs/callback.c  |   12 ++
 fs/coda/cnode.c    |   11 ++
 fs/ext4/inode.c    |   41 ++++---
 fs/inode.c         |  309 ++++++++++++++++++++++++++++++++++++----------------
 include/linux/fs.h |   11 +-
 5 files changed, 260 insertions(+), 124 deletions(-)

