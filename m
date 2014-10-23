From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 0/6] RFC: (partially) endian-annotate e2fsprogs
Date: Thu, 23 Oct 2014 17:56:30 -0600
Message-ID: <628B9FD2-9EF0-4849-84E0-D30C0B84CEFA@dilger.ca>
References: <54497296.8000708@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_9763122C-6F8C-47EB-ACF4-C2543D35AF6E"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33863 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaJWX4f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Oct 2014 19:56:35 -0400
Received: by mail-pa0-f49.google.com with SMTP id hz1so28986pad.8
        for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2014 16:56:35 -0700 (PDT)
In-Reply-To: <54497296.8000708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_9763122C-6F8C-47EB-ACF4-C2543D35AF6E
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Oct 23, 2014, at 3:26 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> This is really only partial, and in the end didn't spot any
> actual problems.  And things are a bit odd and tricky, because
> some structures (superblocks, inodes, etc) are swapped in-place
> in the same structure (so they can't be easily annotated - 
> if we wish to, we should define separate on-disk and in-memory
> structures).

Yeah, and this was a source of bugs in the past...  I wonder if
it would make sense to declare a different inode struct for use
in case EXT4_EXTENTS_FL is set so that it can declare i_block
in terms of extent structures?  Sadly, I recall that ext3_extent
and ext3_extent_idx do not have their fields aligned in the same
way, which makes swabbing sad...

> Further, i_block in the inode is sometimes swapped on read, and
> sometimes not (!), depending on whether it's indirect blocks,
> extents, or inline data.  So that's still messy too.
> 
> So this is really just kind of an RFC; I did it on a whim, and
> things aren't yet totally sparse-check clean, but figured I'd send
> it out and see what people think, whether it's worth merging,
> or working on cleaning up the above issues to make it all tidier.

I definitely think this is worthwhile.  I'd guess most people
contributing to e2fsprogs are already used to this from the kernel,
so it won't slow them down, and we almost certainly don't get
enough big-endian testing and this is at least a good way to catch
likely problems.

> (sparse is pretty good at looking for casts in and out of blk64_t
> too, though I haven't looked much at those.)
> 
> Thanks,
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_9763122C-6F8C-47EB-ACF4-C2543D35AF6E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVEmVrnKl2rkXzB/gAQK41g//VVS8xJHqN8WQPD5gdefbmRhHSyjh0+uX
k6KkF61oCCxJie6TON1c1uYkUggCIXu7IHvRv+e2HO9rTu/Up85bhx01C5eekL4E
HdPANjeHedympsysprf7+huKmp+atS3h8uIrTN8ioDhsCsvfF8cNlZARUO06EMMl
fdp7avAOtSQ1xRT395pSYkr3tsPxw+xPWPcczdUsEkSwVe8sKCtJ8tdr3HLG6UIM
0lXTyUPNubzlMA+dmNSVd8CECH6bF4BXhDTvd54vl1nVdGqYSBQ7ZMLNNERDdyiX
XfgPqDynd6mSAq/d/8nPhmv70hCz5TauT8nbbSSyluHLU45vUjxQiKkHK8SBTLhx
CC4Z8YsQbbcYnjUdqkB2JkospGvQixPi7CPXXn7Mjfn2uPTuMtke+9xcwwOWtfKi
iCXVvMS9hT72tFcp7Yy9ouB7FGrBuf/CvGjFsneYJ2bz+F89+ODMOlQVe78OByXV
c8z51xxZzPefZuIsGZDwtFYq5HxwseVkueI7LNC3rB9fdVaJr9BVqq/w/wwJPOwI
aB8Fb3C0694agNVG7nhxPCsjcKG1ztL6u81qxob/cL53gQ4407R1RQo8g3D7MwcL
8DpU+whx5B0OzwB20zHZvDq7cc1+xPzqh0n9G1evSNfg9NXxW0wawWr2UfGByqI2
eyQXFmAHl1c=
=/Kza
-----END PGP SIGNATURE-----

--Apple-Mail=_9763122C-6F8C-47EB-ACF4-C2543D35AF6E--
