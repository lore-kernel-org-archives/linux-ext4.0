From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Commit c1a1e7fc24d6 causes segfault in ext2fs_new_inode
Date: Fri, 06 Apr 2012 12:31:25 -0700
Message-ID: <4F7F448D.5040808@redhat.com>
References: <20120330125726.GA26221@amd.home.annexia.org> <20120330131936.GB26221@amd.home.annexia.org> <4F760BC2.4070401@redhat.com> <20120406191401.GA8816@sli.dy.fi> <4F7F41C1.9010208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Richard W.M. Jones" <rjones@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Sami Liedes <sami.liedes@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab2DFTbg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Apr 2012 15:31:36 -0400
In-Reply-To: <4F7F41C1.9010208@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 4/6/12 12:19 PM, Eric Sandeen wrote:

...

> Thanks; I am actually just now testing my own patch, I wasn't sure if
> you were around and I wanted to get this fixed.  :)
> 
> Mine is more invasive, with all of the full-on inscrutable redirection
> mess every other bitmap function uses ;)  But maybe that's not necessary
> for this new function, since there will be no old users of it.
> 
> We probably need a way to test at least every binary in e2fsprogs
> with the 64-bit flags off, to be sure that old apps won't break.
> 
> For now I just edited every util which set the 64 bit flag and turned
> that off, and ran make check.
> 
> I may send my patch as well, and see what Ted thinks is the best
> fit for the current code layout... yours is simpler, and without
> any API concerns/constraints, it may be better.

Ok, I also tested your patch through make check
with the 64 bit flags off on all the normal utils, and it passed (for all
but the one test which exclusively requires 64-bit bitmaps).  It seems fine
to me, thanks.

However, there seems to be some unstated (?) naming convention about foo_bmap
(for 64-bit bitmaps) vs. foo_bitmap (for 32-bit bitmaps), and "bitmap2"
functions which seem to take 64-bit args, etc.  I'm not sure if this new
function needs to follow similar conventions...

My patch is probably overkill, so I won't bother to send it unless Ted
thinks something like that is necessary.  Documenting the api preservation
framework for 64-bit bitmaps would be really helpful, I think.

- -Eric
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPf0SMAAoJECCuFpLhPd7ggW4QAJPYaqG9iW6sSg60ySNPlXTW
OM7DF5CAvexUTXFChNyh8C40UpEEo8ms//Etc+G46vSoOjlg3ZvBbmP0fOk8hBhE
ejsNSATpBSwvrgzV8gBi5ZNK6WmefC8PxKXiw17p0gn5oYjKTfBmeFmEjx0oHEGV
zN/BYGDBnzE4n7BGfAACOOZy1HZsWMd2Ud57OpoCsxoB73JrHcz6MEkeGBFqrBBu
WIIPPt4jr6aaEbg2ofQkfJoP3FTHY/tVu8ozAakVWA9AQ/RC3S++9gH44ir4gfYS
PWHUJkNtHn9izcvIlUgly4Vn5s+/Fghyz09qc4LuEzZHwB2NpWHmDsKIrTsIrfWL
f0RI/8uhXdh6T8hhxcYOc0O0vz8iW3k286lr/FzHaX4kXj4yMw4Kf4sMds+v67Zf
aMaQLR+l/UBQeq/vdsrLJcVqMFXovGUH6zmzsplDv98Kl3Lt0gmQHpROqOZPENtb
wvR3ZU4eexcGQxSF0HZtbdhY/PemsYkdSceven5rGr9MXWJUkbhX0wSuXE8jnb7h
wRs/jAvLlAgaPgygAv7eYdccXl069vlFaFHDnoEePlK4lsPC8VpdisxECRjguyz1
nzM6fM9ci3KiGoFBvpwToRL4jos+fUlBnsLQ2v2x1kOGdq8jiJ9C4P3vuz6iE6ZY
WD5TAC8TAzy4+MSx7Gu+
=HKbk
-----END PGP SIGNATURE-----
