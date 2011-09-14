From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 11/37] libext2fs: Create the inode bitmap checksum
Date: Wed, 14 Sep 2011 14:00:18 -0600
Message-ID: <51D918B5-3B98-43F1-B384-D4AE3B77E6C3@dilger.ca>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com> <20110901003622.1176.1504.stgit@elm3c44.beaverton.ibm.com> <20110914170259.GG3429@dhcp-172-31-195-159.cam.corp.google.com> <20110914193150.GZ12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:48837 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933117Ab1INUAT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Sep 2011 16:00:19 -0400
In-Reply-To: <20110914193150.GZ12086@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-14, at 1:31 PM, Darrick J. Wong wrote:
> On Wed, Sep 14, 2011 at 01:02:59PM -0400, Ted Ts'o wrote:
>> On Wed, Aug 31, 2011 at 05:36:22PM -0700, Darrick J. Wong wrote:
>>> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
>>> index 1f08673..367bfdf 100644
>>> --- a/lib/ext2fs/ext2_fs.h
>>> +++ b/lib/ext2fs/ext2_fs.h
>>> @@ -169,7 +169,8 @@ struct ext4_group_desc
>>> 	__u16	bg_free_inodes_count_hi;/* Free inodes count MSB */
>>> 	__u16	bg_used_dirs_count_hi;	/* Directories count MSB */
>>> 	__u16	bg_itable_unused_hi;	/* Unused inodes count MSB */
>>> -	__u32	bg_reserved2[3];
>>> +	__u32	bg_inode_bitmap_csum;	/* crc32c(uuid+group+ibitmap) */
>>> +	__u32	bg_reserved2[2];
>>> };
>> 
>> 
>> One of the reasons why I like to coalesce the patches to the data
>> structures into their own separate commit, is it's hard when I'm
>> reviewing individual patches in a mail reader what's going on from a
>> big picture spective.  (Heck, even just *finding* the patches that
>> modify the on-disk format is hard....)
>> 
>> But as near as I can tell, your patch series only uses one of the
>> 32-bit fields in bg_reserved.  Is there a good reason why
>> bg_inode_bitmap_csum can't also used one of the two fields in
>> bg_reserved?  That way we get two 32-bit checksums for both struct
>> ext2_group_desc and struct ext4_group_desc.  Is there a third 32-bit
>> per-block group checksum I'm forgetting about? 
> 
> No, but I was under the impression that Amir was using one of bg_reserved for
> snapshots.  If that's not true, I'll move both bitmap checksums to bg_reserved.

He was, AND the first bg_reserved2 field as well, which the above use
would conflict with.  See my other patch.

Cheers, Andreas





