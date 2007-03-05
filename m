From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Mon, 5 Mar 2007 00:32:14 +0000
Message-ID: <CDA7A0DF-D744-416F-83B1-76C148B46A5F@cam.ac.uk>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <1172789056.11165.42.camel@kleikamp.austin.ibm.com> <20070301233819.GB31072@infradead.org> <200703032345.33137.arnd@arndb.de> <0DA8B217-DDD4-4E05-B000-DEBE3BE55B94@cam.ac.uk> <45EB4A55.3060908@redhat.com> <20070305001621.GB18691@lazybastard.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=ISO-8859-1;
	delsp=yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ulrich Drepper <drepper@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com
To: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ppsw-3.csi.cam.ac.uk ([131.111.8.133]:34221 "EHLO
	ppsw-3.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbXCEAca convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Mar 2007 19:32:30 -0500
In-Reply-To: <20070305001621.GB18691@lazybastard.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


On 5 Mar 2007, at 00:16, J=F6rn Engel wrote:

> On Sun, 4 March 2007 14:38:13 -0800, Ulrich Drepper wrote:
>>
>> When you do it like this, who can the kernel/filesystem =20
>> *guarantee* that
>> when the data is written there actually is room on the harddrive?
>>
>> What you described seems like using truncate/ftruncate to increase =20
>> the
>> file's size.  That is not at all what posix_fallocate is for.
>> posix_fallocate must make sure that the requested blocks on the =20
>> disk are
>> reserved (allocated) for the file's use and that at no point in the
>> future will, say, a msync() fail because a mmap(MAP_SHARED) page has
>> been written to.
>
> That actually causes an interesting problem for compressing =20
> filesystems.
> The space consumed by blocks depends on their contents and how well i=
t
> compresses.  At the moment, the only option I see to support
> posix_fallocate for LogFS is to set an inode flag disabling =20
> compression,
> then allocate the blocks.
>
> But if the file already contains large amounts of compressed data, I
> have a problem.  Disabling compression for a range within a file is =20
> not
> supported, so I can only return an error.  But which one?

I don't know how your compression algorithm works but at least on =20
NTFS that bit is easy: you allocate the blocks and mark them as =20
allocated then the compression engine will write non-compressed data =20
to those blocks.  Basically it works like this "does compression =20
block X have any sparse blocks?". If the answer is "yes" the block is =20
treated as compressed data and if the answer is "no" the block is =20
treated as uncompressed data.  This means that if the data cannot be =20
compressed (and in some cases if the data compressed is bigger than =20
the data uncompressed) the data is stored non-compressed.  That is =20
the most space efficient method to do things.

An alternative would be to allocate blocks and then when the data is =20
written perform the compression and free any blocks you do not need =20
any more because the data has shrunk sufficiently.  Depending on the =20
implementation details this could potentially create horrible =20
fragmentation as you would allocate a large consecutive region and =20
then go and drop random blocks from that region thus making the file =20
fragmented.

Best regards,

	Anton
--=20
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
