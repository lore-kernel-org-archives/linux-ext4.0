From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Fix warning in ext4_da_update_reserve_space()
Date: Sat, 17 Aug 2013 09:45:20 -0400
Message-ID: <20130817134520.GC30769@thunk.org>
References: <1376053620-26987-1-git-send-email-jack@suse.cz>
 <1376053620-26987-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44968 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab3HQNpW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Aug 2013 09:45:22 -0400
Content-Disposition: inline
In-Reply-To: <1376053620-26987-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 09, 2013 at 03:07:00PM +0200, Jan Kara wrote:
> reaim workfile.dbase test easily triggers warning in
> ext4_da_update_reserve_space():
> 
> EXT4-fs warning (device ram0): ext4_da_update_reserve_space:365:
> ino 12, allocated 1 with only 0 reserved metadata blocks (releasing 1
> blocks with reserved 9 data blocks)
> 
> The problem is that (one of) tests creates file and then randomly writes
> to it with O_SYNC. That results in writing back pages of the file in
> random order so we create extents for written blocks say 0, 2, 4, 6, 8
> - this last allocation also allocates new block for extents. Then we
> writeout block 1 so we have extents 0-2, 4, 6, 8 and we release
> indirect extent block because extents fit in the inode again. Then we
> writeout block 10 and we need to allocate indirect extent block again
> which triggers the warning because we don't have the reservation
> anymore.
> 
> Fix the problem by giving back freed metadata blocks resulting from
> extent merging into inode's reservation pool.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
