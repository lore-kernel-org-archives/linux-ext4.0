From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] e2fsprogs/csum: Use fs.csum_seed for xattr block csum
 calculation.
Date: Wed, 04 Jul 2012 09:44:36 +0800
Message-ID: <4FF3A004.7050006@tao.ma>
References: <1340547756-2932-1-git-send-email-tm@tao.ma> <20120703165826.GB2342@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:39212 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755825Ab2GDBom (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jul 2012 21:44:42 -0400
In-Reply-To: <20120703165826.GB2342@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/04/2012 12:58 AM, Darrick J. Wong wrote:
> On Sun, Jun 24, 2012 at 10:22:36PM +0800, Tao Ma wrote:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> As I mentioned in the kernel part patch with the subject
>> "ext4: Use s_csum_seed instead of i_csum_seed for xattr block csum",
>> it is not easy for the kernel to use the proper inode csum seed.
>> So always use the fs.csum_seed for the xattr block csum calculation.
>>
>> Cc: Darrick J. Wong <djwong@us.ibm.com>
> 
> Acked-by: Darrick J. Wong <djwong@us.ibm.com>
> 
> (I assume there's a similar patch for e2fsprogs?)
uh, sorry, but this *is* the patch for e2fsprogs. Something wrong here?

Thanks
Tao
> 
> --D
>> Cc: "Theodore Ts'o" <tytso@mit.edu>
>> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
>> ---
>>  lib/ext2fs/csum.c |   18 +++---------------
>>  1 files changed, 3 insertions(+), 15 deletions(-)
>>
>> diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
>> index a7096d2..5ccbc1c 100644
>> --- a/lib/ext2fs/csum.c
>> +++ b/lib/ext2fs/csum.c
>> @@ -119,21 +119,9 @@ static errcode_t ext2fs_ext_attr_block_csum(ext2_filsys fs, ext2_ino_t inum,
>>  	struct ext2_inode inode;
>>
>>  	hdr->h_checksum = 0;
>> -	if (ext2fs_le32_to_cpu(hdr->h_refcount) != 1) {
>> -		block = ext2fs_cpu_to_le64(block);
>> -		*crc = ext2fs_crc32c_le(fs->csum_seed, (unsigned char *)&block,
>> -					sizeof(block));
>> -	} else {
>> -		retval = ext2fs_read_inode(fs, inum, &inode);
>> -		if (retval)
>> -			return retval;
>> -		inum = ext2fs_cpu_to_le32(inum);
>> -		gen = ext2fs_cpu_to_le32(inode.i_generation);
>> -		*crc = ext2fs_crc32c_le(fs->csum_seed, (unsigned char *)&inum,
>> -					sizeof(inum));
>> -		*crc = ext2fs_crc32c_le(*crc, (unsigned char *)&gen,
>> -					sizeof(gen));
>> -	}
>> +	block = ext2fs_cpu_to_le64(block);
>> +	*crc = ext2fs_crc32c_le(fs->csum_seed, (unsigned char *)&block,
>> +				sizeof(block));
>>  	*crc = ext2fs_crc32c_le(*crc, (unsigned char *)buf, fs->blocksize);
>>  	hdr->h_checksum = old_crc;
>>
>> -- 
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


