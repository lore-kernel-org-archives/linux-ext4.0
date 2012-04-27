From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC2] vfs: teach llseek about custom EOF values
Date: Thu, 26 Apr 2012 19:12:38 -0500
Message-ID: <4F99E476.5020106@redhat.com>
References: <4F98508A.2040506@redhat.com> <8D246A65-9F9D-4189-8EFB-59E19B5416A8@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758596Ab2D0AMl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Apr 2012 20:12:41 -0400
In-Reply-To: <8D246A65-9F9D-4189-8EFB-59E19B5416A8@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/26/12 6:42 PM, Andreas Dilger wrote:
...

>> /*
>> + * ext4_dir_llseek() uses generic_file_llseek() routines.
>> + * This handles both non-htree and htree directories, where the "offset"
>> + * is in terms of the filename hash value instead of the byte offset.
>> + *
>> + * For htree/dx dirs, the max offset and SEEK_END are both at
>> + * ext4_get_htree_eof.
>>  *
>>  * NOTE: offsets obtained *before* ext4_set_inode_flag(dir, EXT4_INODE_INDEX)
>>  *       will be invalid once the directory was converted into a dx directory
>> @@ -322,64 +325,23 @@ static inline loff_t ext4_get_htree_eof(struct file *filp)
>> loff_t ext4_dir_llseek(struct file *file, loff_t offset, int origin)
>> {
>> 	struct inode *inode = file->f_mapping->host;
>> 	int dx_dir = is_dx_dir(inode);
> 
> [Note: I trimmed the deleted lines, since it made the patch unreadable]
> 
> I like this patch, since it is quite clean and readable, and we aren't
> reimplementing the generic_file_llseek code.
> 
> The reasons why I prefer the variant that SEEK_END returns a hash value
> are twofold.  Firstly, it is just more consistent that if SEEK_CUR and
> SEEK_SET are using hash-offset values that SEEN_END also does the same.
> 
> Secondly, as for usefulness, I'm thinking of the case where there is
> a very large directory, and some application wants to process it in
> parallel.  It can call SEEK_END to get the "end" of the directory,
> regardless of whether this is a hash-offset directory or a file-offset
> directory (assuming SEEK_END is implemented correctly as in this patch),
> and then for each thread it can seek and process a part of the single
> directory in parallel (for each thread n of N):
> 
> 	loff_t end = llseek(dirfd, 0, SEEK_END);
> 
> 	thread_off = llseek(dirfd, n * (end / N), SEEK_SET);
> 
> I think this is a useful programming model, and that parallel processing
> of small directories has not been an issue in the past is no reason not
> to allow this in the future.  The application can still use "stat()" to
> find the actual file size, and it makes sense that the "seek space" for
> a file be consistent is just good programming practise. 
> 
> Cheers, Andreas

Ok, thanks.  Maybe I'll try to get it upstream... also:

>> +generic_file_llseek_size(struct file *file, loff_t offset, int origin,
>> +		loff_t maxsize)
>> +{
>> +	return generic_file_llseek_size(file, offset, origin, maxsize, 0);
>> +}
>> EXPORT_SYMBOL(generic_file_llseek_size);

Oops, realized I must have forgotten a patch refresh, this should be calling _size_eof.  Still, you get the idea.  I'll clean it up & try it upstream.

-Eric



