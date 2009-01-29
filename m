From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re: on disk format: value of bg_inode_table_hi?
Date: Thu, 29 Jan 2009 11:47:29 +0000 (GMT)
Message-ID: <419866.84825.qm@web23605.mail.ird.yahoo.com>
References: <20090129051221.GH8990@mit.edu>
Reply-To: etienne_lorrain@yahoo.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web23605.mail.ird.yahoo.com ([87.248.115.48]:31684 "HELO
	web23605.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753759AbZA2Lrb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Jan 2009 06:47:31 -0500
In-Reply-To: <20090129051221.GH8990@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@mit.edu> wrote:
> bg_inode_table_hi doesn't exist on a small filesystem. 
> You need to take a look at if INCOMPAT_64BIT is not set,
> or if INCOMPAT_64BIT is set and s_desc_size is 32, then
> only the first 32 bytes of struct ext4_group_desc are
> in use --- which look exactly the same as ext2_group_desc.
> 
> So there is no problem here.  Just a misunderstanding of
> the filesystem format.
> 
> 						- Ted

 Thanks a lot; and sorry, I should have guessed myself that
the field is not there when s_desc_size is too small,
whatever the value of INCOMPAT_64BIT.

 May I ask confirmation of this 2 points on the list too:
- the array of inode in the inode_table is an array where
 each inode has the size superblock->s_inode_size (or
 EXT2_GOOD_OLD_INODE_SIZE) whatever s_min_extra_isize,
 s_want_extra_isize, inode->i_extra_isize because
 the "extra" size of an inode is not stored in the
 inode_table.

- If I only access the ext4 filesystem readonly, I do not
 have any difference considering the flags of the superblock:
 EXT4_FEATURE_INCOMPAT_META_BG, EXT4_FEATURE_INCOMPAT_MMP,
 EXT4_FEATURE_INCOMPAT_FLEX_BG. That is, I do not want to
 allocate any block, so I should not refuse to "mount" an
 ext4fs whatever the value of these flags.
 I do not know anything about EXT4_FEATURE_INCOMPAT_MMP...

 Thanks in advance,
 Etienne.


      
