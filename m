From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [Ocfs2-devel] [PATCH 1/3] ext3/ext4: Factor out disk addressability
 check
Date: Sun, 15 Aug 2010 12:19:36 -0500
Message-ID: <4C6821A8.5080805@redhat.com>
References: <874ofr2myq.fsf@patl.com> <20100812174215.GC6561@mail.oracle.com> <1F3EDC08-AC93-4D4D-8F83-A13C418DFC88@dilger.ca> <20100812201534.GA22777@mail.oracle.com> <209AEA97-E284-4ADB-8774-50C2630606B9@dilger.ca> <20100812222949.GC22777@mail.oracle.com> <20100813163006.GB4329@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Joel Becker <Joel.Becker@oracle.com>,
	Andreas Dilger <adilger@dilger.ca>, "Ted Ts'o" <tytso@mit.edu>,
	ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org Patrick J. LoPresti"
	<lopresti@gmail.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab0HORTo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Aug 2010 13:19:44 -0400
In-Reply-To: <20100813163006.GB4329@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
> On Thu 12-08-10 15:29:49, Joel Becker wrote:
>> diff --git a/fs/libfs.c b/fs/libfs.c
>> index dcaf972..f099566 100644
>> --- a/fs/libfs.c
>> +++ b/fs/libfs.c
>> @@ -955,6 +955,35 @@ int generic_file_fsync(struct file *file, int datasync)
>>  }
>>  EXPORT_SYMBOL(generic_file_fsync);
>>  
>> +/**
>> + * generic_check_addressable - Check addressability of file system
>> + * @blocksize_bits:	log of file system block size
>> + * @num_blocks:		number of blocks in file system
>> + *
>> + * Determine whether a file system with @num_blocks blocks (and a
>> + * block size of 2**@blocksize_bits) is addressable by the sector_t
>> + * and page cache of the system.  Return 0 if so and -EFBIG otherwise.
>> + */
>> +int generic_check_addressable(unsigned blocksize_bits, u64 num_blocks)
>> +{
>> +	u64 last_fs_block = num_blocks - 1;
>> +
>> +	if (unlikely(num_blocks == 0))
>> +		return 0;
>> +
>> +	if ((blocksize_bits < 9) || (blocksize_bits > PAGE_CACHE_SHIFT))
>> +		return -EINVAL;
>> +
>> +	if ((last_fs_block >
>> +	     (sector_t)(~0ULL) >> (blocksize_bits - 9)) ||
>> +	    (last_fs_block >
>> +	     (pgoff_t)(~0ULL) >> (PAGE_CACHE_SHIFT - blocksize_bits))) {
>             ^^^ I don't get the pgoff_t check. Shouldn't it rather be
> (u64)(pgoff_t)(~0ULL) << (PAGE_CACHE_SHIFT - blocksize_bits)?

Argh that was my fault...  Thankfully not too many 1k-blocksize-formatted
16T devices out there, I guess.

I went through the math again and also came up with:

total fs pages is blocks / (blocks per page)
total pages is blocks / (1 << PAGE_CACHE_SHIFT / 1 << blocksize_bits)
total pages is blocks / (1 << (PAGE_CACHE_SHIFT - blocksize_bits))
total pages is blocks * (1 >> (PAGE_CACHE_SHIFT - blocksize_bits))
total pages is blocks >> (PAGE_CACHE_SHIFT - blocksize_bits)

too big if total pages is > (pgoff_t)(~0ULL)
too big if blocks >> (PAGE_CACHE_SHIFT - blocksize_bits) > (pgoff_t)(~0ULL)
too big if blocks > (pgoff_t)(~0ULL) << (PAGE_CACHE_SHIFT - blocksize_bits)
and to not overflow:
too big if blocks > (u64)(pgoff_t)(~0ULL) << (PAGE_CACHE_SHIFT - blocksize_bits)

so seems like the test is:

last_fs_block > (u64)(pgoff_t)(~0ULL) << (PAGE_CACHE_SHIFT - blocksize_bits)

Given the density of the logic in the helper it seems like maybe breaking it
up and adding specific comments might be helpful to the reader:

	/* can IO layers fit total fs sectors in a sector_t? */
	if (last_fs_block >
	    (sector_t)(~0ULL) >> (blocksize_bits - 9))
		return -EFBIG;

	/* can page cache fit total fs pages in a pgoff_t? */
	if (last_fs_block >
	    (u64)(pgoff_t)(~0ULL) << (PAGE_CACHE_SHIFT - blocksize_bits)
		return -EFBIG;

Or something like that.

Sorry for chiming in late...

-Eric

> Because on 32-bit arch we are able to address 16TB device, which is for 1KB
> blocksize 1<<34 blocks. But your math gives 1<<30 blocks...
> 
> 									Honza
> 

