From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/3] fs: add SEEK_HOLE and SEEK_DATA flags V4
Date: Wed, 25 May 2011 16:46:49 -0400
Message-ID: <4DDD6AB9.3030906@redhat.com>
References: <1306186991-1905-1-git-send-email-josef@redhat.com> <0E7B812A-4057-4EB8-93F5-79ED9FCE2CCD@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	sunil.mushran@oracle.com, viro@ZenIV.linux.org.uk
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651Ab1EYUq4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2011 16:46:56 -0400
In-Reply-To: <0E7B812A-4057-4EB8-93F5-79ED9FCE2CCD@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/25/2011 03:45 PM, Andreas Dilger wrote:
> On May 23, 2011, at 15:43, Josef Bacik wrote:
>> This just gets us ready to support the SEEK_HOLE and SEEK_DATA flags.  Turns out
>> using fiemap in things like cp cause more problems than it solves, so lets try
>> and give userspace an interface that doesn't suck.  We need to match solaris
>> here, and the definitions are
>>
>> diff --git a/fs/read_write.c b/fs/read_write.c
>> index 5520f8a..9c3b453 100644
>> --- a/fs/read_write.c
>> +++ b/fs/read_write.c
>> @@ -64,6 +64,23 @@ generic_file_llseek_unlocked(struct file *file, loff_t offset, int origin)
>> 			return file->f_pos;
>> 		offset += file->f_pos;
>> 		break;
>> +	case SEEK_DATA:
>> +		/*
>> +		 * In the generic case the entire file is data, so as long as
>> +		 * offset isn't at the end of the file then the offset is data.
>> +		 */
>> +		if (offset >= inode->i_size)
>> +			return -ENXIO;
>> +		break;
>> +	case SEEK_HOLE:
>> +		/*
>> +		 * There is a virtual hole at the end of the file, so as long as
>> +		 * offset isn't i_size or larger, return i_size.
>> +		 */
>> +		if (offset >= inode->i_size)
>> +			return -ENXIO;
>> +		offset = inode->i_size;
>> +		break;
>> 	}
> 
> What about all of the existing filesystems that currently just ignore
> values of "origin" that they don't understand?  Looking through those
> it appears that most of them will return "offset" for unknown values
> of "origin", which I guess is OK for SEEK_DATA, but is confusing for
> SEEK_HOLE.  Some filesystems will return -EINVAL for values of origin
> that are unknown.
> 

Yeah I just didn't want to do all that work until I was sure the base of
what I had was acceptable.  If people think this set is good to go then
I will go through and fix everybody who does their own lseek.

> Most of the filesystem-specific ->llseek() methods don't do any error
> checking on "origin" because this is handled at the sys_llseek() level,
> and hasn't changed in many years.
> 
> I assume this patch is also dependent upon the "remove default_llseek()"
> patch, so that the implementation of SEEK_DATA and SEEK_HOLE can be done
> in only generic_file_llseek()?
> 
> Finally, while looking through the various ->llseek() methods I notice
> that many filesystems return "i_size" for SEEK_END, which clearly does
> not make sense for filesystems like ext3/ext4 htree, btrfs, etc that
> use hash keys instead of byte offsets for doing directory traversal.
> The comment at generic_file_llseek() is that it is intended for use by
> regular files.
> 
> Should the ext4_llseek() code be changed to return 0x7ffffffff for the
> SEEK_END value?  That makes more sense compared to values returned for
> SEEK_CUR so that an application can compare the current "offset" with
> the final value for a progress bar.

So maybe we make SEEK_DATA/SEEK_HOLE only work on regular files and not
directories?  Sunil what does solaris do?  Thanks,

Josef
