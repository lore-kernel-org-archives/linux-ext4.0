From: Sandeep K Sinha <sandeepksinha@gmail.com>
Subject: Re: [ext2/ext3] Re-allocation of blocks for an inode
Date: Thu, 12 Mar 2009 23:29:04 +0530
Message-ID: <37d33d830903121059i3a4a262by2ee0c3bcf77dd04d@mail.gmail.com>
References: <37d33d830903120816t3a0268e8o803bd1acbc0bee47@mail.gmail.com>
	 <87f94c370903120913p6ec23c84pdff404c0e207b56f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Kernel Newbies <kernelnewbies@nl.linux.org>,
	Manish Katiyar <mkatiyar@gmail.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:40023 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122AbZCLR7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Mar 2009 13:59:09 -0400
Received: by wa-out-1112.google.com with SMTP id v33so651246wah.21
        for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2009 10:59:04 -0700 (PDT)
In-Reply-To: <87f94c370903120913p6ec23c84pdff404c0e207b56f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 12, 2009 at 9:43 PM, Greg Freemyer <greg.freemyer@gmail.com=
> wrote:
> On Thu, Mar 12, 2009 at 11:16 AM, Sandeep K Sinha
> <sandeepksinha@gmail.com> wrote:
>> Hi all,
>>
>> I am listing above two codes for re-allocating new blocks for a give=
n inode.
>>
>> These code snippets are specific to =A0ext2.
>> The problem here is that it is performing slower than cp and dd.
>>
>> Can anyone help in determining what can be the possible reason(s) ?
>
> Excessive use of sync_dirty_buffer();
>
> You're calling it for every single block you copy. Pretty sure it is =
a
> very aggressive call that forces the data out to the disk immediately=
,
> thus the benefits of caching and elevators are lost. =A0And those are
> big benefits.
>

probably the reason being that the ext2 has some issues with sync.
http://kerneltrap.org/index.php?q=3Dmailarchive/linux-fsdevel/2007/2/14=
/316836/thread

Hence, if we don't do this we see a difference in the original and
reallocated file.



> Greg
>
>
>>
>> 1. MEMCPY
>> =3D=3D=3D=3D=3D=3D=3D
>>
>>
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0src_ind =3D ext2_iget (sb, inum);
>> =A0 =A0 =A0 =A0if (!src_ind) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk (KERN_DEBUG "\n OHSM Source In=
ode Not Found ");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_err;
>> =A0 =A0 =A0 =A0}
>>
>> =A0 =A0 =A0 =A0/* Getting the ghost inode */
>> =A0 =A0 =A0 =A0dest_ind =3D ext2_new_inode (nd.path.dentry->d_inode,=
 src_ind->i_mode);
