From: Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: fallocate vs O_(D)SYNC
Date: Fri, 18 Nov 2011 12:09:36 +0000
Message-ID: <1321618176.2729.33.camel@menhir>
References: <20111116084256.GA22963@infradead.org>
	<1321436588.2713.5.camel@menhir> <20111116105413.GA2916@quack.suse.cz>
	<20111116124550.GA11650@infradead.org>
	<20111116133915.GD8195@quack.suse.cz>
	<20111116134234.GA24258@infradead.org>
	<20111116155755.GA22284@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20111116155755.GA22284@quack.suse.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

Hi,

Here is what I'm planning for GFS2:


Add sync of metadata after fallocate for O_SYNC files to ensure that we
meet expectations for everything being on disk in this case.
Unfortunately, the offset and len parameters are modified during the
course of the fallocate function, so I've had to add a couple of new
variables to call generic_write_sync() at the end.

I know that potentially this will sync data as well within the range,
but I think that is a fairly harmless side-effect overall, since we
would not normally expect there to be any dirty data within the range in
question.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Benjamin Marzinski <bmarzins@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 6336bc6..9b6c6ac 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -752,6 +752,8 @@ static long gfs2_fallocate(struct file *file, int mode, loff_t offset,
 	loff_t bytes, max_bytes;
 	struct gfs2_alloc *al;
 	int error;
+	const loff_t pos = offset;
+	const loff_t count = len;
 	loff_t bsize_mask = ~((loff_t)sdp->sd_sb.sb_bsize - 1);
 	loff_t next = (offset + len - 1) >> sdp->sd_sb.sb_bsize_shift;
 	loff_t max_chunk_size = UINT_MAX & bsize_mask;
@@ -834,6 +836,9 @@ retry:
 		gfs2_quota_unlock(ip);
 		gfs2_alloc_put(ip);
 	}
+
+	if (error == 0)
+		error = generic_write_sync(file, pos, count);
 	goto out_unlock;
 
 out_trans_fail:
