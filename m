From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: add check to io_submit_init_bio
Date: Thu, 6 Jun 2013 10:19:41 -0400
Message-ID: <20130606141941.GA5382@thunk.org>
References: <20130606115653.a21b0c6a7bdbbbac23164b85@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130606115653.a21b0c6a7bdbbbac23164b85@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 06, 2013 at 11:56:53AM +1000, Stephen Rothwell wrote:
> 
> In tracking this down, I followed the call chains and discovered that
> io_submit_init_bio() only ever returned 0.  Switching that to return
> void and following back up the chain lead to the following patch.

Actually, that's a bug.  We're missing an check in that function.
Thanks for looking at this code.  (I'll fix the uninitialized err
warning another way.)

						- Ted

commit 7745883f99c0e81e6bc71527d23ca363eb125a3f
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Jun 6 10:18:22 2013 -0400

    ext4: add check to io_submit_init_bio
    
    The bio_alloc() function can return NULL if the memory allocation
    fails.  So we need to check for this.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index ce8c15a..48786cd 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -372,6 +372,8 @@ static int io_submit_init_bio(struct ext4_io_submit *io,
 	struct bio *bio;
 
 	bio = bio_alloc(GFP_NOIO, min(nvecs, BIO_MAX_PAGES));
+	if (!bio)
+		return -ENOMEM;
 	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_bdev = bh->b_bdev;
 	bio->bi_end_io = ext4_end_bio;
