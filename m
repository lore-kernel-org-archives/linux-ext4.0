From: raphel johnson <iraphel78@gmail.com>
Subject: Re: why online shrink is not supported with EXT4_IOC_RESIZE_FS?
Date: Thu, 30 Aug 2012 11:24:31 +0530
Message-ID: <CAMTyv-G6NKai1DRt6oMeeYZfekxz0mmL9p4ogZP52c7kxEYR8Q@mail.gmail.com>
References: <CAMTyv-FXzP-r3Eq3kuUQQsE221aNR1nGsfyEZ=w8eHo1eBL1SQ@mail.gmail.com>
	<651BBBE5-D7E1-43C5-BC21-7E56CF12848C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44720 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2H3Fyb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Aug 2012 01:54:31 -0400
Received: by obbuo13 with SMTP id uo13so2619417obb.19
        for <linux-ext4@vger.kernel.org>; Wed, 29 Aug 2012 22:54:31 -0700 (PDT)
In-Reply-To: <651BBBE5-D7E1-43C5-BC21-7E56CF12848C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

Thanks a lot for your reply.

Regards,
Raphel


On Mon, Aug 27, 2012 at 11:21 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On 2012-08-27, at 7:30 AM, raphel johnson wrote:
>> I was referring EXT4_IOC_RESIZE_FS ioctl implementation in linux
>> kernel ver 3.3.8.
>>
>> It is given in the code that online shrinking not supported.
>>
>> if (n_blocks_count < o_blocks_count) {
>> /* On-line shrinking not supported */
>> ext4_warning(sb, "can't shrink FS - resize aborted");
>> return -EINVAL;
>> }
>>
>> I am new to ext4 file system. Could you please tell online shrinking
>> issues in ext4.
>>
>> Thanks in adavance.
>
> There are several reasons for this:
> - if blocks are in use beyond the new end of the filesystem, potentially
>   all inodes in the filesystem need to be scanned to find the owner
> - this also causes consistency issues with the page cache, since moving
>   in-use disk blocks is tricky, and it isn't always possible to remove
>   them from memory
> - if in-use inodes are beyond the end of the new filesystem, potentially
>   all of the directories in the filesystem need to be scanned to find the
>   parent directory
> - moving inodes in ext4 will also cause the inode number to change, which
>   would break NFS and potentially other programs
>
> In the end, rarely do users need to shrink a filesystem while mounted, so
> the effort and complexity of doing this isn't worthwhile.
>
> Cheers, Andreas
>
>
>
>
>
