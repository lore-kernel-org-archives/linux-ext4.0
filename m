From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] Add new extent structure in ext4
Date: Mon, 30 Jan 2012 15:52:23 -0700
Message-ID: <88F5A53E-188C-4513-BA1B-B838BF72760F@dilger.ca>
References: <CAFZ0FUXT-X146SEAHCcNh-bGARUTgLOSP1dCrqeOrT48REN+ow@mail.gmail.com> <4F270091.3050000@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Robin Dong <hao.bigrat@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:23772 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2A3WwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jan 2012 17:52:24 -0500
In-Reply-To: <4F270091.3050000@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-01-30, at 1:41 PM, Eric Sandeen wrote:
> On 1/23/12 6:51 AM, Robin Dong wrote:
>> After the bigalloc-feature is completed in ext4, we could have much more
>> big size of block-group (also bigger continuous space), but the extent
>> structure of files now limit the extent size below 128MB, which is not
>> optimal.
>> 
>> The new extent format could support 16TB continuous space and larger volumes.
> 
> (larger volumes?)

Strictly speaking, the current extent format "only" allows filesystems up
to 2^48 * blocksize bytes, typically 2^60 bytes.  That in itself is not a
significant limitation IMHO, since there are a number of other format-based
limitations in this area (number of group descriptor blocks, etc), and the
overall "do we realistically expect a single filesystem to be so big" that
cannot be fixed by simply increasing the addressable blocks per file.

Those format-based limits would not be present if we could handle a larger
blocksize for the filesystem, since the number of groups is reduced by
the square of the blocksize increase, as are a number of other limits.

>> What's your opinion?
> 
> I think that mailing list drama aside ;) Dave has a decent point that we
> shouldn't allow structures to scale out further than the code *using* them
> can scale.
> 
> In other words, if we already have some trouble being efficient with 2^32
> blocks in a file, it is risky and perhaps unwise to allow even larger files, until those problems are resolved.  At a minimum, I'd suggest that such a
> change should not go in until it is demonstrated that ext4 can, in general,
> handle such large file sizes efficiently.

I think the issue that Dave pointed out (efficiency of allocating large
files) is one that has partially been addressed by bigalloc.  Using bigalloc
allows larger clusters to be allocated much more efficiently, but it only
gets us part of the way there.

> It'd be nice to be able to self-host large sparse images for large fs
> testing, though.  I suppose bigalloc solves that a little, though with
> some backing store space usage penalty.  I suppose if a bigalloc fs is
> hosted on a bigalloc fs, things should (?) line up and be reasonable.

This is the one limitation of bigalloc - it doesn't change the underlying
filesystem blocksize.  That means the current extent format still cannot
address more than 2^32 blocks in a single file, so self-hosting filesystem
images over 16TB with 4kB blocksize is not possible with bigalloc.  It
_would_ be possible with a larger filesystem blocksize, and the bigalloc
code already paved the way for most of that to happen.

The joy of allowing large blocks for 4kB PAGE_SIZE is that it _doesn't_
involve an on-disk format change, and would have the added benefit that
it would allow mounting IA64, PPC, ARM, SPARC, etc. filesystems directly,
and facilitate migration or disaster recovery from those aging platforms.

Cheers, Andreas





