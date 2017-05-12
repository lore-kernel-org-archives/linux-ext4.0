From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: PAX: size overflow detected in function ext4_llseek
 fs/ext4/file.c:670
Date: Fri, 12 May 2017 01:02:34 -0400
Message-ID: <20170512050234.ohjoofele5gugxab@thunk.org>
References: <CABniQZMSW6DiSvJ7Y2TZTwUKX6sGH6-WkQRjL-kPOmdm7PnKHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, Pipacs <pageexec@gmail.com>,
        Brad Spengler <spender@grsecurity.net>
To: Shawn <citypw@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43616 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756874AbdELFCv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 12 May 2017 01:02:51 -0400
Content-Disposition: inline
In-Reply-To: <CABniQZMSW6DiSvJ7Y2TZTwUKX6sGH6-WkQRjL-kPOmdm7PnKHA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 12, 2017 at 12:10:04PM +0800, Shawn wrote:
> 
> thanks for the reports, keep them coming . this is an interesting one,
> here's the code (same at both lines in ext4_seek_hole and ext4_seek_data):
> 
> 670 »·······start = offset >> blkbits;
> 
> in types this is
> 
> u32 = long long >> int;
> 
> since the maximum value was exceeded it means that offset (long long,
> 64 bits even on 32 bit archs) had a value that didn't fit u32 when right
> shifted. based on some light code reading, blkbits is between 10-16 on
> ext4 (EXT4_MIN_BLOCK_SIZE-EXT4_MAX_BLOCK_SIZE) so depending on what the
> actual block size of the underlying filesystem was, offset must have been
> bigger than 2^42-2^48 (4TB-256TB).

Yes, this is indeed an interesting one.  I actually suspect that
offset was *negative*, and since start is a u32, this got translated
into a large number.

It is indeed a bug in ext4, although what we should do is an
interesting question, especially if I am correct that offset was in
fact negative.  The man page states:

       SEEK_DATA
              Adjust the file offset to the next location in the file
              greater than or equal to offset containing data.  If
              offset points to data, then the file offset is set to
              offset.

(and SEEK_HOLE is similar).  The man page leaves unspecified what to
do if offset is negative.  We could say that this is an invalid value,
and return -EINVAL.  Or we could say that since the next location in
the file greater to or equal to offset is obviously going to be a
positive number we could simply set offset to zero if it is negative.
e.g., should we add to the beginning of ext4_seek_data():

	if (offset < 0)
		return -EINVAL;

or

	if (offset < 0)
		offset = 0;

If offset really were a large number, it should have returned -ENXIO
due to this check in those functions:

	isize = i_size_read(inode);
	if (offset >= isize) {
		inode_unlock(inode);
		return -ENXIO;
	}

... and we do have checks in ext4_setattr() which doesn't allow i_size
to be set to a value larger than sb->s_maxbytes.  (Or
EXT4_SB(sb)->s_bitmap_maxbytes if the file is mapped using indirect
blocks.)  But since we do have maxbytes handy, we might as well add a
safety check:

	if (offset > maxsize)
		return -ENXIO;	/* or maybe -EINVAL; one could make an argument either way */

Still, it's possible for the file system to be corrupted such that the
on-disk i_size is large enough to allow offset to be insanely large.

The worse that will happen here is that we will return a bogus
location instead of returning an error, so the consequences of the
truncation are minor.  But we should properly reject the call with an
error if offset is insanely large, and decide what is the proper way
to respond if SEEK_HOLE or SEEK_DATA is passed a negative offset.

Cheers,

					- Ted
