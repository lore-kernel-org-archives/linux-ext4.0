From: Sandeep K Sinha <sandeepksinha@gmail.com>
Subject: [ext2/ext3] Re-allocation of blocks for an inode
Date: Thu, 12 Mar 2009 20:46:24 +0530
Message-ID: <37d33d830903120816t3a0268e8o803bd1acbc0bee47@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
Cc: Manish Katiyar <mkatiyar@gmail.com>, Greg Freemyer <greg.freemyer@gmail.com>
To: ext4 <linux-ext4@vger.kernel.org>, Kernel Newbies <kernelnewbies@nl.linux.org>
Return-path: <kernelnewbies-bounce@nl.linux.org>
Sender: kernelnewbies-bounce@nl.linux.org
Errors-to: kernelnewbies-bounce@nl.linux.org
List-help: <mailto:ecartis@nl.linux.org?Subject=help>
List-unsubscribe: <mailto:kernelnewbies-request@nl.linux.org?Subject=unsubscribe>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:kernelnewbies-request@nl.linux.org?Subject=subscribe>
List-owner: <mailto:ecartis-owner@nl.linux.org>
List-post: <mailto:kernelnewbies@nl.linux.org>
List-archive: <http://mail.nl.linux.org/kernelnewbies/>
List-Id: linux-ext4.vger.kernel.org

Hi all,

I am listing above two codes for re-allocating new blocks for a given inode=
.

These code snippets are specific to  ext2.
The problem here is that it is performing slower than cp and dd.

Can anyone help in determining what can be the possible reason(s) ?


