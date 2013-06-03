From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] jbd2: check bh->b_data for NULL in
 jbd2_journal_get_descriptor_buffer before memset()
Date: Mon, 3 Jun 2013 11:33:23 -0400
Message-ID: <20130603153323.GB20009@thunk.org>
References: <1370253616-8173-1-git-send-email-ruslan.bilovol@ti.com>
 <1370253616-8173-2-git-send-email-ruslan.bilovol@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1370253616-8173-2-git-send-email-ruslan.bilovol@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 03, 2013 at 01:00:15PM +0300, Ruslan Bilovol wrote:
> The memset() doesn't perform any NULL-pointer checking
> before dereferencing passed pointer so this should be
> checked before calling it.

I can see that __getblk() can return NULL if there is a memory
allocation failure (and is defined to do so), so checking to make sure
bh is not NULL is a good thing to do.

Have you actually seen a case where bh is non-NULL, but bh->b_data is
NULL?  If not, it might be better to do something like this:

>  	bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
	if (!bh)
		return NULL;
	BUG_ON(!bh->b_data);

						- Ted
