From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Update reserved space after the 'correction'
Date: Sun, 10 Mar 2013 22:50:16 -0400
Message-ID: <20130311025016.GJ10090@thunk.org>
References: <1362731059-3508-1-git-send-email-lczerner@redhat.com>
 <1362731059-3508-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, gnehzuil.liu@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52378 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab3CKCuT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Mar 2013 22:50:19 -0400
Content-Disposition: inline
In-Reply-To: <1362731059-3508-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 08, 2013 at 09:24:18AM +0100, Lukas Czerner wrote:
> Currently in ext4_ext_map_blocks() in delayed allocation writeback
> we would update the reservation and after that check whether we claimed
> cluster outside of the range of the allocation and if so, we'll give the
> block back to the reservation pool.
> 
> However this also means that if the number of reserved data block
> dropped to zero before the correction, we would release all the metadata
> reservation as well, however we might still need it because the we're
> not done with the delayed allocation and there might be more blocks to
> come. This will result in error messages such as:
> 
> EXT4-fs warning (device sdb): ext4_da_update_reserve_space:361: ino 12,
> allocated 1 with only 0 reserved metadata blocks (releasing 1 blocks
> with reserved 1 data blocks)
> 
> This will only happen on bigalloc file system and it can be easily
> reproduced using fiemap-tester from xfstests like this:
> 
> ./src/fiemap-tester -m DHDHDHDHD -S -p0 /mnt/test/file
> 
> Or using xfstests such as 225.
> 
> Fix this by doing the correction first and updating the reservation
> after that so that we do not accidentally decrease
> i_reserved_data_blocks to zero.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

						- Ted
