Return-Path: <SRS0=XaFB=Y5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A18B2C5DF63
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Nov 2019 16:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81F252190F
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Nov 2019 16:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390415AbfKEQoo (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 5 Nov 2019 11:44:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:41538 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390340AbfKEQok (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 5 Nov 2019 11:44:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B18CEB052;
        Tue,  5 Nov 2019 16:44:37 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 245E21E47E5; Tue,  5 Nov 2019 17:44:37 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/25 v3] ext4: Fix transaction overflow due to revoke descriptors
Date:   Tue,  5 Nov 2019 17:44:06 +0100
Message-Id: <20191003215523.7313-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20191105164406.eLBpC9DJG-1AAoIhXpHzOpmOgZ3LGdu_J-Or4O79Hvo@z>

Hello,

Here is v3 of this series with couple more bugs fixed. Now all failed tests Ted
higlighted pass for me.

Changes since v3:
* Added reviewed-by tags
* Added update of precomputed number of revoke records per descriptor block
  when journal features change
* Fix possible inode leak in ext4_add_mkdir() in case of crash
* Fix other cases where last inode reference gets dropped while the transaction
  is running
* Improve comment about the new meaning of t_outstanding_credits
* Added patch to reduce estimate on the base number of reserved descriptor
  blocks
* jbd2_journal_revoke() now returns error in case there are not enough revoke
  credits so that ext4 can abort handle etc.
* Improve estimate on the number of necessary revoke records for truncate
* Add fix for too small array of journal buffers
* Account number of revoke records in the transaction to avoid overestimation
  of necessary revoke descriptor blocks

Changes since v2:
* Fixed bug in revoke credit estimates for extent freeing in bigalloc
  filesystems
* Fixed bug in xattr code treating positive return of
  ext4_journal_ensure_credits() as error
* Fixed preexisting bug in ext4_evict_inode() where we reserved too few credits
* Added trace point to jbd2_journal_restart()
* Fix some kernel doc bugs
* Rebased on top of 5.4-rc1

Changes since v1:
* Reordered some patches to reduce code churn
* Computation in jbd2_revoke_descriptors_per_block() was too early - moved it
  to later when journal superblock is loaded and so the feature checking
  actually works.
* Made sure nobody outside JBD2 uses handle->h_buffer_credits since now it
  contains also credits for revoke descriptors and it was confusing come users.
* Updated cover letter with more details about reproducer

Original cover letter:

I've recently got a bug report where JBD2 assertion failed due to
transaction commit running out of journal space. After closer inspection of
the crash dump it seems that the problem is that there were too many
journal descriptor blocks (more that max_transaction_size >> 5 + 32 we
estimate in jbd2_log_space_left()) due to descriptor blocks with revoke
records. In fact the estimate on the number of descriptor blocks looks
pretty arbitrary and there can be much more descriptor blocks needed for
revoke records. We need one revoke record for every metadata block freed.
So in the worst case (1k blocksize, 64-bit journal feature enabled,
checksumming enabled) we fit 125 revoke record in one descriptor block.  In
common cases its about 500 revoke records per descriptor block. Now when
we free large directories or large file with data journalling enabled, we can
have *lots* of blocks to revoke - with extent mapped files easily millions
in a single transaction which can mean 10k descriptor blocks - clearly more
than the estimate of 128 descriptor blocks per transaction ;)

This patch series aims at fixing the problem by accounting descriptor blocks
into transaction credits and reserving appropriate amount of credits for revoke
descriptors on transaction handle start. Similar to normal transaction credits,
the filesystem has to provide estimate for the number of blocks it is going
to revoke using the transaction handle so that credits for revoke descriptors
can be reserved.

The series has survived fstests in couple configurations and also the stress
test like:
  Create filesystem with 1KB blocksize and journal size 32MB
  Mount the filesystem with -o nodelalloc
  for (( i = 0; i < 4; i++ )); do
    dd if=/dev/zero of=file$i bs=1M count=2048 conv=fsync
    chattr +j file$i
  done
  for (( i = 0; i < 4; i++ )); do
    rm file$i&
  done

which reliably triggers the assertion failure in JBD2 on unpatched kernel.

Review and comments are welcome :).

								Honza
Previous versions:
Link: http://lore.kernel.org/r/20190927111536.16455-1-jack@suse.cz
Link: http://lore.kernel.org/r/20190930103544.11479-1-jack@suse.cz
