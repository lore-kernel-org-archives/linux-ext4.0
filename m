From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH 3/3] ext4: Implement FALLOC_FL_COLLAPSE_RANGE
Date: Thu, 1 Aug 2013 15:23:16 +0900
Message-ID: <CAKYAXd-Ja1JraEA95GKq7c=nzHF0KkgNeRy5vKL4KnjymuXPsw@mail.gmail.com>
References: <1375281746-15908-1-git-send-email-linkinjeon@gmail.com>
	<20130801024800.GK7118@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, bpm@sgi.com,
	elder@kernel.org, hch@infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, a.sangwan@samsung.com,
	Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130801024800.GK7118@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2013/8/1, Dave Chinner <david@fromorbit.com>:
> On Wed, Jul 31, 2013 at 11:42:26PM +0900, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> New fallocate flag FALLOC_FL_COLLAPSE_RANGE implementation for Ext4
> .....
>> +
>> +	punch_start = offset >> EXT4_BLOCK_SIZE_BITS(sb);
>> +	punch_stop = (offset + len) >> EXT4_BLOCK_SIZE_BITS(sb);
>> +
>> +	rounding = max_t(uint, 1 << EXT4_BLOCK_SIZE_BITS(sb), PAGE_CACHE_SIZE);
>> +	ioffset = offset & ~(rounding - 1);
>> +
>> +	/* Write out all dirty pages */
>> +	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset, -1);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Take mutex lock */
>> +	mutex_lock(&inode->i_mutex);
>> +
>> +	truncate_pagecache_range(inode, ioffset, -1);
>
> Ted, that's invalidating the page cache from the start of the
> collaspse range to the end of the file. So the ext4 code is doing
> this bit correctly.  Why isn't this in the XFS patches? Clearly the
> need for this was understood, and, well, this code is obviously
> copied from the XFS hole punching code. i.e. from
> xfs_free_file_space().
we already called xfs_free_file_space for collpase range in XFS patch.
So invalidate page cache has been calling from xfs_free_file_space in
this patch :)
>
>> +	/* Wait for existing dio to complete */
>> +	ext4_inode_block_unlocked_dio(inode);
>> +	inode_dio_wait(inode);
>
> That should be done before invalidating the pagecache....
Ah, correct. will move it before invalidating.
>
>> +	credits = ext4_writepage_trans_blocks(inode);
>> +	handle = ext4_journal_start(inode, EXT4_HT_TRUNCATE, credits);
>> +	if (IS_ERR(handle)) {
>> +		ret = PTR_ERR(handle);
>> +		goto out_dio;
>> +	}
>> +
>> +	down_write(&EXT4_I(inode)->i_data_sem);
>> +
>> +	ext4_discard_preallocations(inode);
>> +
>> +	ret = ext4_es_remove_extent(inode, punch_start,
>> +				    EXT_MAX_BLOCKS - punch_start - 1);
>> +	if (ret)
>> +		goto journal_stop;
>> +
>> +	ret = ext4_ext_remove_space(inode, punch_start, punch_stop - 1);
>> +	if (ret)
>> +		goto journal_stop;
>
> So, this code punches out the existing space in the file so that the
> extent shifting is moving extents into a hole. Why is this in the
> ext4 code, but not the XFS code?
for Ext4, we are calling ext4_ext_remove_space directly from collapse
range function while in xfs we are using its punch hole functionality.
This is because Ext4 punch hole does not work beyond EOF. Moreover,
there is i_mutex acquired within ext4_punch_hole which can leads to
race.

Something like:
ext4_fallocate {
    ext4_punch_hole{
        grab i_mutex;
        do punching;
        release i_mutex:
        }
    ext4_collapse_space{
        sync dirty pages
        grab i_mutex;
        update extent;
        release i_mutex;
    }
} // ext4_fallocate_ends

XFS has no such problem as xfs_iolock is taken after entering in
xfs_file_fallocate and released on exit.

Thanks for review :)
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
