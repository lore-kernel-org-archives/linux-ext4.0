From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v2 1/2] direct-io: cleanup get_more_blocks()
Date: Wed, 11 May 2016 21:23:12 +0800
Message-ID: <20160511132312.GD10350@eguan.usersys.redhat.com>
References: <1462645910-23290-1-git-send-email-guaneryu@gmail.com>
 <x49y47h6cg2.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x49y47h6cg2.fsf@segfault.boston.devel.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 10, 2016 at 01:38:05PM -0400, Jeff Moyer wrote:
> Eryu Guan <guaneryu@gmail.com> writes:
> 
> > Save one level of indention by returning error early.
> >
> > Introduce some local variables to make the code easier to read a bit,
> > and do preparation for next patch.
> >
> > Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> 
> Hi, Eryu,
> 
> I don't think you have a full appreciation of the amount of optimization
> that goes into this code.  I don't see anything wrong with what you've
> done, but I also don't want to introduce all these local variables and
> change a branch in order to find out several months down the line that
> we introduced some TPC-C regression of .5%.

Agreed, I overdid it, v2 fix doesn't need the cleanup, I realized it
after I sent it out.

> 
> Look, I think this is all you need for the full fix:
> 
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 4720377..f66754e 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -639,8 +639,7 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
>  		 */
>  		create = dio->rw & WRITE;
>  		if (dio->flags & DIO_SKIP_HOLES) {
> -			if (sdio->block_in_file < (i_size_read(dio->inode) >>
> -							sdio->blkbits))
> +			if (fs_startblk < fs_count)
>  				create = 0;
>  		}
>  
>  
> Can you just test that?

I tested it and it did fix both of the issues for me. But it seems that
it's a bit overkilled, in certain case block allocation should be
allowed, but it still sets 'create' to 0.

For example, append writing 8k to a 4k sparse file (so offset is also
4k), on a 4k block size filesystem, fs_startblk(1) is smaller than
fs_count(2), so it still sets 'create' to 0. But block allocation should
be allowed in this case, and both the original code and my patch do so.

So I simplified my real fix to this (updates for comments not included):

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 4720377..0cace3e 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -639,8 +639,8 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
                 */
                create = dio->rw & WRITE;
                if (dio->flags & DIO_SKIP_HOLES) {
-                       if (sdio->block_in_file < (i_size_read(dio->inode) >>
-                                                       sdio->blkbits))
+                       if (fs_startblk <= ((i_size_read(dio->inode) - 1) >>
+                                                       i_blkbits))
                                create = 0;
                }
 

Do you think it's a proper fix?

Thanks again for your time!

Eryu
