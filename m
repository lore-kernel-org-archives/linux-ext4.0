From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Fix waiting and sending of a barrier in
 ext4_sync_file()
Date: Mon, 23 May 2011 15:28:34 -0400
Message-ID: <20110523192834.GK10009@thunk.org>
References: <20110522211239.GB10009@thunk.org>
 <1306098825-469-2-git-send-email-tytso@mit.edu>
 <20110523171747.GG4716@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33414 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933531Ab1EWT2i (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 May 2011 15:28:38 -0400
Content-Disposition: inline
In-Reply-To: <20110523171747.GG4716@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 23, 2011 at 07:17:47PM +0200, Jan Kara wrote:
> b) Whether we do or don't send the flush in
> jbd2_journal_commit_transaction() depends on whether t_flushed_data_blocks
> is set.  We can't know in advance whether it gets set or not because it
> depends on whether some inode is in transaction's t_inode_list and inodes
> can get removed from there when flusher thread has written all the pages
> and inode has been reclaimed. OTOH this looks like a bug in the commit code
> anyway - I guess t_flushed_data_blocks (or better named equivalent) should
> be set in jbd2_journal_file_inode(). Then such variable will also become
> a reliable indicator whether the data flush is going to be sent or not.

Um, I guess I don't see where an inode gets removed from t_inode_list
after the writeback daemon is done with an inode?

      	  	    	      	   	   - Ted
