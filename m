From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V2] ext4: ext4_mb_seq_groups_show: Fix stack memory
 corruption
Date: Mon, 14 Nov 2016 21:35:08 -0500
Message-ID: <20161115023508.wqtx3a3smpbjiwz7@thunk.org>
References: <1478756764-4459-1-git-send-email-chandan@linux.vnet.ibm.com>
 <20161110171346.GA31098@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-ext4@vger.kernel.org, adilger@dilger.ca
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37264 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933258AbcKOCfM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 14 Nov 2016 21:35:12 -0500
Content-Disposition: inline
In-Reply-To: <20161110171346.GA31098@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 10, 2016 at 06:13:46PM +0100, Jan Kara wrote:
> On Thu 10-11-16 11:16:04, Chandan Rajendra wrote:
> > The number of 'counters' elements needed in 'struct sg' is
> > super_block->s_blocksize_bits + 2. Presently we have 16 'counters'
> > elements in the array. This is insufficient for block sizes >= 32k. In
> > such cases the memcpy operation performed in ext4_mb_seq_groups_show()
> > would cause stack memory corruption.
> > 
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> 
> Looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Applied, thanks!

					- Ted
