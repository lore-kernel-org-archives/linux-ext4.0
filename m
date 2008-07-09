From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: handle deleting corrupted indirect blocks
Date: Tue, 8 Jul 2008 22:53:04 -0400
Message-ID: <20080709025304.GG9957@mit.edu>
References: <1215528121-26934-1-git-send-email-duaneg@dghda.com> <1215528121-26934-2-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	Mingming <cmm@us.ibm.com>, Sami Liedes <sliedes@cc.hut.fi>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754950AbYGICyk@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1215528121-26934-2-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 08, 2008 at 03:42:00PM +0100, Duane Griffin wrote:
> +		if (bh2jh(this_bh))
> +			ext4_journal_dirty_metadata(handle, this_bh);
> +		else
> +			ext4_error(inode->i_sb, __func__,
> +				   "circular indirect block detected, "
> +				   "inode=%lu, block=%lu",
> +				   inode->i_ino, this_bh->b_blocknr);

this_bh->b_blocknr is a sector_t, which could be 64-bits.  So this
should be:

			ext4_error(inode->i_sb, __func__,
				   "circular indirect block detected, "
				   "inode=%lu, block=%llu",
				   inode->i_ino,
				   (unsigned long long) this_bh->b_blocknr);

I think.

With this change, I've included your three patches into the ext4 patch
queue.

						- Ted