>> =A0 =A0 =A0 =A0if (IS_ERR(dest_ind)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk (KERN_ALERT "\n OHSM destinati=
on inode unable to allocate.
>> err =3D %ld", PTR_ERR(dest_ind));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_err;
>> =A0 =A0 =A0 =A0}
>>
>> =A0 =A0 =A0 =A0/* Locking the source inode using mutex */
>> =A0 =A0 =A0 =A0mutex_lock (&src_ind->i_mutex);
>>
>> =A0 =A0 =A0 =A0/* Get the source inode size and number of blocks */
>> =A0 =A0 =A0 =A0i_size =3D i_size_read(src_ind);
>>
>> =A0 =A0 =A0 =A0/* Calculating number of block to allocate for ghost =
inode */
>> =A0 =A0 =A0 =A0nblocks =3D (i_size >> EXT2_BLOCK_SIZE_BITS(sb)) +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((i_size & (sb->s_blocksize - 1)=
) ? 1 : 0);
>>
>> =A0 =A0 =A0 =A0memset(&dest_bh, 0, sizeof(struct buffer_head));
>> =A0 =A0 =A0 =A0memset(&src_bh, 0, sizeof(struct buffer_head));
>> =A0 =A0 =A0 =A0for (done =3D 0; done < nblocks; done++) {
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext2_get_block (src_ind, done, &src_=
bh, 0);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err < 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk (KERN_DEBUG "\=
n error getting blocks ret_val =3D %d",err);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto unlock;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dest_bh.b_state =3D 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ext2_get_block (dest_ind, don=
e, &dest_bh, 1);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err < 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk (KERN_DEBUG "\=
n error getting blocks ret_val =3D %d",err);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto unlock;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!buffer_mapped(&src_bh)){
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk (KERN_DEBUG "\=
nHOLE ");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0src_bhptr =3D sb_bread(sb, src_bh.b_b=
locknr);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!src_bhptr)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto unlock;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dst_bhptr =3D sb_bread(sb, dest_bh.b_=
blocknr);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!dst_bhptr)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto unlock;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lock_buffer(dst_bhptr);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy(dst_bhptr->b_data,src_bhptr->b=
_data,src_bhptr->b_size);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unlock_buffer(dst_bhptr);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mark_buffer_dirty(dst_bhptr);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sync_dirty_buffer(dst_bhptr);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0brelse(src_bhptr);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0brelse(dst_bhptr);
>>
>> =A0 =A0 =A0 =A0}
>>
>> =A0 =A0 =A0 =A0for (blk_index =3D 0; blk_index < 15; blk_index++) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (EXT2_I (dest_ind)->i_data[blk_ind=
ex]){
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0swap =3D EXT2_I (src_=
ind)->i_data[blk_index];
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT2_I (src_ind)->i_d=
ata[blk_index] =3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT2_=
I (dest_ind)->i_data[blk_index];
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT2_I (dest_ind)->i_=
data[blk_index] =3D swap;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0}
>>
>> =A0 =A0 =A0 =A0dest_ind->i_blocks =3D src_ind->i_blocks ;
>> =A0 =A0 =A0 =A0mark_inode_dirty (src_ind);
>> =A0 =A0 =A0 =A0sync_mapping_buffers(src_ind->i_mapping);
>> =A0 =A0 =A0 =A0ohsm_sync_inode(src_ind);
>> =A0 =A0 =A0 =A0iput(src_ind);
>>
>> =A0 =A0 =A0 =A0dest_ind->i_nlink =3D 0;
>> =A0 =A0 =A0 =A0iput(dest_ind);
>> =A0 =A0 =A0 =A0mutex_unlock (&src_ind->i_mutex);
>> =A0 =A0 =A0 =A0goto out_err;
>>
>> unlock:
>> =A0 =A0 =A0 =A0brelse(src_bhptr);
>> =A0 =A0 =A0 =A0brelse(dst_bhptr);
>> =A0 =A0 =A0 =A0mutex_unlock (&src_ind->i_mutex);
>>
>> out_err:
>> =A0 =A0 =A0 =A0path_put (&nd.path);
>> =A0 =A0 =A0 =A0return;
>>
>>
>>
>> 2. PAGEFLIP
>> =3D=3D=3D=3D=3D=3D=3D=3D
>>
>>
>> /* Get the source inode */
>>
>> =A0 =A0 =A0 =A0src_ind =3D ext2_iget (sb, inum);
>> =A0 =A0 =A0 =A0if (!src_ind) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk (KERN_DEBUG "\n OHSM Source In=
ode Not Found ");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_err;
>> =A0 =A0 =A0 =A0}
>>
>> =A0 =A0 =A0 =A0/* Getting the ghost inode */
>> =A0 =A0 =A0 =A0dest_ind =3D ext2_new_inode (nd.path.dentry->d_inode,=
 src_ind->i_mode);
