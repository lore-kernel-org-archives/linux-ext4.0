From: "PaX Team" <pageexec@freemail.hu>
Subject: Re: PAX: size overflow detected in function ext4_llseek fs/ext4/file.c:670
Date: Fri, 12 May 2017 11:58:54 +0200
Message-ID: <5915875E.15260.4679D7CA@pageexec.freemail.hu>
References: <CABniQZMSW6DiSvJ7Y2TZTwUKX6sGH6-WkQRjL-kPOmdm7PnKHA@mail.gmail.com>, <20170512050234.ohjoofele5gugxab@thunk.org>
Reply-To: pageexec@freemail.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, Brad Spengler <spender@grsecurity.net>,
        Emese Revfy <re.emese@gmail.com>
To: Shawn <citypw@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from r00tworld.com ([212.85.137.150]:43731 "EHLO r00tworld.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751442AbdELKk1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 12 May 2017 06:40:27 -0400
In-reply-to: <20170512050234.ohjoofele5gugxab@thunk.org>
Content-description: Mail message body
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12 May 2017 at 1:02, Theodore Ts'o wrote:

[added Emese to CC and thus kept the whole mail for context even if
i'm responding to some parts of it only]

> On Fri, May 12, 2017 at 12:10:04PM +0800, Shawn wrote:
> > 
> > thanks for the reports, keep them coming . this is an interesting one,
> > here's the code (same at both lines in ext4_seek_hole and ext4_seek_data):
> > 
> > 670 »·······start = offset >> blkbits;
> > 
> > in types this is
> > 
> > u32 = long long >> int;
> > 
> > since the maximum value was exceeded it means that offset (long long,
> > 64 bits even on 32 bit archs) had a value that didn't fit u32 when right
> > shifted. based on some light code reading, blkbits is between 10-16 on
> > ext4 (EXT4_MIN_BLOCK_SIZE-EXT4_MAX_BLOCK_SIZE) so depending on what the
> > actual block size of the underlying filesystem was, offset must have been
> > bigger than 2^42-2^48 (4TB-256TB).
> 
> Yes, this is indeed an interesting one.  I actually suspect that
> offset was *negative*, and since start is a u32, this got translated
> into a large number.

Shawn, can you do the printk instrumentation i suggested to print out
the value of offset (and isize too while at it)?

thing is, IIRC the C standard makes right shifting a negative value
implementation defined (so excluding such values would be good for that
reason alone) and i think gcc simply executes it as an arithmetic shift,
i.e., the sign of the result is preserved and thus the size overflow
checks should have detected a minimum violation, not the maximum one.

to tell for sure what check triggered exactly, i'd like to ask Shawn
to execute

	make fs/ext4/file.o EXTRA_CFLAGS="-fdump-tree-all -fdump-ipa-all"

and send us (Emese in particular) all the resulting files (fs/ext4/file.*)

> It is indeed a bug in ext4, although what we should do is an
> interesting question, especially if I am correct that offset was in
> fact negative.  The man page states:
> 
>        SEEK_DATA
>               Adjust the file offset to the next location in the file
>               greater than or equal to offset containing data.  If
>               offset points to data, then the file offset is set to
>               offset.
> 
> (and SEEK_HOLE is similar).  The man page leaves unspecified what to
> do if offset is negative.  We could say that this is an invalid value,
> and return -EINVAL.  Or we could say that since the next location in
> the file greater to or equal to offset is obviously going to be a
> positive number we could simply set offset to zero if it is negative.
> e.g., should we add to the beginning of ext4_seek_data():
> 
>  if (offset < 0)
>   return -EINVAL;
> 
> or
> 
>  if (offset < 0)
>   offset = 0;
> 
> If offset really were a large number, it should have returned -ENXIO
> due to this check in those functions:
> 
>  isize = i_size_read(inode);
>  if (offset >= isize) {
>   inode_unlock(inode);
>   return -ENXIO;
>  }

is it possible that isize was actually big enough itself to allow a large
enough positive offset pass this test (we'll know for sure if Shawn can
get the data i asked about)? what i'm basically asking is how the blocksize
is tied to the maximum possible file size. say, can one create a >4TB file
with a blocksize of 1024 bytes, etc? by the look of it, ext4_max_bitmap_size
would allow bigger files than that.

> ... and we do have checks in ext4_setattr() which doesn't allow i_size
> to be set to a value larger than sb->s_maxbytes.  (Or
> EXT4_SB(sb)->s_bitmap_maxbytes if the file is mapped using indirect
> blocks.)  But since we do have maxbytes handy, we might as well add a
> safety check:
> 
>  if (offset > maxsize)
>   return -ENXIO;	/* or maybe -EINVAL; one could make an argument either way */
> 
> Still, it's possible for the file system to be corrupted such that the
> on-disk i_size is large enough to allow offset to be insanely large.
> 
> The worse that will happen here is that we will return a bogus
> location instead of returning an error, so the consequences of the
> truncation are minor.  But we should properly reject the call with an
> error if offset is insanely large, and decide what is the proper way
> to respond if SEEK_HOLE or SEEK_DATA is passed a negative offset.
> 
> Cheers,
> 
>      - Ted
