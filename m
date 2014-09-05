From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix deadlock of i_data_sem in
 ext4_mark_inode_dirty()
Date: Thu, 4 Sep 2014 21:59:35 -0400
Message-ID: <20140905015935.GF4364@thunk.org>
References: <CAPTn0cAPYMMDx-_RvL22Mf8YMcGib65YbiwfzDhCkEO7-OtHjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39047 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbaIEB7l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Sep 2014 21:59:41 -0400
Content-Disposition: inline
In-Reply-To: <CAPTn0cAPYMMDx-_RvL22Mf8YMcGib65YbiwfzDhCkEO7-OtHjw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 04, 2014 at 04:49:58PM +0800, Li Xi wrote:
> There are multiple places where ext4_mark_inode_dirty() is called holding
> write lock of EXT4_I(inode)->i_data_sem. However, if
> ext4_mark_inode_dirty() needs to expand inode size, this will cause
> deadlock when ext4_xattr_block_set() tries to get read lock of
> EXT4_I(inode)->i_data_sem.

This was with inline data enabled, right?

The problem with your change is that the reason why the locking is the
way it is was to fix a bug which Jan Kara identified in commit
90e775b71ac4e68: "ext4: fix lost truncate due to race with writeback".

    ext4: fix lost truncate due to race with writeback
    
    The following race can lead to a loss of i_disksize update from truncate
    thus resulting in a wrong inode size if the inode size isn't updated
    again before inode is reclaimed:
    
    ext4_setattr()                              mpage_map_and_submit_extent()
      EXT4_I(inode)->i_disksize = attr->ia_size;
      ...                                         ...
                                          disksize = ((loff_t)mpd->first_page) << PAGE_CACHE_SHIFT
                                          /* False because i_size isn't
                                           * updated yet */
                                          if (disksize > i_size_read(inode))
                                          /* True, because i_disksize is
                                           * already truncated */
                                          if (disksize > EXT4_I(inode)->i_disksize)
                                            /* Overwrite i_disksize
                                             * update from truncate */
                                            ext4_update_i_disksize()
      i_size_write(inode, attr->ia_size);
    
    For other places updating i_disksize such race cannot happen because
    i_mutex prevents these races. Writeback is the only place where we do
    not hold i_mutex and we cannot grab it there because of lock ordering.
    
    We fix the race by doing both i_disksize and i_size update in truncate
    atomically under i_data_sem and in mpage_map_and_submit_extent() we move
    the check against i_size under i_data_sem as well.
    
    Signed-off-by: Jan Kara <jack@suse.cz>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Cc: stable@vger.kernel.org

So I think we need to find another way to fix this problem.  There are
a limited number of places before we call ext4_mark_inode_dirty()
where i_size will grow such that the inline data code might need to
move the data out from i_blocks[].

It might make more sense to have a helper function which checks to see
if this condition holds, and do the converation away from using
inline_data for that inode *before* we call ext4_mark_inode_dirty().

Does that make sense to you?

Regards,

					- Ted
