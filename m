From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix jbd2 warning under heavy xattr load
Date: Mon, 7 Apr 2014 10:55:12 -0400
Message-ID: <20140407145512.GC8855@thunk.org>
References: <1396863519-16895-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Sage Weil <sage@inktank.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51118 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213AbaDGOzT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Apr 2014 10:55:19 -0400
Content-Disposition: inline
In-Reply-To: <1396863519-16895-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 07, 2014 at 11:38:39AM +0200, Jan Kara wrote:
> When heavily exercising xattr code the assertion that
> jbd2_journal_dirty_metadata() shouldn't return error was triggered:
> 
> WARNING: at /srv/autobuild-ceph/gitbuilder.git/build/fs/jbd2/transaction.c:1237
> jbd2_journal_dirty_metadata+0x1ba/0x260()

Thanks, I've applied this patch and marked it for the stable tree.

	     	     	  	    - Ted
