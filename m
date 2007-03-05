From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Mon, 5 Mar 2007 12:41:09 +0100
Message-ID: <20070305114109.GA454@lazybastard.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <45EB4A55.3060908@redhat.com> <20070305001621.GB18691@lazybastard.org> <200703050136.37181.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ulrich Drepper <drepper@redhat.com>,
	Anton Altaparmakov <aia21@cam.ac.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lazybastard.de ([212.112.238.170]:53693 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933460AbXCENDl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Mar 2007 08:03:41 -0500
Content-Disposition: inline
In-Reply-To: <200703050136.37181.arnd@arndb.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 5 March 2007 01:36:36 +0100, Arnd Bergmann wrote:
>=20
> Using the current glibc implementation on a compressed file system id=
eally
> should be a very expensive no-op because you won't actually allocate =
much
> space for a file when writing zeroes to it. You also don't benefit of=
 a
> contiguous allocation in logfs, since flash has uniform seek times ov=
er
> all the medium.
>=20
> I'd suggest you implement posix_fallocate as an real nop and just ret=
urn
> success without doing anything. You could also return ENOSPC in case
> the blocks requested by posix_fallocate don't fit on the medium witho=
ut
> compression, but that is more or less just guesswork (like statfs is)=
=2E

Quoting POSIX_FALLOCATE(3):
       The function posix_fallocate() ensures that disk space is alloca=
ted for
       the file referred to by the descriptor fd for the bytes  in  the=
 range
       starting  at  offset  and continuing for len bytes.  After a suc=
cessful
       call to posix_fallocate(), subsequent writes to bytes in the spe=
cified
       range are guaranteed not to fail because of lack of disk space.

       If  the  size  of  the  file  is less than offset+len, then the =
file is
       increased to this size; otherwise the file size is left unchange=
d.

Afaics, the (main) purpose of this function is not to decrease
fragmentation but to ensure mmap() won't cause any problems because the
medium fills up.  That problem exists for LogFS as well, once rw mmap()
is supported.

Simply returning success without doing anything would be a bug.  -ENOSP=
C
is a better choice, but still a lame implementation.  And falling back
on libc to write zeroes in a loop is an exercise in futility.

Does the allocation have to be persistent beyond lifetime of the file
descriptor?  It would be fairly simple to support the write guarantee
while the file is open (or rather the inode remains cached) and drop it
afterwards.

J=C3=B6rn

--=20
"[One] doesn't need to know [...] how to cause a headache in order
to take an aspirin."
-- Scott Culp, Manager of the Microsoft Security Response Center, 2001
