From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: 64bit filesystem questions
Date: Fri, 10 Jun 2011 13:45:20 -0400
Message-ID: <4DF25830.3030609@cfl.rr.com>
References: <4DF0DA54.1080005@cfl.rr.com> <692307AB-41C8-4BC7-9D01-E5798CAB3548@dilger.ca> <4DF23611.7000307@cfl.rr.com> <7CFF213A-00F5-4E6B-A31C-F17FAA2FFB04@dilger.ca> <4DF250F6.2000206@cfl.rr.com> <3D6EAD75-AD40-4761-91E4-9245B26536C7@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:40614 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab1FJRpV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2011 13:45:21 -0400
In-Reply-To: <3D6EAD75-AD40-4761-91E4-9245B26536C7@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/10/2011 1:29 PM, Andreas Dilger wrote:
> On 2011-06-10, at 11:14 AM, Phillip Susi wrote:
>> On 6/10/2011 12:19 PM, Andreas Dilger wrote:
>>> I think in the presence of flex_bg this issue is moot.
>>
>> What is the issue without flex_bg?
>
> No "issue" really, just that the block/inode bitmaps are spread all over
> the filesystem.  The original discussion was about whether there could be
> "larger bitmaps that addressed more than 32768 blocks", which is essentially
> what the flex_bg feature provides.  With flex_bg the bitmaps for different
> groups will be allocated adjacent to each other on disk, and allow addressing
> more than 32768 blocks without any seeking.
>
> On large filesystems without flex_bg, the distribution of the bitmaps without
> flex_bg means that a seek is needed to read each one, and given that spinning
> disks have stayed at about 100 seeks/sec for decades it means 10+ minutes just
> to read all of the bitmaps.
>
> On my 2TB 5400 RPM SATA drive, e2fsck time went from ~20 minutes to ~3 minutes
> by copying the data to a new ext4 filesystem with flex_bg + extents.  For a
> fair comparison, I then reformatted the original (identical) disk without
> flex_bg or extents and copied the data back, so that there wasn't any unfair
> comparison between the newly-formatted filesystem and the old fragmented one.

I know what flex_bg is; what I don't understand is what it has to do 
with the limit on the size of a block group.  Whether the block bitmaps 
are stored in their native block group, or clustered up with flex_bg 
does not seem to have anything to do with whether or not the size of the 
bitmap can exceed 32k blocks.
