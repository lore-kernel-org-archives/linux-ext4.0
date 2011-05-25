From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [PATCH 1/3] fs: add SEEK_HOLE and SEEK_DATA flags V4
Date: Wed, 25 May 2011 15:07:23 -0700
Message-ID: <4DDD7D9B.3060701@oracle.com>
References: <1306186991-1905-1-git-send-email-josef@redhat.com> <0E7B812A-4057-4EB8-93F5-79ED9FCE2CCD@dilger.ca> <4DDD6AB9.3030906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	viro@ZenIV.linux.org.uk
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:61561 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab1EYWHq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 May 2011 18:07:46 -0400
In-Reply-To: <4DDD6AB9.3030906@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/25/2011 01:46 PM, Josef Bacik wrote:
> On 05/25/2011 03:45 PM, Andreas Dilger wrote:
>> Most of the filesystem-specific ->llseek() methods don't do any error
>> checking on "origin" because this is handled at the sys_llseek() level,
>> and hasn't changed in many years.
>>
>> I assume this patch is also dependent upon the "remove default_llseek()"
>> patch, so that the implementation of SEEK_DATA and SEEK_HOLE can be done
>> in only generic_file_llseek()?
>>
>> Finally, while looking through the various ->llseek() methods I notice
>> that many filesystems return "i_size" for SEEK_END, which clearly does
>> not make sense for filesystems like ext3/ext4 htree, btrfs, etc that
>> use hash keys instead of byte offsets for doing directory traversal.
>> The comment at generic_file_llseek() is that it is intended for use by
>> regular files.
>>
>> Should the ext4_llseek() code be changed to return 0x7ffffffff for the
>> SEEK_END value?  That makes more sense compared to values returned for
>> SEEK_CUR so that an application can compare the current "offset" with
>> the final value for a progress bar.
> So maybe we make SEEK_DATA/SEEK_HOLE only work on regular files and not
> directories?  Sunil what does solaris do?  Thanks,

In Solaris the size of the directory appears to be equal to the number
of entries and the offset is the file#, so to speak. SEEK_DATA returns
the current offset and SEEK_HOLE the last one.

Just to be clear, I am not a Solaris expert. I just happen to have access
to it. ;)
