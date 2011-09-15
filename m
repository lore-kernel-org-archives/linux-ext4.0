From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2] libext2fs: add metadata checksum and snapshot feature flags
Date: Thu, 15 Sep 2011 17:34:41 -0600
Message-ID: <14955E98-C987-40D6-A881-5D40077C2FB2@dilger.ca>
References: <1316127052-1890-1-git-send-email-tytso@mit.edu> <1316127052-1890-2-git-send-email-tytso@mit.edu> <F041558F-1F4B-4ADE-9DC2-53708C9124B8@dilger.ca> <20110915231127.GK28181@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Amir Goldstein <amir73il@gmail.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:22205 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935453Ab1IOXen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Sep 2011 19:34:43 -0400
In-Reply-To: <20110915231127.GK28181@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-15, at 5:11 PM, Ted Ts'o wrote:
> On Thu, Sep 15, 2011 at 05:09:13PM -0600, Andreas Dilger wrote:
>> 
>> I thought it would be better to move s_checksum to be the last field in the
>> superblock to avoid multiple calls to the CRC function? 
> 
> Did you see my comment about just zero'ing the checksum field before
> running the CRC?  We're going to have to do that for other data
> structures, such as the inode structure, and it's what we do with the
> block group descriptor checksum.

That isn't correct.  The group descriptor checksum is computed in chunks:

__le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 block_group,
                            struct ext4_group_desc *gdp)
{
                int offset = offsetof(struct ext4_group_desc, bg_checksum);
                __le32 le_group = cpu_to_le32(block_group);

                crc = crc16(~0, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
                crc = crc16(crc, (__u8 *)&le_group, sizeof(le_group));
                crc = crc16(crc, (__u8 *)gdp, offset);
                offset += sizeof(gdp->bg_checksum); /* skip checksum */
****HERE****
                /* for checksum of struct ext4_group_desc do the rest...*/
                if ((sbi->s_es->s_feature_incompat &
                     cpu_to_le32(EXT4_FEATURE_INCOMPAT_64BIT)) &&
                    offset < le16_to_cpu(sbi->s_es->s_desc_size))
                        crc = crc16(crc, (__u8 *)gdp + offset,
                                    le16_to_cpu(sbi->s_es->s_desc_size) -
                                        offset);
 }

Darrick and I discussed zeroing the checksum fields, but then there is a
race with other threads accessing the same structure.

If we went to a crc32c LSB for filesystems with RO_COMPAT_CSUM it would
be possible to change how it is computed.  Since we have freedom to move
the checksum field now, why have the added complexity to do zeroing of
the field or two chunks?

Since we naturally have to break the checksum calculation for 128-byte
inodes and 32-byte descriptors, due to old versions of those structs,
there is little overhead in just skipping the field, and no races.

Cheers, Andreas





