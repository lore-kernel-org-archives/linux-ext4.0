From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Mon, 5 Mar 2007 01:36:36 +0100
Message-ID: <200703050136.37181.arnd@arndb.de>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <45EB4A55.3060908@redhat.com> <20070305001621.GB18691@lazybastard.org>
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
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@lazybastard.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.174]:52945 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbXCEAhk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Mar 2007 19:37:40 -0500
In-Reply-To: <20070305001621.GB18691@lazybastard.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Monday 05 March 2007, J=C3=B6rn Engel wrote:
> That actually causes an interesting problem for compressing filesyste=
ms.
> The space consumed by blocks depends on their contents and how well i=
t
> compresses. =C2=A0At the moment, the only option I see to support
> posix_fallocate for LogFS is to set an inode flag disabling compressi=
on,
> then allocate the blocks.
>=20
> But if the file already contains large amounts of compressed data, I
> have a problem. =C2=A0Disabling compression for a range within a file=
 is not
> supported, so I can only return an error. =C2=A0But which one?

Using the current glibc implementation on a compressed file system idea=
lly
should be a very expensive no-op because you won't actually allocate mu=
ch
space for a file when writing zeroes to it. You also don't benefit of a
contiguous allocation in logfs, since flash has uniform seek times over
all the medium.

I'd suggest you implement posix_fallocate as an real nop and just retur=
n
success without doing anything. You could also return ENOSPC in case
the blocks requested by posix_fallocate don't fit on the medium without
compression, but that is more or less just guesswork (like statfs is).

	Arnd <><
