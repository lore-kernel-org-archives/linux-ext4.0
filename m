From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Ext4 bigalloc and sparc ext3 16k blocksize
Date: Fri, 20 Jan 2012 15:57:16 -0700
Message-ID: <A412940F-4D2C-4849-83B6-53EAF75262A7@dilger.ca>
References: <CALbEkhsi=Nqz=rfOApPsFi_Bk+cR5NE-VXcvVEZB3nC2MxebVA@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Robin Dong <sanbai@taobao.com>
To: Bluflonalgul <bluflonalgul@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:28785 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2ATW5R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Jan 2012 17:57:17 -0500
In-Reply-To: <CALbEkhsi=Nqz=rfOApPsFi_Bk+cR5NE-VXcvVEZB3nC2MxebVA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-01-20, at 4:20 AM, Bluflonalgul wrote:
> Some (misleading?) article on kernelnewbies.org said the new Ext4
> Bigalloc feature was about supporting block size up to 1MB.
> I tried to use this feature to read an ext3 fs with 16k blocksize made
> on a Linux Debian Sparc (NAS).
> But I couldn't read such filesystem with the Linux 3.2 kernel on x86
> PC... It fails to read fs structure (as it used to fail with previous
> kernels).

The bigalloc feature is not intended to be disk compatible with a
large blocksize filesystem, or no "feature" would be needed at all
besides increasing the blocksize in the superblock.

What it is intended to handle is efficient block allocation for large
file IO, by increasing the size of space allocation/tracking in the
block bitmap, without breaking the kernel paradigm of keeping block
size <= PAGE_SIZE.

This gives many of the benefits of having a large blocksize without
needing to change the whole kernel.

> Could someone point me to some documentation, or give me some clues:
> I'd like to understand what's wrong and if I can hope to read such fs
> with Linux on x86 (natively, without fusefs tricks or additional
> tools).

There was some work done by Robin Dong (2011-11-18) that would get us
most of the way to just handling large blocksize filesystems directly
by the kernel.  This might be facilitated by denying mmap access to
such filesystems, but for media/big data filesystems (as opposed to the
root fs) this is probably not a serious limitation.

I'm still interested to see a continuation of Robin's work, taking it
to just be disk compatible with large blocksize, even if it is not
possible to use mmap IO on such filesystems (always setting MNT_NOEXEC
on systems where PAGE_SIZE < blocksize and not supplying f_op->mmap
should work).

The reason that this is desirable is that it allows bypassing the 16TB
file size limitations, and it also allows mounting filesystems from
SPARC, PPC, and IA64 systems that were formatted in this manner and are
getting old and need replacing.

Cheers, Andreas





