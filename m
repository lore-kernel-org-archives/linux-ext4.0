From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Beginner questions about ext4
Date: Sun, 23 Jun 2013 07:59:53 -0400
Message-ID: <20130623115953.GA16193@thunk.org>
References: <loom.20130612T140739-743@post.gmane.org>
 <loom.20130623T082353-563@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60409 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab3FWL75 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Jun 2013 07:59:57 -0400
Content-Disposition: inline
In-Reply-To: <loom.20130623T082353-563@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 23, 2013 at 06:29:18AM +0000, Felipe Monteiro de Carvalho wrote:
> 
> I am still very much interesting in knowing this! Are all groups flexible 
> groups when FLEX_BG feature is activated?
> 
> I found this image for how things relate to one another without flex_bg:
> 
> http://origin-ars.els-cdn.com/content/image/1-s2.0-S1742287612000357-gr1.jpg
> 
> Does anyone know if there is a simular image with flex_bg???

Historically, before flex_bg, the allocation bitmaps and inode tables
for a particular block group had to be located within that block
group, per the image that you've referenced above.

This had two difficulties.  The first is that every 128MB (assuming a
4k blocksize and the default/maximum number of blocks per block
group), there would be file system metadata, thus breaking up the
maximum contiguous free space available for data blocks.  The second
is that if e2fsck or resize2fs needed to relocate a metadata block, it
reduced the flexibility of where the new location of that metadata
block might be.

So the flex_bg feature relaxes this constraint.  So if we can put the
metadata blocks anywhere, where do we put them?  That's where
s_log_flex_bg_size in the superblock comes in.  This is a default
policy used by mke2fs and for online resizing where we try to put the
allocation bitmaps and inode table blocks at the beginning of a flex
group, where flex group N is defined as blocks falling within the
range (N * flex_bg_size) through (((N + 1) * flex_bg_size) - 1).

Note though that this is not a mandatory layout; there may be times
where e2fsck or resize2fs may need to change where these blocks end up
living.

The other thing which we do with this flex_bg layout is that it
influences ext4's inode and block allocation hueristcs.  For example,
ext4 will try to bias its allocation of directory blocks to try to
keep them within the first block group, and it will bias the
allocation of data blocks away from the first block group in a flex_bg
group.

Regards,

						- Ted
