From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] Add new extent structure in ext4
Date: Mon, 23 Jan 2012 16:17:43 -0700
Message-ID: <8211B159-17B7-4A5D-8E74-6B5D6A07DE6C@dilger.ca>
References: <CAFZ0FUXT-X146SEAHCcNh-bGARUTgLOSP1dCrqeOrT48REN+ow@mail.gmail.com> <20120123185933.GC9775@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Robin Dong <hao.bigrat@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:27809 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab2AWXRo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jan 2012 18:17:44 -0500
In-Reply-To: <20120123185933.GC9775@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-01-23, at 11:59 AM, Ted Ts'o wrote:
> On Mon, Jan 23, 2012 at 08:51:53PM +0800, Robin Dong wrote:
>> 
>> We could solve the problem by creating a new extent format to support
>> larger extent size, which looks like this:
>> 
>> struct ext4_extent2 {
>> 	__le64	ee_block;	/* first logical block extent covers */
>> 	__le64	ee_start;	        /* starting physical block */
>> 	__le32	ee_len;		/* number of blocks covered by extent */
>> 	__le32	ee_flags;	/* flags and future extension */
>> };
>> 
>> I think we could keep the structure of ext4_extent_header and add new
>> imcompat flag EXT4_FEATURE_INCOMPAT_EXTENTS2.
> 
> The really unfortunate thing about using a 24 byte on-disk extent
> structure is that you can only fit 2 extents in the inode before
> needing to spill out to an external header.
> 
> So being able to support multiple exent formats in the inode (by using
> a different eh_magic number) would probably be a good thing.  In fact,
> it might be useful to also have a version which looks like this:
> 
> struct ext4_extent_packed {
> 	__le32	ee_start_lo;
> 	__le16	ee_start_hi;
> 	__le16	ee_len;
> };
> 
> i.e., something which only takes 8 bytes, but which is only used for
> non-sparse files in the inode structure, so that you can fit 6 extents
> in the inode.

How does the code determine in advance whether a file is going to be
sparse or not?  Does this mean that the extents would have to be changed
as soon as a hole is added to a file?  That probably isn't bad if this
format is only used inside the inode, but would be very complex if it is
used for an indirect block.

Actually, my thought has been that it would be useful to have a new
"extent" format for block-mapped files that have fragmented on-disk
layout, like directories.

> The hard part will be cleaning up and refactoring the extent code to
> support multiple on-disk extent formats.  (That's going to be very
> messy, though!  So if we're going to go through all of that work, it
> would benice if it had advantages not for huge file systems, but also
> for desktop workloads.)  Once this investment gets done, supporting a
> third extent format should be relatively straight forward.

... and fourth...

> This would also allow us to make the new extent format be an RO_COMPAT
> feature, so that an existing ext4 file system could be converted to
> take advantage of the new extent encodings without needing to do a
> backup / reformat / restore pass.

How could a new extent format be RO_COMPAT?  Old kernels couldn't possibly
be able to read files with the new extent format.  I guess you are
thinking that they are RO_COMPAT in the sense of "they don't crash old
kernels, but new files cannot be read"?

Cheers, Andreas





