From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH]: icount: Replace the icount list by a two-level tree
Date: Mon, 1 Nov 2010 17:23:48 -0600
Message-ID: <1C6D23BA-35F5-409F-A011-227E51075EB1@dilger.ca>
References: <20100818140422.GL27457@skl-net.de> <EDA85D20-C083-41FE-B561-8014C496C4CB@dilger.ca> <20100819130123.GU16603@skl-net.de> <ABE19F5B-74C8-47E9-B359-D3FB2C137087@dilger.ca> <20100820143943.GZ16603@skl-net.de> <20100823155259.GD16603@skl-net.de> <loom.20101101T234449-996@post.gmane.org>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Mala Iyer <malaiyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:17648 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab0KAXXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Nov 2010 19:23:49 -0400
In-Reply-To: <loom.20101101T234449-996@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-11-01, at 16:49, Mala Iyer wrote:
> We are trying to use e2fsck on a embedded system with almost 3GB of swap and
> 200MB of physical memory. e2fsck on a 16TB ext3 filesystem always appears to
> fail with the following error
> 
> Pass 1D: Reconciling multiply-claimed blocks
> e2fsck: Memory allocation failed while retrying to read bitmaps for /dev/sda1

As a general rule of thumb, expect to use 1 byte of RAM for every block in the filesystem.  For a 16TB filesystem (2^32 blocks) I would expect to need about 4GB of RAM, from past experience.

There is a considerable amount of RAM savings that could be had by implementing more efficient sparse bitmap support internal to libext2fs.  The code is structured and ready to do this, but nobody has had a real need to do it before now.

Some proposals were discussed in the past (see for example the brief description in https://bugzilla.lustre.org/show_bug.cgi?id=12202, and you can Google for the referenced thread in the archives) to use run-length-encoding of sparse bitmaps, or possibly rb-tree structures.  In most cases, the bitmaps will have long runs of either all-ones or all-zeroes, so I expect even simple RLE encoding could help significantly.  Since this is an internal implementation detail, the code can be changed in future releases without impacting interoperability.

Also, https://bugzilla.lustre.org/attachment.cgi?id=10088 has an out-of-date patch (see the "ebitmap.c" file) that you might consider using for reference, but I also believe the APIs in libext2fs have changed significantly, as has the desired implementation, so I doubt the patch is useful for anything except finding out which code to start changing.

Cheers, Andreas





