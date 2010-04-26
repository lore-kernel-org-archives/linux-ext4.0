From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] Fix waiting on transaction in ext3_sync_file
Date: Mon, 26 Apr 2010 22:10:57 +0200
Message-ID: <1272312659-16468-1-git-send-email-jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58379 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985Ab0DZULE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Apr 2010 16:11:04 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id 8EAE686EE4
	for <linux-ext4@vger.kernel.org>; Mon, 26 Apr 2010 22:11:01 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hi,

  the two patches below fix waiting on transaction in ext3_sync_file.  The
problem is that log_start_commit() returns 1 only if it has really started
committing. If the transaction is already undergoing commit, it will return 0
and thus we incorrectly proceed although we should have waited for commit to
finish. This problem would be easily solved by always waiting for transaction
commit. But we also need to know whether the commit really happened after we
have entered ext3_sync_file - otherwise we have to send a barrier request to
disk. Sending it in all cases has unnecessarily bad performance.
  Attached patch addresses the issue by providing a function
journal_trans_will_send_data_barrier which takes transaction ID and returns
whether the final stage of commit of this transaction has not happened yet.
Ext3 then uses this function to check whether it needs to send an additional
barrier or not.
  Any comments or review welcome.

								Honza
