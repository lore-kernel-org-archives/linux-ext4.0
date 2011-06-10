From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: 64bit filesystem questions
Date: Fri, 10 Jun 2011 14:37:11 -0600
Message-ID: <9500D51F-7E89-41F2-9A77-0E1A79136240@dilger.ca>
References: <4DF0DA54.1080005@cfl.rr.com> <692307AB-41C8-4BC7-9D01-E5798CAB3548@dilger.ca> <4DF23611.7000307@cfl.rr.com> <7CFF213A-00F5-4E6B-A31C-F17FAA2FFB04@dilger.ca> <4DF250F6.2000206@cfl.rr.com> <3D6EAD75-AD40-4761-91E4-9245B26536C7@dilger.ca> <4DF25830.3030609@cfl.rr.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:55794 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab1FJUhO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2011 16:37:14 -0400
In-Reply-To: <4DF25830.3030609@cfl.rr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-10, at 11:45 AM, Phillip Susi wrote:
> On 6/10/2011 1:29 PM, Andreas Dilger wrote:
>> On 2011-06-10, at 11:14 AM, Phillip Susi wrote:
>>> On 6/10/2011 12:19 PM, Andreas Dilger wrote:
>>>> I think in the presence of flex_bg this issue is moot.
>>> 
>>> What is the issue without flex_bg?
>> 
>> No "issue" really, just that the block/inode bitmaps are spread all over
>> the filesystem.  The original discussion was about whether there could be
>> "larger bitmaps that addressed more than 32768 blocks", which is essentially
>> what the flex_bg feature provides.  With flex_bg the bitmaps for different
>> groups will be allocated adjacent to each other on disk, and allow addressing
>> more than 32768 blocks without any seeking.
>> 
>> On large filesystems without flex_bg, the distribution of the bitmaps without
>> flex_bg means that a seek is needed to read each one, and given that spinning
>> disks have stayed at about 100 seeks/sec for decades it means 10+ minutes just
>> to read all of the bitmaps.
>> 
>> On my 2TB 5400 RPM SATA drive, e2fsck time went from ~20 minutes to ~3 minutes
>> by copying the data to a new ext4 filesystem with flex_bg + extents.  For a
>> fair comparison, I then reformatted the original (identical) disk without
>> flex_bg or extents and copied the data back, so that there wasn't any unfair
>> comparison between the newly-formatted filesystem and the old fragmented one.
> 
> I know what flex_bg is; what I don't understand is what it has to do with the limit on the size of a block group.  Whether the block bitmaps are stored in their native block group, or clustered up with flex_bg does not seem to have anything to do with whether or not the size of the bitmap can exceed 32k blocks.

I hope it is obvious that a single bitmap block can only address the number
of bits (==blocks) that fit within that block.  To address more blocks the
block bitmap needs to be larger than a single block in size.  One possible
way to do this (discussed early on for ext4) would be to have N block
bitmap blocks per group.  That raises issues of how to address those blocks
for each "block group", and what the meaning of a "block group" really is.

The other (very similar, but not identical) approach is to essentially merge
N adjacent "block groups" into a single "large block group" that has N block
bitmaps, and addresses N * blocksize * 8 blocks per "large block group".
In this case "N" is the flex_bg factor (constrained to 2^n), and the "large
block group" is called a "flex group".  It achieves exactly the same thing
as having N block bitmaps per group, with the only difference that there are
N group descriptors that point to the bitmaps, and they no longer have to be
located within the groups themselves

There is virtually no difference between "larger bitmap" and "flex_bg":

"b"=block bitmap, "i"=inode bitmap, "."=data block

Non-flex_bg configuration for 4 groups * 32768 blocks:

bi...{32760}...bi...{32760}...bi...{32760}...bi...{32760}...

Each block bitmap addresses 32768 blocks in total (including itself).

flex_bg configuration for the same 4 groups * 32768 blocks:

bbbbiiii.....................{131020}.......................

If you treat the four "bbbb" blocks as a single block bitmap, and "iiii"
as a single inode bitmap, and the contiguous range of free blocks as a
single group, it is exactly what you are asking for - a larger bitmap.

Cheers, Andreas





