From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH][7/28] e2fsprogs-extents.patch
Date: Mon, 18 Feb 2008 14:48:18 -0600
Message-ID: <47B9EF12.5020400@redhat.com>
References: <20080202075943.GB23836@webber.adilger.int> <20080202082559.GG31694@webber.adilger.int> <20080202082701.GH31694@webber.adilger.int> <47B9C6E5.2010304@redhat.com> <20080218195332.GK25098@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086AbYBRUsl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Feb 2008 15:48:41 -0500
In-Reply-To: <20080218195332.GK25098@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Mon, Feb 18, 2008 at 11:56:53AM -0600, Eric Sandeen wrote:
>> So this trips up on things like sockets, fifos, and block & char nodes.
>>
>> Also this is unhappy:
>>
>>> @@ -137,7 +141,7 @@ int e2fsck_pass1_check_device_inode(ext2
>>>  	 * If the index flag is set, then this is a bogus
>>>  	 * device/fifo/socket
>>>  	 */
>>> -	if (inode->i_flags & EXT2_INDEX_FL)
>>> +	if (inode->i_flags & (EXT2_INDEX_FL | EXT4_EXTENTS_FL))
>>>  		return 0;
>> Do we really care if these have the extents flag set?  IOW should we
>> make sure the kernel doesn't set the flag, or should we make e2fsck not
>> care...
> 
> <Sigh>
> 
> I think we need to get kernel patches into mainline ASAP not to set
> the EXTENTS_FL 

You mean on devices/fifos/sockets ?  Ok.

But today, with 2.6.25-rc1 and e2fsprogs-interim, long (non-fast)
symlinks get clobbered by e2fsck, because:

Pass 1: Checking inodes, blocks, and sizes
Inode 12 has EXTENT_FL set, but is not in extents format
Fix? yes

Inode 12 has illegal block(s).  Clear? yes

Illegal block #0 (127754) in inode 12.  CLEARED.
Inode 12 is too big.  Truncate? yes

Block #1 (4) causes symlink to be too big.  CLEARED.
Block #4 (1) causes symlink to be too big.  CLEARED.
Block #5 (4772) causes symlink to be too big.  CLEARED.
Inode 12, i_blocks is 2, should be 0.  Fix? yes

Pass 2: Checking directory structure
Symlink /longlink (inode #12) is invalid.
Clear? yes

Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -4772
Fix? yes

Free blocks count wrong for group #0 (3420, counted=3421).
Fix? yes

Free blocks count wrong (26192, counted=26193).
Fix? yes

and *poof* it's gone.  That one concerns me more...  This *should* be in
extents format, right, even though it's limited to one block...

> and at least
> for now, e2fsck needs to accept (and not complain or core dump) if
> EXTENTS_FL is set for files where ext2fs_inode_has_valid_blocks()
> returns false

well, if any filetypes are not supposed to have the extents flag set,
and they're zero-length, I'd say go ahead & clear it, and even complain
if you like - it's the design intent after all -  I wouldn't worry about
the noise at this stage.  FWIW, I haven't seen a core dump.  :)

-Eric
