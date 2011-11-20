From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] dumpe2fs: dump blocks count used by super and GDT
Date: Sun, 20 Nov 2011 13:28:18 -0500
Message-ID: <20111120182818.GA12868@thunk.org>
References: <1321405328-5298-1-git-send-email-xiaoqiangnk@gmail.com>
 <20111120044310.GJ4130@thunk.org>
 <CAGBYx2Yca4EPk6ZZ8Q0jqbCxK9bURYcht9FKo9gcSWLmvVAMhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58634 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab1KTS2V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Nov 2011 13:28:21 -0500
Content-Disposition: inline
In-Reply-To: <CAGBYx2Yca4EPk6ZZ8Q0jqbCxK9bURYcht9FKo9gcSWLmvVAMhQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 20, 2011 at 03:08:23PM +0800, Yongqiang Yang wrote:
> Some users are confused by static metadata blocks allocated by extN
> file systems.   Blocks used as inode tables and bitmaps can be
> calculated by data from dumpe2fs.  However, blocks taken up by super
> blocks and GDT can not be calculated.   So this patch prints the
> number of blocks used by super blocks and GDT.   IMHO, it is useful
> for some users who know little about extN.   I met several users who
> ask why a fresh ext4 has used so many blocks compared to others.    I
> know most of them are used as inode tables.   Without this patch, we
> can explain the problem.   I just think we can explain the problem
> with explicit numbers with the patch.

The reason most of the users are complaining is not because of
superblocks and the GDT blocks, however.  It's really the inode table
blocks (somewhat), and especially, the 5% reserved blocks for root.
This is the sort of thing that's better explained in a FAQ entry,
since most users are also not likely to use dumpe2fs.

And if they are going to use dumpe2fs, I'd much rather the FAQ entry
explain it and they can then look at the details of the block layout
in the dumpe2fs output (i."e. dumpe2fs /dev/hdXX | grep superblock")
if they really need to count the number of superblocks.

   	       	       	     	 	   - Ted
