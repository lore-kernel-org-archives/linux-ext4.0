From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 0/1] iomap: Direct I/O for inline data
Date: Wed, 27 Jun 2018 02:39:05 +0200
Message-ID: <20180627003906.15571-1-agruenba@redhat.com>
Cc: cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <cluster-devel-bounces@redhat.com>
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

Here's a patch that implements direct I/O for inline data.  Direct I/O
to inline data is a bit weird because it's not direct in the usual
sense, but since Christoph's been asking for it ...

The usual alignment restrictions to the logical block size of the
underlying block device still apply.  I don't see a reason for changing
that; the resulting behavior would only become very weird for no
benefit.

I've tested this against a hacked-up version of gfs2.  However, the
"real" gfs2 will keep falling back to buffered I/O for writes to inline
data: gfs2 takes a shared lock during direct I/O, and writing to the
inode under that shared lock is not allowed.  Ext4 may become the first
actual user of this part of the patch.

Thanks,
Andreas

Andreas Gruenbacher (1):
  iomap: Direct I/O to inline data

 fs/iomap.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

-- 
2.17.1
