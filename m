From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: Re: [Jfs-discussion] [PATCH v2 4/5] jfs: cache NULL when
 both default_acl and acl are NULL
Date: Mon, 3 Sep 2018 15:34:36 -0500
Message-ID: <0e37733e-9acd-cf82-62f7-420f0fa864eb@oracle.com>
References: <20180831143352.22970-1-cgxu519@gmx.com>
 <20180831143352.22970-4-cgxu519@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, devel@lists.orangefs.org,
 linux-f2fs-devel@lists.sourceforge.net
To: Chengguang Xu <cgxu519@gmx.com>, jack@suse.com, tytso@mit.edu,
 adilger.kernel@dilger.ca, jaegeuk@kernel.org, yuchao0@huawei.com,
 shaggy@kernel.org, hubcap@omnibond.com, martin@omnibond.com
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20180831143352.22970-4-cgxu519@gmx.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

Are you pushing these as a series, or would you like this patch pushed
through the jfs tree?

On 8/31/18 9:33 AM, Chengguang Xu wrote:
> default_acl and acl of newly created inode will be initiated
> as ACL_NOT_CACHED in vfs function inode_init_always() and later
> will be updated by calling xxx_init_acl() in specific filesystems.
> Howerver, when default_acl and acl are NULL then they keep the value
> of ACL_NOT_CACHED, this patch tries to cache NULL for acl/default_acl
> in this case.
> 
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>

Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>

> ---
> v1->v2:
> - Coding style change.
> 
>  fs/jfs/acl.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/jfs/acl.c b/fs/jfs/acl.c
> index 2e71b6e7e646..8c06a6ea862d 100644
> --- a/fs/jfs/acl.c
> +++ b/fs/jfs/acl.c
> @@ -146,12 +146,16 @@ int jfs_init_acl(tid_t tid, struct inode *inode, struct inode *dir)
>  	if (default_acl) {
>  		rc = __jfs_set_acl(tid, inode, ACL_TYPE_DEFAULT, default_acl);
>  		posix_acl_release(default_acl);
> +	} else {
> +		inode->i_default_acl = NULL;
>  	}
>  
>  	if (acl) {
>  		if (!rc)
>  			rc = __jfs_set_acl(tid, inode, ACL_TYPE_ACCESS, acl);
>  		posix_acl_release(acl);
> +	} else {
> +		inode->i_acl = NULL;
>  	}
>  
>  	JFS_IP(inode)->mode2 = (JFS_IP(inode)->mode2 & 0xffff0000) |
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
