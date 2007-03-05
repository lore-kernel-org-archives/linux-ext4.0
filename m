From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Mon, 5 Mar 2007 01:44:54 +0100
Message-ID: <200703050144.55813.arnd@arndb.de>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070305001621.GB18691@lazybastard.org> <CDA7A0DF-D744-416F-83B1-76C148B46A5F@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?iso-8859-1?q?J=F6rn_Engel?= <joern@lazybastard.org>,
	Ulrich Drepper <drepper@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com
To: Anton Altaparmakov <aia21@cam.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:59099 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbXCEAqT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Mar 2007 19:46:19 -0500
In-Reply-To: <CDA7A0DF-D744-416F-83B1-76C148B46A5F@cam.ac.uk>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Monday 05 March 2007, Anton Altaparmakov wrote:
> An alternative would be to allocate blocks and then when the data is =
=A0
> written perform the compression and free any blocks you do not need =A0
> any more because the data has shrunk sufficiently. =A0Depending on th=
e =A0
> implementation details this could potentially create horrible =A0
> fragmentation as you would allocate a large consecutive region and =A0
> then go and drop random blocks from that region thus making the file =
=A0
> fragmented.

Unfortunately, this is not as easy on logfs, because there is no point
in allocating a block when there is no data to write into it. Fragmenta=
tion
on flash media is free, but you can never modify a block in place witho=
ut
erasing it first. This means it will always be written to a new locatio=
n
on the next write access.

One option that might work (similar to what you describe in your other =
mail)
is to have a per-inode count of reserved blocks, without allocating spe=
cific
blocks for them. The journal then needs to maintain the number of total
reserved blocks for all files and keep that in sync with blocks that we=
re
reserved for specific inodes.

	Arnd <><
