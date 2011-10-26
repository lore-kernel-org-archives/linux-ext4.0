From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH V1 02/17] ext4: Add the basic function for inline data
 support.
Date: Wed, 26 Oct 2011 22:38:08 +0800
Message-ID: <4EA81B50.1060802@tao.ma>
References: <4EA7B788.3040503@tao.ma> <1319614468-11227-1-git-send-email-tm@tao.ma> <1319614468-11227-2-git-send-email-tm@tao.ma> <E38E92E9-2937-47BA-A9F4-B1F75C9FDE4A@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:42885 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932772Ab1JZOiZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Oct 2011 10:38:25 -0400
In-Reply-To: <E38E92E9-2937-47BA-A9F4-B1F75C9FDE4A@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/26/2011 04:36 PM, Andreas Dilger wrote:
> On 2011-10-26, at 1:34 AM, Tao Ma wrote:
>> Implement inline data with xattr. This idea is inspired by Andreas.
>> So now we use "system.data" to store xattr.  For inode_size = 256,
>> currently we uses all the space between i_extra_isize and inode_size.
>> For inode_size > 256, we use half of that space.
>>
>> +#define EXT4_XATTR_SYSTEM_DATA_NAME		"data"
> 
> Did you check whether the "data" string takes 4 bytes or 8 in the
> xattr header?  I believe it is storing the NUL termination (and
> the code is using "sizeof(EXT4_XATTR_SYSTEM_DATA_NAME)" = 5), so
> I believe it will round up to the next 4-byte boundary.  Using a
> 3-byte name will save a bit of space, like "system.dat".
Actually it will takes 4 bytes instead of 8, since in
ext4_xattr_set_entry it uses memcpy to copy the name with namelen
initialized with strlen("data"). So "data" is fine here. As for the
calculation of max_inline_size, yes, it uses
sizeof(EXT4_XATTR_SYSTEM_DATA_NAME) which should be changed to strlen.
Thanks for the advice.
> 
>> +void ext4_write_inline_data(struct inode *inode, struct ext4_iloc *iloc,
>> +			    void *buffer, loff_t pos, unsigned len)
>> +{
>> +	header = IHDR(inode, ext4_raw_inode(iloc));
>> +	entry = (struct ext4_xattr_entry *)((void *)ext4_raw_inode(iloc) +
>> +					    EXT4_I(inode)->i_inline_off);
>> +	memcpy((void *)IFIRST(header) + le16_to_cpu(entry->e_value_offs) + pos,
>> +	       buffer + pos, len);
>> +}
>> +
>> +int ext4_init_inline_data(handle_t *handle, struct inode *inode,
>> +			  struct ext4_iloc *iloc)
>> +{
>> +	size = ext4_get_max_inline_size(inode);
>> +	value = kzalloc(size, GFP_NOFS);
>> +	if (!value)
>> +		return -ENOMEM;
>> +
>> +	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
>> +}
> 
> Since file data is changed very rarely, instead of consuming the full
> xattr space that may not be needed, wouldn't it be better to change
> ext4_write_inline_data() to just to the ext4_xattr_ibody_set() to save
> the exact-sized buffer into the xattr?  That will allow other xattrs
> to be stored in this space as well as the inline data.
I am just worried about the cpu usage. You know, the xattr values in
ext4 has to be packed so if we change the content of an inline file
frequently(say append), the inline xattr value will be removed and added
frequently which should consume much cpu cycles. What's more, the other
xattr values has to be moved also if they are not aligned to the end of
the inode. I am not sure whether it is good for performance or not.
Another side effect is that we have to write the whole inline data every
time as a new xattr value replace every time while the current solution
just needs to memcpy the appended bytes.

Thanks
Tao
