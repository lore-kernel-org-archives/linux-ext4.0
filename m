From: Christoph Hellwig <hch@lst.de>
Subject: VFS/XFS: directio updates to ease COW handling
Date: Tue,  2 Feb 2016 21:17:34 +0100
Message-ID: <1454444257-9086-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: darrick.wong@oracle.com
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
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

The first patch ensures ->end_io is always called for direct I/O requests
that pass it in, even if there was a zero length write, or if an error
occured.  The existing users have been updated to ignore it, but XFS
will make use of it in the future, and a comment in ext4 suggests it
might be useful for it as well.

The other two simplify the XFS direct I/O code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