1. MEMCPY
=3D=3D=3D=3D=3D=3D=3D



                src_ind =3D ext2_iget (sb, inum);
	if (!src_ind) {
		printk (KERN_DEBUG "\n OHSM Source Inode Not Found ");
		goto out_err;
	}

	/* Getting the ghost inode */
	dest_ind =3D ext2_new_inode (nd.path.dentry->d_inode, src_ind->i_mode);
	if (IS_ERR(dest_ind)) {
		printk (KERN_ALERT "\n OHSM destination inode unable to allocate.
err =3D %ld", PTR_ERR(dest_ind));
		goto out_err;
	}

	/* Locking the source inode using mutex */
	mutex_lock (&src_ind->i_mutex);

	/* Get the source inode size and number of blocks */
	i_size =3D i_size_read(src_ind);
=09
	/* Calculating number of block to allocate for ghost inode */
	nblocks =3D (i_size >> EXT2_BLOCK_SIZE_BITS(sb)) +
		   ((i_size & (sb->s_blocksize - 1)) ? 1 : 0);

	memset(&dest_bh, 0, sizeof(struct buffer_head));
	memset(&src_bh, 0, sizeof(struct buffer_head));
	for (done =3D 0; done < nblocks; done++) {

             err =3D ext2_get_block (src_ind, done, &src_bh, 0);
		if (err < 0) {
			printk (KERN_DEBUG "\n error getting blocks ret_val =3D %d",err);
			goto unlock;
		}

		dest_bh.b_state =3D 0;
		err =3D ext2_get_block (dest_ind, done, &dest_bh, 1);
		if (err < 0) {
			printk (KERN_DEBUG "\n error getting blocks ret_val =3D %d",err);
			goto unlock;
		}

		if (!buffer_mapped(&src_bh)){
			printk (KERN_DEBUG "\nHOLE ");
			continue;
		}

		src_bhptr =3D sb_bread(sb, src_bh.b_blocknr);
		if (!src_bhptr)
			goto unlock;

		dst_bhptr =3D sb_bread(sb, dest_bh.b_blocknr);
		if (!dst_bhptr)
			goto unlock;

		lock_buffer(dst_bhptr);
		memcpy(dst_bhptr->b_data,src_bhptr->b_data,src_bhptr->b_size);
		unlock_buffer(dst_bhptr);
	=09
		mark_buffer_dirty(dst_bhptr);
		sync_dirty_buffer(dst_bhptr);

		brelse(src_bhptr);
		brelse(dst_bhptr);

	}

	for (blk_index =3D 0; blk_index < 15; blk_index++) {
		if (EXT2_I (dest_ind)->i_data[blk_index]){
			swap =3D EXT2_I (src_ind)->i_data[blk_index];
			EXT2_I (src_ind)->i_data[blk_index] =3D
				EXT2_I (dest_ind)->i_data[blk_index];
			EXT2_I (dest_ind)->i_data[blk_index] =3D swap;
		}
	}

	dest_ind->i_blocks =3D src_ind->i_blocks ;
	mark_inode_dirty (src_ind);
	sync_mapping_buffers(src_ind->i_mapping);
	ohsm_sync_inode(src_ind);
	iput(src_ind);
=09
	dest_ind->i_nlink =3D 0;
	iput(dest_ind);
	mutex_unlock (&src_ind->i_mutex);
	goto out_err;

unlock:
	brelse(src_bhptr);
	brelse(dst_bhptr);
	mutex_unlock (&src_ind->i_mutex);

out_err:
	path_put (&nd.path);
	return;



2. PAGEFLIP
=3D=3D=3D=3D=3D=3D=3D=3D


/* Get the source inode */
=09
	src_ind =3D ext2_iget (sb, inum);
	if (!src_ind) {
		printk (KERN_DEBUG "\n OHSM Source Inode Not Found ");
		goto out_err;
	}

	/* Getting the ghost inode */
	dest_ind =3D ext2_new_inode (nd.path.dentry->d_inode, src_ind->i_mode);
	if (IS_ERR(dest_ind)) {
		printk (KERN_ALERT "\n destination inode unable to allocate. err =3D
%ld", PTR_ERR(dest_ind));
		goto out_err;
	}

	/* Locking the source inode using mutex */
	mutex_lock (&src_ind->i_mutex);

	/* Get the source inode size and number of blocks */
	i_size =3D i_size_read(src_ind);
=09
	/* Calculating number of block to allocate for ghost inode */
	nblocks =3D (i_size >> EXT2_BLOCK_SIZE_BITS(sb)) +
		   ((i_size & (sb->s_blocksize - 1)) ? 1 : 0);

=09
	memset(&dest_bh, 0, sizeof(struct buffer_head));
	memset(&src_bh, 0, sizeof(struct buffer_head));
	for (done =3D 0; done < nblocks; done++) {

             err =3D ext2_get_block (src_ind, done, &src_bh, 0);
		if (err < 0) {
			printk (KERN_DEBUG "\n error getting blocks ret_val =3D %d",err);
			goto unlock;
		}

		dest_bh.b_state =3D 0;
		err =3D ext2_get_block (dest_ind, done, &dest_bh, 1);
		if (err < 0) {
			printk (KERN_DEBUG "\n error getting blocks ret_val =3D %d",err);
			goto unlock;
		}

		if (!buffer_mapped(&src_bh)){
			printk (KERN_DEBUG "\nHOLE ");
			continue;
		}

		src_bhptr =3D sb_bread(sb, src_bh.b_blocknr);
		if (!src_bhptr)
			goto unlock;

		dst_bhptr =3D sb_bread(sb, dest_bh.b_blocknr);
		if (!dst_bhptr)
			goto unlock;

               lock_buffer(dst_bhptr);
               oldpage =3D dst_bhptr->b_page;
               olddata =3D dst_bhptr->b_data;
               dst_bhptr->b_data =3D src_bhptr->b_data;
               dst_bhptr->b_page =3D src_bhptr->b_page;
               flush_dcache_page(dst_bhptr->b_page);
               unlock_buffer(dst_bhptr);

               mark_buffer_dirty(dst_bhptr);
               sync_dirty_buffer(dst_bhptr);

               if(buffer_uptodate(dst_bhptr)) {
                dst_bhptr->b_page  =3D oldpage;
                dst_bhptr->b_data =3D olddata;
               }

             brelse(src_bhptr);
             brelse(dst_bhptr);
	}

	for (blk_index =3D 0; blk_index < 15; blk_index++) {
		if (EXT2_I (dest_ind)->i_data[blk_index]){
			swap =3D EXT2_I (src_ind)->i_data[blk_index];
			EXT2_I (src_ind)->i_data[blk_index] =3D
				EXT2_I (dest_ind)->i_data[blk_index];
			EXT2_I (dest_ind)->i_data[blk_index] =3D swap;
		}
	}

	dest_ind->i_blocks =3D src_ind->i_blocks ;
	mark_inode_dirty (src_ind);
	sync_mapping_buffers(src_ind->i_mapping);
	ohsm_sync_inode(src_ind);
	iput(src_ind);
=09
	dest_ind->i_nlink =3D 0;
	iput(dest_ind);
	mutex_unlock (&src_ind->i_mutex);
	goto out_err;

unlock:
	brelse(src_bhptr);
	brelse(dst_bhptr);
	mutex_unlock (&src_ind->i_mutex);

out_err:
	path_put (&nd.path);
	return;
}



--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learner.=
=94

--
To unsubscribe from this list: send an email with
"unsubscribe kernelnewbies" to ecartis@nl.linux.org
Please read the FAQ at http://kernelnewbies.org/FAQ
