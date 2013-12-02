From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: Re: [Jfs-discussion] [PATCH 15/18] jfs: use generic posix ACL
	infrastructure
Date: Mon, 02 Dec 2013 16:11:55 -0600
Message-ID: <529D05AB.7080306@oracle.com>
References: <20131201115903.910559036@bombadil.infradead.org>
	<20131201120656.391407780@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org,
	Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
	linux-mtd@lists.infradead.org, Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20131201120656.391407780@bombadil.infradead.org>
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

On 12/01/2013 05:59 AM, Christoph Hellwig wrote:
> Copy the scheme I introduced to btrfs many years ago to only use the
> xattr handler for ACLs, but pass plain attrs straight through.

Looks good.

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Kleikamp <dave.kleikamp@oracle.com>

> ---
>  fs/jfs/acl.c       |  105 ++++++++++++++++++++------------------------------
>  fs/jfs/file.c      |    4 +-
>  fs/jfs/jfs_acl.h   |    7 +---
>  fs/jfs/jfs_xattr.h |    2 +
>  fs/jfs/namei.c     |    1 +
>  fs/jfs/super.c     |    2 +
>  fs/jfs/xattr.c     |  108 ++++++++++++++++++----------------------------------
>  7 files changed, 89 insertions(+), 140 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
