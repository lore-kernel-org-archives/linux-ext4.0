From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2 v3] Fix O_SYNC AIO DIO
Date: Wed,  4 Sep 2013 15:04:38 +0200
Message-ID: <1378299880-11103-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com,
	Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <xfs-bounces@oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

  Hello,

  this is the third iteration of patches to fix handling of O_SYNC AIO DIO.

Changes since v2:
 - moved call for destruction of workqueue closer to put_super

Changes since v1:
 - slightly expanded changelog of the first patch
 - workqueue is now created with parameters allowing paralelism
 - workqueue name contains sb->s_id
 - workqueue is created on demand (I decided to do this to reduce the overhead
   in unnecessary cases)

The patchset survives xfstests run for ext4 & xfs so it should be sane. Al,
please merge the patches (but I'd also appreciate if Dave or some other XFS
developers gave their ack to the patches since XFS changes are non-trivial).

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
