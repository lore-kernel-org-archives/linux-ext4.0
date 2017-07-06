From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH][ext4-next] ext4: ensure error return ret is zero on
 successful return
Date: Thu, 6 Jul 2017 15:28:15 -0400
Message-ID: <20170706192815.pj4ptivvnuo2wrmy@thunk.org>
References: <20170623145840.26779-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170623145840.26779-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 23, 2017 at 03:58:40PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The error return ret is not set on a successful return path and
> so it returns a garbage value. Ensure it is is set to zero on
> a successful return.
> 
> Detected by CoverityScan, CID#1446616 ("Uninitialized scalar variable")
> 
> Fixes: 3499c0fb822d ("quota: add get_inode_usage callback to transfer multi-inode charges")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks, I've folded this into the "quota: add get_inode_usage callback
to transfer multi-inode charges" with credit for your providing the
fix.

					- Ted
