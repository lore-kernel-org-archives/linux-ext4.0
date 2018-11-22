Return-Path: <SRS0=c0SX=OB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43858 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732941AbeKWIEl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 23 Nov 2018 03:04:41 -0500
Date: Thu, 22 Nov 2018 16:23:27 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/3] Fix panic with journal superblock flags printing.
Message-ID: <20181122212327.GA26402@thunk.org>
References: <20181119091650.81803-1-alexey.lyashkov@gmail.com>
 <20181119091650.81803-3-alexey.lyashkov@gmail.com>
 <20181121235432.GE10588@thunk.org>
 <EC847396-EE31-4F96-B8A9-3457FD1AC9F5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EC847396-EE31-4F96-B8A9-3457FD1AC9F5@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 22, 2018 at 07:24:17AM +0300, Alexey Lyashkov wrote:
> 1024 is jbd superblock size, and this constant widely used over e2fsprogs code.
> from this particular case it’s clear bug as jsb_buffer defined as.
> >>
>         char                    jsb_buffer[1024];

The jbd superblock size is 1024 bytes --- just as the ext4 superblock
is only 1024 bytes.  It may be *stored* in a 4k block, and the size of
the super block has nothingm to do with the size of the file system
block size.

It gets used here:

	if (exp_block_size != (int) ntohl(jsb->s_blocksize))
		fprintf(f, "Journal block size:       %u\n",
			(unsigned int)ntohl(jsb->s_blocksize));

The normal case is when the journal superblock size is the same as the
file system block size, and in that case, there's no reason to print
the journal block size.  It *can* happen where the journal block size
can be different from the file system block size.  The most likely
case is the one where an external journal is in use, and the external
journal is shared between two file systems, one which uses (say) a 4k
block size, and the other uses (say) a 1k block size.  The data
structures support this mode, but what we don't have is e2fsck support
for handling a journal replay where the journal needs to be replayed
to two different file systems --- especially if one of the block
device is temporarily unavailable.

So that's why this is there, and in fact it's intentional that it's
done this way.

Cheers,

						- Ted
