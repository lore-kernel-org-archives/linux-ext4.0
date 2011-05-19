From: Tristan Ye <tristan.ye@oracle.com>
Subject: Re: [PATCH] ocfs2: Implement llseek()
Date: Thu, 19 May 2011 17:13:48 +0800
Message-ID: <4DD4DF4C.501@oracle.com>
References: <1305773084-19296-1-git-send-email-sunil.mushran@oracle.com>
	<1305773084-19296-3-git-send-email-sunil.mushran@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, josef@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, viro@ZenIV.linux.org.uk
To: Sunil Mushran <sunil.mushran@oracle.com>
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
In-Reply-To: <1305773084-19296-3-git-send-email-sunil.mushran@oracle.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

Sunil Mushran wrote:
> ocfs2 implements its own llseek() to provide the SEEK_HOLE/SEEK_DATA
> functionality.
> 
> SEEK_HOLE sets the file pointer to the start of either a hole or an unwritten
> (preallocated) extent, that is greater than or equal to the supplied offset.
> 
> SEEK_DATA sets the file pointer to the start of an allocated extent (not
> unwritten) that is greater than or equal to the supplied offset.
> 
> If the supplied offset is on a desired region, then the file pointer is set
> to it. Offsets greater than or equal to the file size return -ENXIO.
> 
> Unwritten (preallocated) extents are considered holes because the file system
> treats reads to such regions in the same way as it does to holes.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/extent_map.c |   97 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ocfs2/extent_map.h |    2 +
>  fs/ocfs2/file.c       |   53 ++++++++++++++++++++++++++-
>  3 files changed, 150 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index 23457b4..6942c21 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -832,6 +832,103 @@ out:
>  	return ret;
>  }
>  
> +int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int origin)
> +{
> +	struct inode *inode = file->f_mapping->host;
> +	int ret;
> +	unsigned int is_last = 0, is_data = 0;
> +	u16 cs_bits = OCFS2_SB(inode->i_sb)->s_clustersize_bits;
> +	u32 cpos, cend, clen, hole_size;
> +	u64 extoff, extlen;
> +	struct buffer_head *di_bh = NULL;
> +	struct ocfs2_extent_rec rec;
> +
> +	BUG_ON(origin != SEEK_DATA && origin != SEEK_HOLE);
> +
> +	ret = ocfs2_inode_lock(inode, &di_bh, 0);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	down_read(&OCFS2_I(inode)->ip_alloc_sem);
> +
> +	if (inode->i_size == 0 || *offset >= inode->i_size) {
> +		ret = -ENXIO;
> +		goto out_unlock;
> +	}

Why not using if (*offset >= inode->i_size) directly?

> +
> +	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
> +		if (origin == SEEK_HOLE)
> +			*offset = inode->i_size;
> +		goto out_unlock;
> +	}
> +
> +	clen = 0;
> +	cpos = *offset >> cs_bits;
> +	cend = ocfs2_clusters_for_bytes(inode->i_sb, inode->i_size);
> +
> +	while (cpos < cend && !is_last) {
> +		ret = ocfs2_get_clusters_nocache(inode, di_bh, cpos, &hole_size,
> +						 &rec, &is_last);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out_unlock;
> +		}
> +
> +		extoff = cpos;
> +		extoff <<= cs_bits;
> +
> +		if (rec.e_blkno == 0ULL) {
> +			clen = hole_size;
> +			is_data = 0;
> +		} else {
> +			BUG_ON(cpos < le32_to_cpu(rec.e_cpos));


A same assert has already been performed inside ocfs2_get_clusters_nocache(),
does it make sense to do it again here?


> +			clen = le16_to_cpu(rec.e_leaf_clusters) -
> +				(cpos - le32_to_cpu(rec.e_cpos));
> +			is_data = (rec.e_flags & OCFS2_EXT_UNWRITTEN) ?  0 : 1;
> +		}
> +
> +		if ((!is_data && origin == SEEK_HOLE) ||
> +		    (is_data && origin == SEEK_DATA)) {
> +			if (extoff > *offset)
> +				*offset = extoff;
> +			goto out_unlock;

Seems above logic is going to stop at the first time we find a hole.

How about the offset was within the range of a hole already when we doing
SEEK_HOLE, shouldn't we proceed detecting until the next hole gets found, whose
start_offset was greater than supplied offset, according to semantics described
by the the header of this patch, should it be like following?

			if (extoff > *offset) {
				*offset = extoff;
				goto out_unlock;
			}

> +		}
> +
> +		if (!is_last)
> +			cpos += clen;
> +	}
> +
> +	if (origin == SEEK_HOLE) {
> +		extoff = cpos;
> +		extoff <<= cs_bits;

extoff already has been assigned properly above in while loop?

> +		extlen = clen;
> +		extlen <<=  cs_bits;
> +
> +		if ((extoff + extlen) > inode->i_size)
> +			extlen = inode->i_size - extoff;
> +		extoff += extlen;
> +		if (extoff > *offset)
> +			*offset = extoff;
> +		goto out_unlock;
> +	}
> +
> +	ret = -ENXIO;
> +
> +out_unlock:
> +
> +	brelse(di_bh);
> +
> +	up_read(&OCFS2_I(inode)->ip_alloc_sem);
> +
> +	ocfs2_inode_unlock(inode, 0);
> +out:
> +	if (ret && ret != -ENXIO)
> +		ret = -ENXIO;
> +	return ret;
> +}
> +
>  int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
>  			   struct buffer_head *bhs[], int flags,
>  			   int (*validate)(struct super_block *sb,
> diff --git a/fs/ocfs2/extent_map.h b/fs/ocfs2/extent_map.h
> index e79d41c..67ea57d 100644
> --- a/fs/ocfs2/extent_map.h
> +++ b/fs/ocfs2/extent_map.h
> @@ -53,6 +53,8 @@ int ocfs2_extent_map_get_blocks(struct inode *inode, u64 v_blkno, u64 *p_blkno,
>  int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  		 u64 map_start, u64 map_len);
>  
> +int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int origin);
> +
>  int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
>  			     u32 *p_cluster, u32 *num_clusters,
>  			     struct ocfs2_extent_list *el,
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index cce8c2b..5349a4b 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2572,6 +2572,55 @@ bail:
>  	return ret;
>  }
>  
> +/* Refer generic_file_llseek_unlocked() */
> +static loff_t ocfs2_file_llseek(struct file *file, loff_t offset, int origin)
> +{
> +	struct inode *inode = file->f_mapping->host;
> +	int ret = 0;
> +
> +	mutex_lock(&inode->i_mutex);
> +
> +	switch (origin) {
> +	case SEEK_END:
> +		offset += inode->i_size;
> +		break;
> +	case SEEK_CUR:
> +		if (offset == 0) {
> +			offset = file->f_pos;
> +			goto out;
> +		}
> +		offset += file->f_pos;
> +		break;
> +	case SEEK_DATA:
> +	case SEEK_HOLE:
> +		ret = ocfs2_seek_data_hole_offset(file, &offset, origin);
> +		if (ret)
> +			goto out;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET))
> +		ret = -EINVAL;
> +	if (!ret && offset > inode->i_sb->s_maxbytes)
> +		ret = -EINVAL;
> +	if (ret)
> +		goto out;
> +
> +	if (offset != file->f_pos) {
> +		file->f_pos = offset;
> +		file->f_version = 0;
> +	}
> +
> +out:
> +	mutex_unlock(&inode->i_mutex);
> +	if (ret)
> +		return ret;
> +	return offset;
> +}
> +
>  const struct inode_operations ocfs2_file_iops = {
>  	.setattr	= ocfs2_setattr,
>  	.getattr	= ocfs2_getattr,
> @@ -2594,7 +2643,7 @@ const struct inode_operations ocfs2_special_file_iops = {
>   * ocfs2_fops_no_plocks and ocfs2_dops_no_plocks!
>   */
>  const struct file_operations ocfs2_fops = {
> -	.llseek		= generic_file_llseek,
> +	.llseek		= ocfs2_file_llseek,
>  	.read		= do_sync_read,
>  	.write		= do_sync_write,
>  	.mmap		= ocfs2_mmap,
> @@ -2642,7 +2691,7 @@ const struct file_operations ocfs2_dops = {
>   * the cluster.
>   */
>  const struct file_operations ocfs2_fops_no_plocks = {
> -	.llseek		= generic_file_llseek,
> +	.llseek		= ocfs2_file_llseek,
>  	.read		= do_sync_read,
>  	.write		= do_sync_write,
>  	.mmap		= ocfs2_mmap,
