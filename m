From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Proposed design for big allocation blocks for ext4
Date: Fri, 25 Feb 2011 12:39:38 -0700
Message-ID: <F18281E8-0B93-44D8-A88B-4B822BDB9CC8@dilger.ca>
References: <E1PsnrK-0005r5-JH@tytso-glaptop> <1F9A85BD-4B5E-488C-B903-0AE17AACF2B7@dilger.ca> <CE75B187-E5BB-444E-9256-4DBF96B6DCDA@mit.edu> <AANLkTinYzZo+uxjZhO8VKu88UfBJ3RZQhfQK5qaHPwh-@mail.gmail.com> <20110225190436.GZ2924@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Amir Goldstein <amir73il@gmail.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:38798 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241Ab1BYTjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Feb 2011 14:39:40 -0500
In-Reply-To: <20110225190436.GZ2924@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-25, at 12:04 PM, Ted Ts'o wrote:
> On Fri, Feb 25, 2011 at 08:05:43PM +0200, Amir Goldstein wrote:
>> 
>> I like your design. very KISS indeed.
>> I am just wondering why should BIGALLOC be INCOMPAT and not RO_COMPAT?
>> After all, ro mount doesn't allocate and RO_COMPAT features are so muc
>> nicer...
> 
> I can try to make it be RO_COMPAT, but one thing my design changes is
> that a block group will contain 32768 allocation blocks; so assuming a
> 4k blocks, instead of a block group containing a maximum of 32,768 4k
> blocks comprising 128 MB, a block group would now contain 32,768 1M
> blocks, or 32 GiB, or 8,388,608 4k blocks.
> 
> I'm pretty sure that existing kernels have superblock sanity checks
> that will barf if they see this.  Still, yeah, I can try allocating
> this as a ROCOMPAT feature, and later on, if people really care, they
> can patch older kernels so they won't freak out when they see a
> BigAlloc file system and can thus successfully mount it read-only.
> 
> (Right now existing kernels will complain when s_blocks_per_group is
> greater than blocksize*8.)

Hmm, if we stuck with a flex_bg factor G >= the allocation blocksize (2^G * blocksize), then it would appear that the main difference is (2^G - 1) unused block bitmaps per flex_bg, and the single used block bitmap per group would be compressed 2^G:1 (i.e. it wouldn't represent a valid block bitmap to unaware kernels).  This would be OK for ROCOMPAT, like Amir wrote.

I guess the main difference is that there would still be 2^G more group descriptors to read/scan/write, though they would all be contiguous on disk.

To convert away from this feature on an old kernel would mean expanding each bit in flex_bg bitmap[0] by a factor 2^G and clearing the ROCOMPAT flag.

Cheers, Andreas





