From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 0/4] ext4/jbd2: misc 3.17 bugfixes
Date: Wed, 10 Sep 2014 17:28:18 -0700
Message-ID: <20140911002818.10109.51772.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42184 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaIKA2Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Sep 2014 20:28:24 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Here are four patches against 3.17-rc4 to fix some minor problems
in jbd2 and ext4.  None of these four depend on each other; they
fix separate small bugs.

The first patch fixes the journal_checksum feature flag handling at
mount time.  This patch has been out for review on the list for a
while.

The second patch fixes external journal mounting so that the
superblock checksum (of the ext. journal) is verified if metadata_csum
is set.  This is the same patch that has been out for review for a few
days.

The third patch fixes a journal_checksum_v3 replay bug -- if a block
is in a transaction, and then later revoked and written into another
transaction, and the block in the second transaction is corrupt, the
journal would fail even to write the block from the first transaction.
This would worsen the damage caused by a corrupt journal.

The fourth bug fixes an inline_data bug where we would release a page
but then keep using it, which resulted in complaints about freeing
locked pages at umount time or strange system crashes.

Patches are against 3.17-rc4, and have been xfstest'd and checked
against debugfs creating test journals.  There's still a hard to
reproduce crash when ext4_destroy_inline_data_nolock tries to remove
the inline data xattr from a corrupt inode, so we'll see if I can nail
that one.

Comments and questions are, as always, welcome.

--D
