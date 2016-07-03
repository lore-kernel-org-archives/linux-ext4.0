From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't call ext4_should_journal_data() on the
 journal inode
Date: Sun, 3 Jul 2016 01:15:05 -0400
Message-ID: <20160703051505.GA17739@thunk.org>
References: <1467495762-25353-1-git-send-email-vegard.nossum@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Vegard Nossum <vegard.nossum@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53334 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbcGCFPM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Jul 2016 01:15:12 -0400
Content-Disposition: inline
In-Reply-To: <1467495762-25353-1-git-send-email-vegard.nossum@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 02, 2016 at 11:42:42PM +0200, Vegard Nossum wrote:
> Certain combinations of mount options in the superblock will cause
> set_journal_csum_feature_set() in ext4_fill_super() to fail after the
> journal has been created. When iput() is called on the journal inode,
> we will hit the BUG() in ext4_should_journal_data(). We can prevent
> this by only calling ext4_should_journal_data() if we already know
> that it's not the journal inode.

Which mount options?  Can you please give a reproducer?

      	    	      	      	     - Ted
