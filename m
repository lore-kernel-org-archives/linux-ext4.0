From: Andreas Dilger <adilger@sun.com>
Subject: Re: Fix softlockup caused by illegal i_file_acl value in on-disk	inode
Date: Wed, 03 Jun 2009 12:16:08 -0600
Message-ID: <20090603181608.GO9002@webber.adilger.int>
References: <1243944479-20574-4-git-send-email-tytso@mit.edu>
 <1243944479-20574-5-git-send-email-tytso@mit.edu>
 <1243944479-20574-6-git-send-email-tytso@mit.edu>
 <1243944479-20574-7-git-send-email-tytso@mit.edu>
 <1243944479-20574-8-git-send-email-tytso@mit.edu>
 <1243944479-20574-9-git-send-email-tytso@mit.edu>
 <1243944479-20574-10-git-send-email-tytso@mit.edu>
 <1243944479-20574-11-git-send-email-tytso@mit.edu>
 <1243944479-20574-12-git-send-email-tytso@mit.edu>
 <1243944479-20574-13-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:38828 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbZFCSQ0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Jun 2009 14:16:26 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n53IGSUX020155
	for <linux-ext4@vger.kernel.org>; Wed, 3 Jun 2009 11:16:28 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KKO00400DAWYO00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Wed,
 03 Jun 2009 11:16:28 -0700 (PDT)
In-reply-to: <1243944479-20574-13-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 02, 2009  08:07 -0400, Theodore Ts'o wrote:
> +	if (ei->i_file_acl &&
> +	    ((ei->i_file_acl < 
> +	      (le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) +
> +	       EXT4_SB(sb)->s_gdb_count)) ||
> +	     (ei->i_file_acl >= ext4_blocks_count(EXT4_SB(sb)->s_es)))) {

I was just thinking it might make sense to wrap this check into a helper
like the following.  We check the validity of blocks in at least half a
dozen different places.  The elaborate ext4_blocktype is to allow for
future expansion of this checking mechanism to allow it to check for
blocks overlapping with e.g. the inode table and such, and possibly for
using with the jbd2 buffer checksum mechanism at some later date.

enum ext4_blocktype {
	EXT4_BT_SUPERBLOCK	=  1,
	EXT4_BT_GDT		=  2,
	EXT4_BT_INODE_BITMAP	=  3,
	EXT4_BT_BLOCK_BITMAP	=  4,
	EXT4_BT_INODE_TABLE	=  5,
	EXT4_BT_DIRECTORY_ROOT  = 10,
	EXT4_BT_DIRECTORY_LEAF  = 11,
	EXT4_BT_DIRECTORY_HTREE = 12,
	EXT4_BT_INDIRECT	= 21,
	EXT4_BT_DINDIRECT	= 22,
	EXT4_BT_TINDIRECT	= 23,
	EXT4_BT_EXTENT_INDEX    = 25,
	EXT4_BT_EXTENT_LEAF	= 26,
	EXT4_BT_DATA_BLOCK	= 30,
	EXT4_BT_ACL_BLOCK	= 31,
};

bool ext4_block_valid(ext4_blk_t block, enum blocktype)
{
	if (block < le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) +
			EXT4_SB(sb)->s_gdb_count)) ||
	    block >= ext4_blocks_count(EXT4_SB(sb)->s_es)
		return 0;
	
	return 1;
}

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

