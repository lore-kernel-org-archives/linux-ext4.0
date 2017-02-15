From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 5/7] nonblocking aio: ext4
Date: Wed, 15 Feb 2017 05:20:12 -0600
Message-ID: <f21ccd4b-d13f-b4fe-ec99-f47d7ec691fb@suse.de>
References: <20170214024603.9563-1-rgoldwyn@suse.de>
 <20170214024603.9563-6-rgoldwyn@suse.de>
 <5C94A069-0A0C-4B99-9B32-C6750AD2388B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz,
        linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <5C94A069-0A0C-4B99-9B32-C6750AD2388B@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On 02/14/2017 01:52 PM, Andreas Dilger wrote:
> 
>> On Feb 13, 2017, at 7:46 PM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>>
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
>> Return EAGAIN if any of the following checks fail for direct I/O:
>> + i_rwsem is lockable
>> + Writing beyond end of file (will trigger allocation)
>> + Blocks are allocated at the write location
>>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> ---
>> fs/ext4/file.c | 28 ++++++++++++++++++++++------
>> 1 file changed, 22 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
>> index 2a822d3..c8d1e41 100644
>> --- a/fs/ext4/file.c
>> +++ b/fs/ext4/file.c
>> @@ -93,11 +93,16 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>> {
>> 	struct inode *inode = file_inode(iocb->ki_filp);
>> 	int o_direct = iocb->ki_flags & IOCB_DIRECT;
>> +	int nonblocking = iocb->ki_flags & IOCB_NONBLOCKING;
>> 	int unaligned_aio = 0;
>> 	int overwrite = 0;
>> 	ssize_t ret;
>>
>> -	inode_lock(inode);
>> +	if (o_direct && nonblocking) {
>> +		if (!inode_trylock(inode))
>> +			return -EAGAIN;
> 
> Why do these all return -EAGAIN instead of -EWOULDBLOCK?  -EAGAIN is already
> used in a number of places, and -EWOULDBLOCK seems more correct in the
> "nonblocking" case?

It is the same :)
#define EWOULDBLOCK     EAGAIN  /* Operation would block */

I didn’t know before I started this work either.
Anyways, I based this on 4.9.9 but there are changes in ext4 code in
4.10-rcx so I need to redo the patches. Thanks for the style reviews.

> 
>> +	} else
>> +		inode_lock(inode);
> 
> (style) "else" blocks should have braces when the "if" block has braces
> 
>> 	ret = generic_write_checks(iocb, from);
>> 	if (ret <= 0)
>> 		goto out;
>> @@ -132,12 +137,18 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>> 	if (o_direct) {
>> 		size_t length = iov_iter_count(from);
>> 		loff_t pos = iocb->ki_pos;
>> +		unsigned int blkbits = inode->i_blkbits;
>> +
>> +		if (nonblocking
>> +			&& (pos + length > EXT4_BLOCK_ALIGN(i_size_read(inode), blkbits))) {
> 
> (style) "&&" should go at the end of the previous line
> (style) continued lines should align after '(' on previous line
> (style) no need for parenthesis around that comparison
> 
>> +			ret = -EAGAIN;
>> +			goto out;
>> +		}
>>
>> 		/* check whether we do a DIO overwrite or not */
>> -		if (ext4_should_dioread_nolock(inode) && !unaligned_aio &&
>> -		    pos + length <= i_size_read(inode)) {
>> +		if ((ext4_should_dioread_nolock(inode) && !unaligned_aio &&
>> +			    pos + length <= i_size_read(inode)) || nonblocking) {
> 
> (style) continued line should align after second '(' of previous line
> 
>> 			struct ext4_map_blocks map;
>> -			unsigned int blkbits = inode->i_blkbits;
>> 			int err, len;
>>
>> 			map.m_lblk = pos >> blkbits;
>> @@ -157,8 +168,13 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>> 			 * non-flags are returned.  So we should check
>> 			 * these two conditions.
>> 			 */
>> -			if (err == len && (map.m_flags & EXT4_MAP_MAPPED))
>> -				overwrite = 1;
>> +			if (err == len) {
>> +			       if (map.m_flags & EXT4_MAP_MAPPED)
>> +				       overwrite = 1;
>> +			} else if (nonblocking) {
>> +				ret = -EAGAIN;
>> +				goto out;
>> +			}
>> 		}
>> 	}
>>
>> --
>> 2.10.2
>>
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 

-- 
Goldwyn
