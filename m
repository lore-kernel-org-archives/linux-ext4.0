From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: [PATCH] Validate extent details only when read from the disk
Date: Mon, 09 Feb 2009 12:12:53 +0100
Message-ID: <49900FB5.9080705@ph.tum.de>
References: <20090207173239.GA25942@skywalker> <1234036882-30656-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1234036882-30656-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <49900612.3020609@ph.tum.de> <20090209104857.GE31884@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:47864 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751661AbZBILND (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Feb 2009 06:13:03 -0500
In-Reply-To: <20090209104857.GE31884@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Mon, Feb 09, 2009 at 11:31:46AM +0100, Thiemo Nagel wrote:
>> Aneesh Kumar K.V wrote:
>>> Make sure we validate extent details only when read from the disk.
>>>
>>> @@ -602,15 +607,13 @@ struct ext4_ext_path *
>>>  ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
>>>  					struct ext4_ext_path *path)
>>>  {
>>> +	int need_to_validate = 0;
>>>  	struct ext4_extent_header *eh;
>>>  	struct buffer_head *bh;
>>>  	short int depth, i, ppos = 0, alloc = 0;
>>>  
>>>  	eh = ext_inode_hdr(inode);
>>>  	depth = ext_depth(inode);
>>> -	if (ext4_ext_check(inode, eh, depth))
>>> -		return ERR_PTR(-EIO);
>>> -
> 
> I am doing the check in ext4_iget while reading the inode from disk.

You're right, there is a check.  I didn't notice that, because 
ext4_iget() doesn't return an error.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 03ba20b..a8bab39 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4273,6 +4273,11 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>  			(__u64)(le32_to_cpu(raw_inode->i_version_hi)) << 32;
>  	}
>  
> +	if (ei->i_flags & EXT4_EXTENTS_FL) {
> +		/* Validate extent which is part of inode */
> +		ext4_ext_check_inode(inode);
> +	}
> +

I'd propose to change that to:

	if (ei->i_flags & EXT4_EXTENTS_FL) {
		/* Validate extent which is part of inode */
		if ((ret = ext4_ext_check_inode(inode)))
			goto bad_inode;
	}

Kind regards,

Thiemo
