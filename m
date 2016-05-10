From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2 1/2] direct-io: cleanup get_more_blocks()
Date: Tue, 10 May 2016 13:38:05 -0400
Message-ID: <x49y47h6cg2.fsf@segfault.boston.devel.redhat.com>
References: <1462645910-23290-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1462645910-23290-1-git-send-email-guaneryu@gmail.com> (Eryu
	Guan's message of "Sun, 8 May 2016 02:31:49 +0800")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eryu Guan <guaneryu@gmail.com> writes:

> Save one level of indention by returning error early.
>
> Introduce some local variables to make the code easier to read a bit,
> and do preparation for next patch.
>
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

Hi, Eryu,

I don't think you have a full appreciation of the amount of optimization
that goes into this code.  I don't see anything wrong with what you've
done, but I also don't want to introduce all these local variables and
change a branch in order to find out several months down the line that
we introduced some TPC-C regression of .5%.

Look, I think this is all you need for the full fix:

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 4720377..f66754e 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -639,8 +639,7 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
 		 */
 		create = dio->rw & WRITE;
 		if (dio->flags & DIO_SKIP_HOLES) {
-			if (sdio->block_in_file < (i_size_read(dio->inode) >>
-							sdio->blkbits))
+			if (fs_startblk < fs_count)
 				create = 0;
 		}
 
 
Can you just test that?

Thanks,
Jeff
