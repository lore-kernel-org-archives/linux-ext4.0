From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: Feature request: e2fsck -z
Date: Wed, 10 Aug 2011 09:22:40 +0100
Message-ID: <4E423FD0.40108@gmail.com>
References: <4E4173D4.9010104@zytor.com> <4E422686.8080207@gmail.com> <4420E0D8-5E16-4FD0-A7A9-B462F02D742D@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34390 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1HJIWq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Aug 2011 04:22:46 -0400
Received: by wwf5 with SMTP id 5so741012wwf.1
        for <linux-ext4@vger.kernel.org>; Wed, 10 Aug 2011 01:22:45 -0700 (PDT)
In-Reply-To: <4420E0D8-5E16-4FD0-A7A9-B462F02D742D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/10/2011 09:16 AM, Andreas Dilger wrote:
> On 2011-08-10, at 12:34 AM, Ric Wheeler wrote:
>> On 08/09/2011 06:52 PM, H. Peter Anvin wrote:
>>> Hi all,
>>>
>>> This is something I've wanted to see for a very long time, and it
>>> finally occurred to me that perhaps I should say something about it!
>>>
>>> It would be a very nice thing to have a flag to e2fsck, presumably -z,
>>> to zero out any unused data blocks, inodes and so on.  The goal is to
>>> minimize the amount of space required after compressing a virtual disk
>>> image or similar, and to make sure any non-data isn't lying around.
>> Do you need it to be in the fsck tool?
>>
>> If you have a sparsely allocated block map under your file system, doing a zero of all blocks could add hours for a big, slow S-ATA drives (2-3 hours for a 1TB drive).
> I think Ted has a tool that does this already.  It should be relatively simple oo do, like "dd if=/dev/zero of=/mountpoint/temp_zero_file&&  rm /mountpoint/temp_zero_file.

This will work but will be a potential multi-hour long process (and cause out of 
space errors at some point for other applications for a very brief window :))

>
>> An alternative for SSD's and devices that do TRIM/UNMAP would be to use one of the batched discard tools (that would make discarded data read back as zeroed).
> In fact, I thought Lukas has already made a tool for sending BLKDISCARD for all unused parts of the filesystem?
>
> Cheers, Andreas

Right, I think he has. That tool (not part of fsck) would do the job much 
quicker for enabled devices,

Ric

