From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 1/6] jbd2: Issue cache flush after checkpointing even with internal journal
Date: Thu, 9 Feb 2012 00:26:11 -0500
Message-ID: <4BF54606-BF0E-4CA8-98F7-25B16BCDA497@mit.edu>
References: <1326241872-20142-1-git-send-email-jack@suse.cz> <1326241872-20142-2-git-send-email-jack@suse.cz> <20120111124918.GD26337@quack.suse.cz> <20120209030551.GH18461@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:45784 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819Ab2BIFbN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Feb 2012 00:31:13 -0500
In-Reply-To: <20120209030551.GH18461@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

One more thought.   I wonder if we should be trying to call a version of journal_cleanup_tail after we do a commit, since at that point we will have done a flush so updating the journal superblock should be "cheap".

-- Ted

