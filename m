From: "Pu Hou" <houpu.hp@alibaba-inc.com>
Subject: Re: [PATCH] debugfs: Add inline data feature for symlink.
Date: Tue, 05 Aug 2014 20:27:58 +0800
Message-ID: <20140805122758.GE2949@guyi-aliyun>
References: <1406789932-13770-1-git-send-email-houpu.hp@alibaba-inc.com>
 <63e6941e-70ab-4fec-941c-f13f47585594@alibaba-inc.com>
 <20140801164810.GT8628@birch.djwong.org>
 <20140804065341.GC6751@guyi-aliyun>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out113-251.biz.mail.alibaba.com ([205.204.113.251]:38065 "EHLO
	us-alimail-mta2.hst.scl.en.alidc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753114AbaHENAW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Aug 2014 09:00:22 -0400
Content-Disposition: inline
In-Reply-To: <20140804065341.GC6751@guyi-aliyun>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 04, 2014 at 02:53:41PM +0800, Pu Hou wrote:
> On Sat, Aug 02, 2014 at 12:48:10AM +0800, Darrick J. Wong wrote:
> > On Fri, Aug 01, 2014 at 06:37:56PM +0800, Pu Hou wrote:
> > > On Thu, Jul 31, 2014 at 02:58:52PM +0800, Pu Hou wrote:
> > > >> Symlink in debugfs can take advantage of inline data feature. The path name of the target of the symbol link which is longer than 60 byte and shorter than 132 byte can stay in inline data area.
> > > >
> > > >I think Ted prefers wrapping commit messages at 70 bytes.
> > > >
> > > Thanks for reminding me. I will fix it.
> > > 
> > > >> +	data.ea_size = size - EXT4_MIN_INLINE_DATA_SIZE;
> > > >> +	data.ea_data = buf + EXT4_MIN_INLINE_DATA_SIZE;
> > > >> +	return ext2fs_inline_data_ea_set(&data);
> > > >
> > > >Doesn't ext2fs_inline_data_set() suffice?
> > > >
> > > It is unnecessary to use this dedicated function.
> > 
> > Why do you say it's unnecessary?  The dedicated function does (or at least is
> > supposed to) do exactly what you want.
> > 
> 
> Compare with the dedicated function, ext2fs_inline_data_set() will check
> the available xattr size and inline data size by read the inode and do
> some calculation. And I thought some "dirty data" of an inode on disk might
> have an effect on the calculated available size.
> 
> Now I find that this concern is unnecessary. Because ext2fs_write_new_inode()
> which is called before will make sure the xattr of the inode are clean.
> So there is no need to use this dedicated function.
> 
> > Now I'm wondering -- why worry about size at all?  You can modify
> > ext2fs_symlink to call ext2fs_inline_data_set() directly.  If there's not
> > enough room, it'll return EXT2_ET_INLINE_DATA_NO_SPACE and you can try again
> > with the classic stuff-it-in-a-block method.
> > 
> > (Of course, if you try this and the API turns not to behave as advertised I'd
> > like to hear about that too. :))
> 
> That sounds nice. I will try in this way and give a feedback later.
>
I tried to call ext2fs_inline_data_set() from ext2fs_symlink. The result is
not as expected. Before it gets to "return EXT2_ET_INLINE_DATA_NO_SPACE",
ext2fs_inline_data_size() is called. In this function, it may return at here:

	if (!(inode.i_flags & EXT4_INLINE_DATA_FL))
		return EXT2_ET_NO_INLINE_DATA;

and the message was printed as below:

ext2fs_symlink: Inode doesn't have inline data
symlink: Inode doesn't have inline data

That is because we did not mark EXT4_INLINE_DATA_FL yet. Even if mark the flag,
it still return at this point:

	data.fs = fs;
	data.ino = ino;
	retval = ext2fs_inline_data_ea_get(&data);
	if (retval)
		return retval;

and the message was printed as below:

ext2fs_symlink: Extended attribute key not found
symlink: Extended attribute key not found

That means the xattr of the new created inode is clean.
because ext2fs_write_new_inode() is called early, the xattr is made clean.

I think use "ext2fs_xattr_inode_max_size() + EXT4_MIN_INLINE_DATA_SIZE"
to get the available xattr size. And use ext2fs_inline_data_ea_set()
directly to set inline data is a workaround.

 
> > 
> > --D
> > 
> > > 
> > > >> +					sizeof(__u32)+
> > > >> +					EXT4_MIN_INLINE_DATA_SIZE;
> > > >> +			inline_link = (target_len < max_inline);
> > > >
> > > >Does ext2fs_xattr_inode_max_size() + EXT4_MIN_INLINE_DATA_SIZE return incorrect
> > > >results?  I don't think we should have all xattr specific stuff belongs here in
> > > >the symlink routines.
> > > 
> > > Sorry. I did not notice that some xattr might be existed  when an inode
> > > number is passed to ext2fs_symlink(). But, as far as I can see, when 0
> > > is pass as inode number. ext2fs_xattr_inode_max_size() will read inode
> > > by ext2fs_read_inode_full(). But at that time, we have not writen the
> > > inode back. and the size of inline data for symlink is uncertain.
> > > I will try to find a workaround.
> > > 
> > > >> -		if (retval)
> > > >> -			goto cleanup;
> > > >> +		  retval = io_channel_write_blk64(fs->io, blk, 1, block_buf);
> > > >> +		  if (retval)
> > > >> +		    goto cleanup;
> > > >
> > > >Please fix the indentation inconsistency (tabs, not spaces).
> > > 
> > > >> -	if (!fastlink)
> > > >> +	if ((!fastlink) && (!inline_link))
> > > >
> > > >Probably unnecessary to put !fastlink and !inline_link in parentheses.
> > > >
> > > >--D
> > > Darrick, thank again for your generous help.
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
