From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/28] ext4: call journal revoke when
 freeing ea_inode blocks
Date: Wed, 31 May 2017 09:12:57 -0700
Message-ID: <20170531161257.GI4510@birch.djwong.org>
References: <20170531081517.11438-1-tahsin@google.com>
	<20170531081517.11438-7-tahsin@google.com>
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
In-Reply-To: <20170531081517.11438-7-tahsin@google.com>
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

On Wed, May 31, 2017 at 01:14:56AM -0700, Tahsin Erdogan wrote:
> ea_inode contents are treated as metadata, that's why it is journaled
> during initial writes. Failing to call revoke during freeing could cause
> user data to be overwritten with original ea_inode contents during journal
> replay.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> ---
>  fs/ext4/extents.c  | 3 ++-
>  fs/ext4/indirect.c | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 3e36508610b7..e0a8425ff74d 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2488,7 +2488,8 @@ int ext4_ext_index_trans_blocks(struct inode *inode, int extents)
>  
>  static inline int get_default_free_blocks_flags(struct inode *inode)
>  {
> -	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
> +	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode) ||
> +	    ext4_test_inode_flag(inode, EXT4_INODE_EA_INODE))
>  		return EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET;
>  	else if (ext4_should_journal_data(inode))
>  		return EXT4_FREE_BLOCKS_FORGET;
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index bc15c2c17633..7ffa290cbb8e 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -829,7 +829,8 @@ static int ext4_clear_blocks(handle_t *handle, struct inode *inode,
>  	int	flags = EXT4_FREE_BLOCKS_VALIDATED;
>  	int	err;
>  
> -	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
> +	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode) ||
> +	    ext4_test_inode_flag(inode, EXT4_INODE_EA_INODE))

I appreciate the thoroughness of doing this even for blockmapped
ea_inode files, and I'm not complaining about this hunk at all. :)

However, please consider requiring the extents feature + format as a
prerequisite for ea_inodes.  ext4 has traditionally been very ...
permissive about supporting a diverse range of feature options, but the
cost of that diversity is that the feature support matrix that the
community has to support is already untestably large.

I think it would be wise not to support !extents && ea_inode,
particularly since blockmaps aren't protected by metadata_csum and so in
the long run it's probably best to minimize the introduction of new
blockmap files (on ext4 anyway).

--D

>  		flags |= EXT4_FREE_BLOCKS_FORGET | EXT4_FREE_BLOCKS_METADATA;
>  	else if (ext4_should_journal_data(inode))
>  		flags |= EXT4_FREE_BLOCKS_FORGET;
> -- 
> 2.13.0.219.gdb65acc882-goog
> 
