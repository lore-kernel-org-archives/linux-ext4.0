From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: flashing large eMMC partitions with ext4
Date: Wed, 27 Jul 2011 13:28:55 -0600
Message-ID: <4175633B-A521-4FD1-931F-01DA7DC12B54@dilger.ca>
References: <296456.55216.qm@web4205.mail.ogk.yahoo.co.jp>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, Andreas Dilger <aedilger@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	linux-ext4@vger.kernel.org
To: Round Robinjp <roundrobinjp@yahoo.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:63724 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab1G0UUv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Jul 2011 16:20:51 -0400
In-Reply-To: <296456.55216.qm@web4205.mail.ogk.yahoo.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-27, at 12:08 PM, Round Robinjp wrote:
> I have got some nice ideas from you.
> I summarize them here and add some comments.
> 
> o  Idea from Andreas
>    Create minimal image, flash write, then resize2fs
> 
>    -> Very straight forward idea.
>    -> Post-processing after flash writing adds some difficulties.

It would be possible to do the post-processing inside the kernel
initrd at first boot.  Adding the journal to the root filesystem
would need to be done before it is mounted, if your image does not
have the journal.  Adding a call to "resize2fs" if the filesystem
is not as large as the partition it is in is easy, and can be done
while the root filesystem is mounted.

> o  Idea from Ted
>    Zero-fill the non-used blocks.
>    Make the flash writer write only non-zero blocks.
> 
>    -> Very straight forward idea.
>    -> Flash writer needs to support this.
> 
> o  Idea from Amir
>    Set flex_bg to 32.

To be strictly correct, this should be (final_size / 128M).  For your
case of 4GB final size, a flex_bg factor of 32 is indeed correct.

You may also want to reduce the number of inodes in the image, by using
"-i" to specify a larger average file size.  Default is only 16kB average
file size, but if you know the usage model (e.g. MP3s or photos 4MB in
size) then you can create far fewer inodes (e.g. mke2fs -i 1048576).

>    Set sparse_super.
>    Allocate journal from group 0 (feasibility unclear)

If you are up for some coding to change mke2fs, being able to specify a
goal block for the journal is something that I've been interested in for
some time already.  Adding an option like "-J goal=0" would tell mke2fs
to start searching for free blocks at block 0 instead of the new default
journal goal of (blocks_count / 2).  I don't think this would be very
difficult to implement, and would very likely be accepted by Ted.

>    Truncate the image.

You should verify with dumpe2fs to check that there are no blocks in
use beyond the truncate range.

I like Amir's new suggestion better - create a small filesystem, fill
it up, then resize to the final size, then truncate down to the original
small filesystem size.  Depending on how the resize is done, it should
be possible to have all of the end groups be completely empty.

>    -> Feasibility and effectiveness is unclear.
>    -> Good side is legacy flash writer can be used.
> 
> o  Idea from Yongqiang
>    Delete journal before flash write and later add it back.
> 
>    -> Post-processing after flash writing adds some difficulties.
> 
> I will examine all of these to find out a suitable solution.
> Thanks
> Round


Cheers, Andreas





