From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] ext2/3/4: change i_mutex usage on lseek
Date: Thu, 15 Jan 2009 13:40:55 +0900
Message-ID: <6.0.0.20.2.20090115133545.070537b8@172.19.0.2>
References: <6.0.0.20.2.20090106134318.06709010@172.19.0.2>
 <1231993950.9468.8.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:49720 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbZAOEnl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Jan 2009 23:43:41 -0500
In-Reply-To: <1231993950.9468.8.camel@norville.austin.ibm.com>
References: <6.0.0.20.2.20090106134318.06709010@172.19.0.2>
 <1231993950.9468.8.camel@norville.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.
Thank you for your comment.

At 13:32 09/01/15, Dave Kleikamp wrote:
>On Thu, 2009-01-15 at 09:32 +0900, Hisashi Hifumi wrote:
>> Hi.
>> 
>> I wrote some patch that changed a range of i_mutex on ext2/3/4's lseek.
>> Ext2/3/4 uses generic_file_llseek, this function is inside i_mutex.
>> I think there is room for optimization in some cases.
>> When SEEK_END is specified from caller, in this case we should handle
>> inode->i_size so i_mutex is needed. But in other cases such as SEEK_CUR or
>> SEEK_SET, i_mutex is not needed because just changing file->f_pos value without
>> touching i_size.
>
>Is there any reason you couldn't have just changed generic_file_llseek()
>to do this rather than making identical changes to the individual file
>systems.  I would think this optimization would be safe for any file
>system.
>

I agree with you. I think changing generic_file_llseek() directly does not hurt
file system functionality.
I will send a patch changing generic_file_llseek().



>> I did some test to measure i_mutex contention.
>> This test do:
>> 	1. make an 128MB file.
>> 	2. fork 100 processes. repeat 10000000 times lseeking randomly on each 
>process to this file.
>> 	3, gauge seconds between start and end of this test.
>> 
>> The result was:
>> 
>> 	-2.6.29-rc1
>> 	# time ./lseek_test
>> 	315 sec
>> 
>> 	real    5m15.407s
>> 	user    1m19.128s
>> 	sys     5m38.884s
>> 
>> 	-2.6.29-rc1-patched
>> 	# time ./lseek_test
>> 	13 sec
>> 
>> 	real    0m13.039s
>> 	user    1m14.730s
>> 	sys     2m9.633s 
>> 
>> Hardware environment:
>> CPU　2.4GHz(Quad Core) *4
>> Memory 64GB
>> 
>> This improvement is derived from just removal of lseek's i_mutex contention.
>> There is i_mutex contention not only around lseek, but also fsync or write.
>> So,  I think we also can mitigate i_mutex contention between fsync and lseek.
>> 
>> Thanks.
>> 
>> Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
>> 
>> diff -Nrup linux-2.6.29-rc1.org/fs/ext2/file.c linux-2.6.29-rc1/fs/ext2/file.c
>> --- linux-2.6.29-rc1.org/fs/ext2/file.c	2008-12-25 08:26:37.000000000 +0900
>> +++ linux-2.6.29-rc1/fs/ext2/file.c	2009-01-13 11:58:16.000000000 +0900
>> @@ -38,12 +38,24 @@ static int ext2_release_file (struct ino
>>  	return 0;
>>  }
>> 
>> +static loff_t ext2_file_llseek(struct file *file, loff_t offset, int origin)
>> +{
>> +	loff_t retval;
>> +
>> +	if (origin == SEEK_END)
>> +		retval = generic_file_llseek(file, offset, origin);
>> +	else
>> +		retval = generic_file_llseek_unlocked(file, offset, origin);
>> +
>> +	return retval;
>> +}
>> +
>>  /*
>>   * We have mostly NULL's here: the current defaults are ok for
>>   * the ext2 filesystem.
>>   */
>>  const struct file_operations ext2_file_operations = {
>> -	.llseek		= generic_file_llseek,
>> +	.llseek		= ext2_file_llseek,
>>  	.read		= do_sync_read,
>>  	.write		= do_sync_write,
>>  	.aio_read	= generic_file_aio_read,
>> @@ -62,7 +74,7 @@ const struct file_operations ext2_file_o
>> 
>>  #ifdef CONFIG_EXT2_FS_XIP
>>  const struct file_operations ext2_xip_file_operations = {
>> -	.llseek		= generic_file_llseek,
>> +	.llseek		= ext2_file_llseek,
>>  	.read		= xip_file_read,
>>  	.write		= xip_file_write,
>>  	.unlocked_ioctl = ext2_ioctl,
>> diff -Nrup linux-2.6.29-rc1.org/fs/ext3/file.c linux-2.6.29-rc1/fs/ext3/file.c
>> --- linux-2.6.29-rc1.org/fs/ext3/file.c	2008-12-25 08:26:37.000000000 +0900
>> +++ linux-2.6.29-rc1/fs/ext3/file.c	2009-01-13 11:58:16.000000000 +0900
>> @@ -106,8 +106,20 @@ force_commit:
>>  	return ret;
>>  }
>> 
>> +static loff_t ext3_file_llseek(struct file *file, loff_t offset, int origin)
>> +{
>> +	loff_t retval;
>> +
>> +	if (origin == SEEK_END)
>> +		retval = generic_file_llseek(file, offset, origin);
>> +	else
>> +		retval = generic_file_llseek_unlocked(file, offset, origin);
>> +
>> +	return retval;
>> +}
>> +
>>  const struct file_operations ext3_file_operations = {
>> -	.llseek		= generic_file_llseek,
>> +	.llseek		= ext3_file_llseek,
>>  	.read		= do_sync_read,
>>  	.write		= do_sync_write,
>>  	.aio_read	= generic_file_aio_read,
>> diff -Nrup linux-2.6.29-rc1.org/fs/ext4/file.c linux-2.6.29-rc1/fs/ext4/file.c
>> --- linux-2.6.29-rc1.org/fs/ext4/file.c	2009-01-13 11:55:09.000000000 +0900
>> +++ linux-2.6.29-rc1/fs/ext4/file.c	2009-01-13 12:09:59.000000000 +0900
>> @@ -140,8 +140,20 @@ static int ext4_file_mmap(struct file *f
>>  	return 0;
>>  }
>> 
>> +static loff_t ext4_file_llseek(struct file *file, loff_t offset, int origin)
>> +{
>> +	loff_t retval;
>> +
>> +	if (origin == SEEK_END)
>> +		retval = generic_file_llseek(file, offset, origin);
>> +	else
>> +		retval = generic_file_llseek_unlocked(file, offset, origin);
>> +
>> +	return retval;
>> +}
>> +
>>  const struct file_operations ext4_file_operations = {
>> -	.llseek		= generic_file_llseek,
>> +	.llseek		= ext4_file_llseek,
>>  	.read		= do_sync_read,
>>  	.write		= do_sync_write,
>>  	.aio_read	= generic_file_aio_read,
>
>-- 
>David Kleikamp
>IBM Linux Technology Center

