From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [Ocfs2-devel] [PATCH 1/3] ext3/ext4: Factor out disk addressability check
Date: Thu, 12 Aug 2010 12:45:41 -0600
Message-ID: <1F3EDC08-AC93-4D4D-8F83-A13C418DFC88@dilger.ca>
References: <874ofr2myq.fsf@patl.com> <20100812174215.GC6561@mail.oracle.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Ted Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org Patrick J. LoPresti"
	<lopresti@gmail.com>
To: Joel Becker <Joel.Becker@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:50912 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab0HLSql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Aug 2010 14:46:41 -0400
In-Reply-To: <20100812174215.GC6561@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-12, at 11:42, Joel Becker wrote:
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
>> +	BUG_ON(blocksize_bits < 9);
>> +	BUG_ON(blocksize_bits > PAGE_CACHE_SHIFT);

I'd rather not have a BUG_ON() for a "check" function that may be called with on-disk values by some filesystem.  Some filesystems (AFAIR) also handle blocksize > PAGE_SIZE internally, so this helper would not be useful for them.

Cheers, Andreas



