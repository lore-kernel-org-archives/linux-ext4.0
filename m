From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [sparc64] sigbus in e2fsck
Date: Tue, 30 Aug 2016 10:58:10 -0400
Message-ID: <20160830145810.rgms25xlnatnyxir@thunk.org>
References: <CADxRZqwws+5t-hjO=70yP84p4+1_YYZO5ER3-=faFh1JbWjTeA@mail.gmail.com>
 <6a774a5e-b2e5-6276-c272-2b737bd098f0@physik.fu-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Anatoly Pugachev <matorola@gmail.com>, linux-ext4@vger.kernel.org,
        debian-sparc <debian-sparc@lists.debian.org>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51698 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753053AbcH3O6R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 30 Aug 2016 10:58:17 -0400
Content-Disposition: inline
In-Reply-To: <6a774a5e-b2e5-6276-c272-2b737bd098f0@physik.fu-berlin.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 30, 2016 at 02:56:45PM +0200, John Paul Adrian Glaubitz wrote:
> On 08/30/2016 02:42 PM, Anatoly Pugachev wrote:
> > ../../e2fsck/recovery.c:866
> > 866                             blocknr = ext2fs_be64_to_cpu(* ((__u64
> > *) (bh->b_data+offset)));
> 
> The reason is that this expression is casting "char * b_data" [1] into u64 [2]
> which provokes unaligned access. Since such expression are often inevitable,
> it's probably best to modify the conversion macros in bitops.h [3] to be
> safe against unaligned accesses.

I don't think that's it.  b_data is a 4k buffer should be 8 byte
aligned.  For a file system with 64-bit blocks (which you presumably
have since we're on the be64 path as shown in your debugger output)
the offset is initially set to 16, and is incremented in chunks of 8
bytes.  So there shouldn't be any unaligned access.

Since you are able to provke this in a debugger, can you have gdb
print out the value of bh->b_data and offset, so we can be sure what's
going on?

I do see a potential problem which is that we're defining
journal_revoke_header_t structure in a non-portable way:

typedef struct journal_header_s
{
	__u32		h_magic;
	__u32		h_blocktype;
	__u32		h_sequence;
} journal_header_t;

typedef struct journal_revoke_header_s
{
	journal_header_t r_header;
	int		 r_count;	/* Count of bytes used in the block */
} journal_revoke_header_t;

The "int" above should be a __u32.  What is the size of int on
sparc64?  Is it by any chance 8 bytes?  If that's the problem then I'm
kind of surprised we haven't run into massive problems earlier, as
this looks like a long standing bug.

							- Ted
