From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 1/2] ext4: Calculate and verify inode checksums
Date: Fri, 8 Apr 2011 16:49:54 -0600
Message-ID: <C1228346-6174-4AD9-8384-E60197C7C85E@dilger.ca>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com> <20110406224547.GT32706@tux1.beaverton.ibm.com> <86716762-8041-4209-961C-5C0BAB139C5B@dilger.ca> <20110408191250.GD24354@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:22259 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab1DHWtz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2011 18:49:55 -0400
In-Reply-To: <20110408191250.GD24354@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-08, at 1:12 PM, Darrick J. Wong wrote:
> On Fri, Apr 08, 2011 at 02:58:27AM -0600, Andreas Dilger wrote:
>> On 2011-04-06, at 4:45 PM, Darrick J. Wong wrote:
>>> @@ -617,7 +617,7 @@ struct ext4_inode {
>>> 		} masix2;
>>> 	} osd2;				/* OS dependent 2 */
>>> 	__le16	i_extra_isize;
>>> -	__le16	i_pad1;
>>> +	__le16  i_checksum;		/* crc16(sb_uuid+inodenum+inode) */
>> 
>> In previous discussions, we thought about using part/all of the l_i_reserved2
>> field to store the inode checksum.  The inode checksum is important enough to
>> warrant a field in the core inode, so that it also works on upgraded
>> filesystems.
> 
> Hmm, yes, I better like using that field too, it'll simplify the code.  Does
> anyone know which of the s_creator_os codes map to the Linux format?  I'm going
> to guess 1 and 2 don't... for now I suppose the mount code can check for a
> Linux creator code if the inode checksum feature is set, and fail the mount if
> it finds 1 or 2.  I'm not sure which version of the osd2 union FreeBSD or
> "Lites" use.

Actually, the e2fsprogs code has already removed the "masix" part of the union years ago, and I'm not even sure why the "hurd" part of the union remains in the kernel code.  I think only Hurd is using the "h_i_author" field, so I suspect all that is needed is to refuse tune2fs to enable EXT4_FEATURE_RO_COMPAT_INODE_CSUM if s_creator_os == EXT2_OS_HURD (1).

The kernel shouldn't really care about this field - if the checksum feature isn't enabled, then this field will be ignored, and if the checksum feature IS enabled it could only have been done by mke2fs, or tune2fs which should check if it is allowed based on s_creator_os.

>>> +static __le16 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw)
>>> +{
>>> +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>>> +	struct ext4_inode_info *ei = EXT4_I(inode);
>>> +	int offset = offsetof(struct ext4_inode, i_checksum);
>>> +	__le32 inum = cpu_to_le32(inode->i_ino);
>>> +	__u16 crc = 0;
>>> +
>>> +	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>>> +		EXT4_FEATURE_RO_COMPAT_INODE_CSUM) &&
>>> +	    le16_to_cpu(raw->i_extra_isize) >= 4) {
>> 
>> If this field remains in the large part of the inode, then this check is
>> incorrect.  i_extra_isize is itself only valid if (s_inode_size is >
>> EXT4_GOOD_OLD_INODE_SIZE), otherwise it points at the next inode's i_mode.
>> 
>> Also, instead of hard-coding ">= 4" here, it would be better to use
>> EXT4_FITS_IN_INODE(raw, EXT4_I(inode), i_checksum).  Probably no reason to
>> put "ei" on the stack at all.
> 
> As always, thank you for the feedback!
> 
> --D


Cheers, Andreas





