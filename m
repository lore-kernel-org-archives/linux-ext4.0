From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Mon, 5 Mar 2007 00:16:21 +0000
Message-ID: <20070305001621.GB18691@lazybastard.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <1172789056.11165.42.camel@kleikamp.austin.ibm.com> <20070301233819.GB31072@infradead.org> <200703032345.33137.arnd@arndb.de> <0DA8B217-DDD4-4E05-B000-DEBE3BE55B94@cam.ac.uk> <45EB4A55.3060908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Anton Altaparmakov <aia21@cam.ac.uk>,
	Arnd Bergmann <arnd@arndb.de>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com
To: Ulrich Drepper <drepper@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45EB4A55.3060908@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 4 March 2007 14:38:13 -0800, Ulrich Drepper wrote:
>=20
> When you do it like this, who can the kernel/filesystem *guarantee* t=
hat
> when the data is written there actually is room on the harddrive?
>=20
> What you described seems like using truncate/ftruncate to increase th=
e
> file's size.  That is not at all what posix_fallocate is for.
> posix_fallocate must make sure that the requested blocks on the disk =
are
> reserved (allocated) for the file's use and that at no point in the
> future will, say, a msync() fail because a mmap(MAP_SHARED) page has
> been written to.

That actually causes an interesting problem for compressing filesystems=
=2E
The space consumed by blocks depends on their contents and how well it
compresses.  At the moment, the only option I see to support
posix_fallocate for LogFS is to set an inode flag disabling compression=
,
then allocate the blocks.

But if the file already contains large amounts of compressed data, I
have a problem.  Disabling compression for a range within a file is not
supported, so I can only return an error.  But which one?

J=C3=B6rn

--=20
A surrounded army must be given a way out.
-- Sun Tzu
-
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
