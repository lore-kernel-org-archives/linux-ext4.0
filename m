From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] Fix sending of a barrier and transaction waiting in ext4_sync_file()
Date: Tue, 17 May 2011 12:28:13 +0200
Message-ID: <1305628095-27843-1-git-send-email-jack@suse.cz>
Cc: Edward Goggin <egoggin@vmware.com>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:59684 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab1EQK2p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2011 06:28:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hi Ted,

  the two patches below fix ext4_sync_file() to wait for a transaction commit
properly (return value of jbd2_log_start_commit() is not exactly what
ext4_sync_file() thinks it is). It also optimizes / fixes sending of a barrier
in some cases (e.g. in ordered mode with external journal we cannot really
depend on transaction commit to issue a barrier to fs device because we don't
seem to add inode to a transaction for overwrites).

I already fixed ext3 in this regard some time ago but didn't get to porting the
patches to ext4. 

									Honza
