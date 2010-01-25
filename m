From: dingdinghua <dingdinghua@nrchpc.ac.cn>
Subject: [PATCH 0/2]fix an assertion in jbd/jbd2
Date: Mon, 25 Jan 2010 11:45:02 +0800
Message-ID: <1264391104-10950-1-git-send-email-dingdinghua@nrchpc.ac.cn>
Cc: dingdinghua <dingdinghua@nrchpc.ac.cn>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [159.226.39.252] ([159.226.39.252]:34356 "EHLO bwstor.com.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751373Ab0AYEMi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Jan 2010 23:12:38 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

the patch set is build on linus-git tree.
Two small fixs in journal_commit_transaction, jbd2_journal_commit_transaction

dingdinghua (2):
  Jbd: fix an assertion, jh->b_transaction should be
  Jbd2: fix an assertion, jh->b_transaction should be

 fs/jbd/commit.c  |    3 +--
 fs/jbd2/commit.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