>> =A0 =A0 =A0 =A0if (IS_ERR(dest_ind)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk (KERN_ALERT "\n destination in=
ode unable to allocate. err =3D
>> %ld", PTR_ERR(dest_ind));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_err;
>> =A0 =A0 =A0 =A0}
>>
>> =A0 =A0 =A0 =A0/* Locking the source inode using mutex */
>> =A0 =A0 =A0 =A0mutex_lock (&src_ind->i_mutex);
>>
>> =A0 =A0 =A0 =A0/* Get the source inode size and number of blocks */
>> =A0 =A0 =A0 =A0i_size =3D i_size_read(src_ind);
>>
>> =A0 =A0 =A0 =A0/* Calculating number of block to allocate for ghost =
inode */
>> =A0 =A0 =A0 =A0nblocks =3D (i_size >> EXT2_BLOCK_SIZE_BITS(sb)) +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((i_size & (sb->s_blocksize - 1)=
) ? 1 : 0);
>>
>>
>> =A0 =A0 =A0 =A0memset(&dest_bh, 0, sizeof(struct buffer_head));
>> =A0 =A0 =A0 =A0memset(&src_bh, 0, sizeof(struct buffer_head));
>> =A0 =A0 =A0 =A0for (done =3D 0; done < nblocks; done++) {
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext2_get_block (src_ind, done, &src_=
bh, 0);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err < 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk (KERN_DEBUG "\=
n error getting blocks ret_val =3D %d",err);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto unlock;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dest_bh.b_state =3D 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ext2_get_block (dest_ind, don=
e, &dest_bh, 1);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err < 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk (KERN_DEBUG "\=
n error getting blocks ret_val =3D %d",err);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto unlock;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!buffer_mapped(&src_bh)){
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk (KERN_DEBUG "\=
nHOLE ");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0src_bhptr =3D sb_bread(sb, src_bh.b_b=
locknr);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!src_bhptr)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto unlock;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dst_bhptr =3D sb_bread(sb, dest_bh.b_=
blocknr);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!dst_bhptr)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto unlock;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 lock_buffer(dst_bhptr);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 oldpage =3D dst_bhptr->b_page;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 olddata =3D dst_bhptr->b_data;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 dst_bhptr->b_data =3D src_bhptr->b_data;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 dst_bhptr->b_page =3D src_bhptr->b_page;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flush_dcache_page(dst_bhptr->b_page);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 unlock_buffer(dst_bhptr);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mark_buffer_dirty(dst_bhptr);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sync_dirty_buffer(dst_bhptr);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(buffer_uptodate(dst_bhptr)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dst_bhptr->b_page =A0=3D oldpage;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dst_bhptr->b_data =3D olddata;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 brelse(src_bhptr);
>> =A0 =A0 =A0 =A0 =A0 =A0 brelse(dst_bhptr);
>> =A0 =A0 =A0 =A0}
>>
>> =A0 =A0 =A0 =A0for (blk_index =3D 0; blk_index < 15; blk_index++) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (EXT2_I (dest_ind)->i_data[blk_ind=
ex]){
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0swap =3D EXT2_I (src_=
ind)->i_data[blk_index];
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT2_I (src_ind)->i_d=
ata[blk_index] =3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT2_=
I (dest_ind)->i_data[blk_index];
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT2_I (dest_ind)->i_=
data[blk_index] =3D swap;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0}
>>
>> =A0 =A0 =A0 =A0dest_ind->i_blocks =3D src_ind->i_blocks ;
>> =A0 =A0 =A0 =A0mark_inode_dirty (src_ind);
>> =A0 =A0 =A0 =A0sync_mapping_buffers(src_ind->i_mapping);
>> =A0 =A0 =A0 =A0ohsm_sync_inode(src_ind);
>> =A0 =A0 =A0 =A0iput(src_ind);
>>
>> =A0 =A0 =A0 =A0dest_ind->i_nlink =3D 0;
>> =A0 =A0 =A0 =A0iput(dest_ind);
>> =A0 =A0 =A0 =A0mutex_unlock (&src_ind->i_mutex);
>> =A0 =A0 =A0 =A0goto out_err;
>>
>> unlock:
>> =A0 =A0 =A0 =A0brelse(src_bhptr);
>> =A0 =A0 =A0 =A0brelse(dst_bhptr);
>> =A0 =A0 =A0 =A0mutex_unlock (&src_ind->i_mutex);
>>
>> out_err:
>> =A0 =A0 =A0 =A0path_put (&nd.path);
>> =A0 =A0 =A0 =A0return;
>> }
>>
>>
>>
>> --
>> Regards,
>> Sandeep.
>>
>>
>>
>>
>>
>>
>> =93To learn is to change. Education is a process that changes the le=
arner.=94
>>
>
>
>
> --
> Greg Freemyer
> Litigation Triage Solutions Specialist
> http://www.linkedin.com/in/gregfreemyer
> First 99 Days Litigation White Paper -
> http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper=
=2Epdf
>
> The Norcross Group
> The Intersection of Evidence & Technology
> http://www.norcrossgroup.com
>



--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
