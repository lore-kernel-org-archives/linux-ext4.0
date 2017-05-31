From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/28] ext4: extended attribute value size
 limit is enforced by vfs
Date: Wed, 31 May 2017 09:03:53 -0700
Message-ID: <20170531160353.GH4510@birch.djwong.org>
References: <20170531081517.11438-1-tahsin@google.com>
	<20170531081517.11438-9-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Deepa Dinamani <deepa.kernel@gmail.com>, Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        Jens Axboe <axboe@fb.com>, linux-fsdevel@vger.kernel.org,
        Mike Christie <mchristi@redhat.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>,
        Fabian Frederick <fabf@skynet.be>, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
Content-Disposition: inline
In-Reply-To: <20170531081517.11438-9-tahsin@google.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

On Wed, May 31, 2017 at 01:14:58AM -0700, Tahsin Erdogan wrote:
> EXT4_XATTR_MAX_LARGE_EA_SIZE definition in ext4 is currently unused.
> Besides, vfs enforces its own 64k limit which makes the 1MB limit in
> ext4 redundant. Remove it.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> ---
>  fs/ext4/ext4.h | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 5d5fc0d0e2bc..2cdd6070e348 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2221,12 +2221,6 @@ struct mmpd_data {
>  #define EXT4_MMP_MAX_CHECK_INTERVAL	300UL
>  
>  /*
> - * Maximum size of xattr attributes for FEATURE_INCOMPAT_EA_INODE 1Mb
> - * This limit is arbitrary, but is reasonable for the xattr API.
> - */
> -#define EXT4_XATTR_MAX_LARGE_EA_SIZE    (1024 * 1024)

Uhhh... didn't you add this in patch 1/28?  There's little point in
adding a symbol just to delete it shortly thereafter.

--D

> -
> -/*
>   * Function prototypes
>   */
>  
> -- 
> 2.13.0.219.gdb65acc882-goog
> 
