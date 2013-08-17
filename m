From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix oops in jbd2_journal_file_inode()
Date: Fri, 16 Aug 2013 21:24:02 -0400
Message-ID: <20130817012402.GA9349@thunk.org>
References: <1375886476-26805-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, majianpeng <majianpeng@gmail.com>,
	Lukas Czerner <lczerner@redhat.com>, stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44773 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab3HQBYK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Aug 2013 21:24:10 -0400
Content-Disposition: inline
In-Reply-To: <1375886476-26805-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 07, 2013 at 04:41:16PM +0200, Jan Kara wrote:
> Commit 0713ed0cde76438d05849f1537d3aab46e099475 added
> jbd2_journal_file_inode() call into ext4_block_zero_page_range().
> However that function gets called from truncate path and thus inode
> needn't have jinode attached - that happens in ext4_file_open() but the
> file needn't be ever open since mount. Calling jbd2_journal_file_inode()
> without jinode attached results in the oops.
> 
> We fix the problem by attaching jinode to inode also in ext4_truncate()
> and ext4_punch_hole() when we are going to zero out partial blocks.
> 
> CC: <stable@vger.kernel.org> (from 3.10)
> Reported-by: majianpeng <majianpeng@gmail.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.  I've removed the cc: stable since commit
0713ed0cde764 didn't show up until v3.11-rc1.

						- Ted
