From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't free an error pointer
Date: Mon, 3 Jul 2017 21:37:57 -0400
Message-ID: <20170704013757.mglr2mom3tev5nwj@thunk.org>
References: <20170630075652.gsvvzybinoee2biw@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170630075652.gsvvzybinoee2biw@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 30, 2017 at 10:56:53AM +0300, Dan Carpenter wrote:
> "goto out;" calls brelse(bh); which will oops on this this path where
> "bh" is an error pointer.
> 
> Fixes: 2851a40a5d71 ("ext4: xattr-in-inode support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Oops.  I wrote a bug report and a patch for this...  Probably we only
> need the patch.

Thanks, I've folded your this to the xattr-in-inode patch and added a
credit for the bugfix to the commit log.

					- Ted
