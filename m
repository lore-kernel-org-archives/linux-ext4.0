From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: Don't check io->flag when setting EXT4_STATE_DIO_UNWRITTEN
 inode state.
Date: Thu, 15 Sep 2011 10:24:20 +0800
Message-ID: <4E7161D4.8000707@tao.ma>
References: <1315984587-5039-1-git-send-email-tm@tao.ma> <4E70DF02.1000202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:47004 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752560Ab1IOCZJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Sep 2011 22:25:09 -0400
In-Reply-To: <4E70DF02.1000202@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/15/2011 01:06 AM, Eric Sandeen wrote:
> On 9/14/11 2:16 AM, Tao Ma wrote:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> When we want to convert the unitialized extent in direct write,
>> we can either do it in ext4_end_io_nolock(AIO case) or in
>>  ext4_ext_direct_IO(non AIO case) and EXT4_I(inode)->cur_aio_dio
>> is a guard for ext4_ext_map_blocks to find the right case.
>> In e9e3bcecf, we mistakenly change it by:
>> -			if (io)
>> +			if (io && !(io->flag & EXT4_IO_END_UNWRITTEN)) {
>>  				io->flag = EXT4_IO_END_UNWRITTEN;
>> -			else
>> +				atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
>> +			} else
>>  				ext4_set_inode_state(inode,
>>  						     EXT4_STATE_DIO_UNWRITTEN);
>>
>> So now if we map 2 blocks, and the first one set the EXT_IO_END_UNWRITTEN, the
>> 2nd mapping will set inode state because of the check for the flag. This is
>> wrong.
> 
> Argh, yes, I think you are right.  Pesky else clause.  :(
> 
> Do you have a testcase for this?  And what is the user-visible outcome of the error,
> is it data corruption?
sure, a very simple case can expose this.

fallocate -o 0 -l 1048576 $MNT_DIR/b
aio_test $MNT_DIR/b 4096 4096
aio_test $MNT_DIR/b 0 12288

The 2nd aio test will set the inode state. Currently, at least from my
test, it doesn't cause any data corruption because we only check
EXT4_STATE_DIO_UNWRITTEN like this:
if (ret > 0 && ext4_test_inode_state(inode,
                                    EXT4_STATE_DIO_UNWRITTEN))
So only if __blockdev_direct_IO returns us ret > 0, we will test this
flag. But the inode will have this flag from then on. I am not sure
whether there are other places complaining of it.

But I think we need this fix, first to make it more readable(at least it
is a little bit hard for me to understand the old one ;) ) and second to
avoid any future possible bug.

Thanks
Tao


> 
>> Cc: Eric Sandeen <sandeen@redhat.com>
>> Cc: "Theodore Ts'o" <tytso@mit.edu>
>> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
>> ---
>>  fs/ext4/extents.c |   16 ++++++++++------
>>  1 files changed, 10 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 57cf568..8db6743 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -3190,9 +3190,11 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
>>  		 * that this IO needs to conversion to written when IO is
>>  		 * completed
>>  		 */
>> -		if (io && !(io->flag & EXT4_IO_END_UNWRITTEN)) {
>> -			io->flag = EXT4_IO_END_UNWRITTEN;
>> -			atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
>> +		if (io) {
>> +			if (!(io->flag & EXT4_IO_END_UNWRITTEN)) {
>> +				io->flag = EXT4_IO_END_UNWRITTEN;
>> +				atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
>> +			}
>>  		} else
>>  			ext4_set_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN);
>>  		if (ext4_should_dioread_nolock(inode))
>> @@ -3572,9 +3574,11 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>>  		 * that we need to perform conversion when IO is done.
>>  		 */
>>  		if ((flags & EXT4_GET_BLOCKS_PRE_IO)) {
>> -			if (io && !(io->flag & EXT4_IO_END_UNWRITTEN)) {
>> -				io->flag = EXT4_IO_END_UNWRITTEN;
>> -				atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
>> +			if (io) {
>> +				if (!(io->flag & EXT4_IO_END_UNWRITTEN)) {
>> +					io->flag = EXT4_IO_END_UNWRITTEN;
>> +					atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
>> +				}
>>  			} else
>>  				ext4_set_inode_state(inode,
>>  						     EXT4_STATE_DIO_UNWRITTEN);
> 

