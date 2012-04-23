From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC] jbd2: reduce the number of writes when commiting a
 transacation
Date: Mon, 23 Apr 2012 10:25:05 +0800
Message-ID: <20120423022505.GA7855@gmail.com>
References: <20120420110627.GA30373@gmail.com>
 <E5D2F131-A01C-4CB2-8A7C-88CACBBC450B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E5D2F131-A01C-4CB2-8A7C-88CACBBC450B@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Apr 20, 2012 at 05:21:59AM -0600, Andreas Dilger wrote:
> On 2012-04-20, at 5:06 AM, Zheng Liu wrote:
> > In this thread[1], I found a defect in jbd2 because it needs two wrties
> > to finish a transacation because it writes journal header and data to
> > disk and it will write commit to disk after above writes are done.
> > AFAIK, in jbd2, it will call submit_bh twice at least to write the data
> > because journal header, data and commit are stored in different
> > buffer_heads.  If we don't call them separately, these calls might be
> > out of order.  Obviously, it must ensure that journal header and data are written before commit.  But this brings a huge overhead in this
> > benchmark[2].  So, IMHO, if we could use *bio* to store these data
> > rather than buffer_head, we could avoid this overhead because we can
> > call submit_bio only once to write all of data, which contains journal
> > header, data and commit.  Here is an issue that I don't determine.  If
> > we use submit_bio to write journal data, it will make all of data with
> > WRITE_FLUSH_FUA flag.  But now there is only commit data with this flag.
> 
> The reason that there are two separate writes is because if the write
> of the commit block is reordered before the journal data, and only the
> commit block is written before a crash (data is lost), then the journal
> replay code may incorrectly think that the transaction is complete and
> copy the unwritten (garbage) block to the wrong place.
> 
> I think there is potentially an existing solution to this problem,
> which is the async journal commit feature.  It adds checksums to the
> journal commit block, which allows verifying that all blocks were
> written to disk properly even if the commit block is submitted at
> the same time as the journal data blocks.
> 
> One problem with this implementation is that if an intermediate
> journal commit has a data corruption (i.e. checksum of all data
> blocks does not match the commit block), then it is not possible
> to know which block(s) contain bad data.  After that, potentially
> many thousands of other operations may be lost.
> 
> We discussed a scheme to store a separate checksum for each block
> in a transaction, by storing a 16-bit checksum (likely the low
> 16 bits of CRC32c) into the high flags word for each block.  Then,
> if one or more blocks is corrupted, it is possible to skip replay
> of just those blocks, and potentially they will even be overwritten
> by blocks in a later transaction, requiring no e2fsck at all.

Thanks for pointing out this feature.  I have evaluated this feature in my
benchmark, and it can dramatically improve the performance. :-)

BTW, out of curiosity, why not set this feature on default?

Regards,
Zheng

> 
> > I am not sure whether or not it brings some other unpridictable
> > problems. :(
> > 
> > Please feel free to comment this RFC.  Thank you.
> > 
> > 1. http://www.spinics.net/lists/linux-ext4/msg31637.html
> > 2. benchmark: time for((i=0;i<2000;i++)); do \
> > 		dd if=/dev/zero of=/mnt/sda1/testfile conv=notrunc bs=4k \
> > 		count=1 seek=`expr $i \* 16` oflag=sync,direct 2>/dev/null; \
> > 		done
> > 
> > Regards,
> > Zheng
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
