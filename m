From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 17/27] ext4: Convert to new freezing mechanism
Date: Sun, 10 Jun 2012 23:13:40 -0400
Message-ID: <20120611031340.GA29609@thunk.org>
References: <1338589841-9568-1-git-send-email-jack@suse.cz>
 <1338589841-9568-18-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
	dchinner@redhat.com, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48970 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab2FKDNw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Jun 2012 23:13:52 -0400
Content-Disposition: inline
In-Reply-To: <1338589841-9568-18-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 02, 2012 at 12:30:31AM +0200, Jan Kara wrote:
> We remove most of frozen checks since upper layer takes care of blocking all
> writes. We have to handle protection in ext4_page_mkwrite() in a special way
> because we cannot use generic block_page_mkwrite(). Also we add a freeze
> protection to ext4_evict_inode() so that iput() of unlinked inode cannot modify
> a frozen filesystem (we cannot easily instrument ext4_journal_start() /
> ext4_journal_stop() with freeze protection because we are missing the
> superblock pointer in ext4_journal_stop() in nojournal mode).
> 
> CC: linux-ext4@vger.kernel.org
> CC: "Theodore Ts'o" <tytso@mit.edu>
> BugLink: https://bugs.launchpad.net/bugs/897421
> Tested-by: Kamal Mostafa <kamal@canonical.com>
> Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
> Tested-by: Dann Frazier <dann.frazier@canonical.com>
> Tested-by: Massimo Morana <massimo.morana@canonical.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
