From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: high write latency bug in ext3 / jbd in 3.4
Date: Mon, 13 Jan 2014 14:01:08 -0700
Message-ID: <99F82313-71DA-43E6-A071-05507183D481@dilger.ca>
References: <20140113201320.GD1214@kvack.org>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_E291466A-47E0-4087-B949-C5D72622AFFD"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35564 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaAMVBg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Jan 2014 16:01:36 -0500
Received: by mail-pa0-f51.google.com with SMTP id fb1so1599459pad.38
        for <linux-ext4@vger.kernel.org>; Mon, 13 Jan 2014 13:01:35 -0800 (PST)
In-Reply-To: <20140113201320.GD1214@kvack.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_E291466A-47E0-4087-B949-C5D72622AFFD
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Jan 13, 2014, at 1:13 PM, Benjamin LaHaise <bcrl@kvack.org> wrote:
> I've recently encountered a bug in ext3 where the occasional write
> is showing extremely high latency, on the order of 2.2 to 11 seconds
> compared to a more typical 200-300ms.  This is happening on a 3.4.67
> kernel.  When this occurs, the system is writing to disk somewhere
> between 290-330MB/s.  The test takes anywhere from 3 to 12 minutes
> into a run to trigger the high latency write.  During one of these
> high latency writes, vmstat reports 0 blocks being written to disk.
> The disk array being written to is able to write quite a bit faster
> (about ~770MB/s).
> 
> The setup is a bit complicated, but is completely reproducible.
> The workload consists of about 8 worker threads creating and then
> writing out spool files that are a little under 8MB in size.  After
> each write, the file and the directory it is in are then fsync()d.
> The latency measured is from the beginning open() of a spool file
> until the final fsync() completes.
> 
> Poking around the system with latencytop shows that sleep_on_buffer()
> is where all the latency is coming from, leading to log_wait_commit()
> showing the very high latency for the fsync()s.  This leads me to
> believe that jbd is somehow not properly flushing a buffer being
> waited on in a timely fashion.  Changing elevator in use has no effect.
> 
> Does anyone have any ideas on where to look in ext3 or jbd for something
> that might be causing this behaviour?  If I use ext4 to mount the ext3
> filesystem being tested, the problem goes away.  Testing on newer
> kernels is not very easy to do (the system has other dependencyies on
> the 3.4 kernel).  Thoughts?

Not to be flippant, but is there any reason NOT to just mount the
filesystem with ext4?  There are a large number of improvements in
the ext4 code that don't require on-disk format changes (e.g. delayed
allocation, multi-block allocation, etc) if there is a concern about
being able to downgrade to an ext3-type mount in case of problems.

There are further improvements in ext4 that can be used on upgraded
ext3 filesystems if the feature bit is enabled (in particular extent
mapped files).  However, extent mapped files are not accessible under
ext3, so it makes sense to run with ext4 w/o any new features for a
while until you are sure it is working for you.

Using delalloc, mballoc, and extents can reduce application visible
read, write, and unlink latency significantly, because the blocks are
being allocated and freed in contiguous chunks after the file is
written from userspace.

We've been discussing deleting the ext3 code in favour of ext4 for
a while already, and newer Fedora and RHEL kernels are using the
ext4 code to mount ext2- and ext3-formatted filesystems for a while
already.

Cheers, Andreas






--Apple-Mail=_E291466A-47E0-4087-B949-C5D72622AFFD
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUtRUFHKl2rkXzB/gAQILlxAAmGHNWbHB61QUSi50UQ4RvvVpYvkFNlA1
kb/2B8GDgt2wYu0ugJywf02YB65NIF4NtagLdhCab/4F3phzCn7yXNZCzfcb2zG8
U7T2HlE8CTR3fS65EuYMAlKFf0VFvKI6nATNbtFis240+okHlw8Nj8tYOyUKtgSo
d+oHVjQlkLltU8Iz8Ujre+VsyW1Vrz4c6FOdRKfEZkhcBj7PaqYIs1xR3wyH3Ob1
adCYIO5byB2PFyf1fdrhZgiERHOrakSnaTyW4IxWm0fQKdofUbFkXPBGgWkdYyiA
zs0/hTxqaxGg0htpixb52moe8RiOB6eH7GnUiFD1oYmcuIWWQCa4225eBlU+/+NQ
eAyn/tDiEQzHbr6sV5jkU2dvcbmkD+WAzIeJ8na8m+eEc20uIDd7VyEl6C6tX61M
5wjhyjj+XnEcF4tGmdtgPYIOzLlJvSAs9CNavEby74wM5scBZLLCEB/tdTiaGnHf
476YqesrpJ83hhGEJnRm4v/W69CVoo9Bs+G4rp1YCnGP76VXhiVHVdxIn3dh66DT
b5TMm7XkJ6E9kSie8DY78mTJ1TKPX8lQzvD4nHxpubgitX0D3xXRJqJDBJMtKS8Z
vllWDd5Bwq7otYYUgD1xTrpJZctDXat4ZIGSfzGuHk7X1AX50kpsBfEGRBJya7J3
90MKn7FVuT0=
=1COM
-----END PGP SIGNATURE-----

--Apple-Mail=_E291466A-47E0-4087-B949-C5D72622AFFD--
