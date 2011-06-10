From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: 64bit filesystem questions
Date: Fri, 10 Jun 2011 17:21:04 -0400
Message-ID: <4DF28AC0.2010505@cfl.rr.com>
References: <4DF0DA54.1080005@cfl.rr.com> <692307AB-41C8-4BC7-9D01-E5798CAB3548@dilger.ca> <4DF23611.7000307@cfl.rr.com> <7CFF213A-00F5-4E6B-A31C-F17FAA2FFB04@dilger.ca> <4DF250F6.2000206@cfl.rr.com> <3D6EAD75-AD40-4761-91E4-9245B26536C7@dilger.ca> <4DF25830.3030609@cfl.rr.com> <9500D51F-7E89-41F2-9A77-0E1A79136240@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:35902 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab1FJVVG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2011 17:21:06 -0400
In-Reply-To: <9500D51F-7E89-41F2-9A77-0E1A79136240@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/10/2011 4:37 PM, Andreas Dilger wrote:
> I hope it is obvious that a single bitmap block can only address the number
> of bits (==blocks) that fit within that block.  To address more blocks the
> block bitmap needs to be larger than a single block in size.  One possible
> way to do this (discussed early on for ext4) would be to have N block
> bitmap blocks per group.  That raises issues of how to address those blocks
> for each "block group", and what the meaning of a "block group" really is.

I thought it was obvious that if there were more blocks, then you would 
have more than one bitmap block and it would just follow the first.

> The other (very similar, but not identical) approach is to essentially merge
> N adjacent "block groups" into a single "large block group" that has N block
> bitmaps, and addresses N * blocksize * 8 blocks per "large block group".
> In this case "N" is the flex_bg factor (constrained to 2^n), and the "large
> block group" is called a "flex group".  It achieves exactly the same thing
> as having N block bitmaps per group, with the only difference that there are
> N group descriptors that point to the bitmaps, and they no longer have to be
> located within the groups themselves

The other side effect is that you have N inode tables and N inode 
bitmaps.  A typical fs these days seems to have 8192 inodes in each bg, 
which gives far more inodes than needed, and only uses 1/4 of the inode 
bitmap block.

Now that I've looked a bit more at the code, it seems the 32k block 
limit comes from the old ext2 block group descriptor only having a 16 
bit field for the free blocks count.  This was fixed in the ext4 bg 
descriptor, but it seems that is not actually used except on a 64bit fs. 
  It looks like a few more bits of code need cleaned up to allow for 
more blocks per group when using 64bit.

> If you treat the four "bbbb" blocks as a single block bitmap, and "iiii"
> as a single inode bitmap, and the contiguous range of free blocks as a
> single group, it is exactly what you are asking for - a larger bitmap.

While each of those inode bitmaps may follow the previous, each one is 
typically only 1/4 used and the rest ignored.  It would be better to 
have only the single inode bitmap for a single, larger bg.
