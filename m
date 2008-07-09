From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Wed, 9 Jul 2008 17:33:58 +1000
Message-ID: <20080709073358.GT11558@disturbed>
References: <20080708231026.GP11558@disturbed> <20080708232031.GE18195@elf.ucw.cz> <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <20080709065950.GR11558@disturbed> <E1KGTrq-0006qj-1u@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: arjan@infradead.org, hch@infradead.org, tytso@mit.edu,
	pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org,
	viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	axboe@kernel.dk, mtk.manpages@googlemail.com
To: Miklos Szeredi <miklos@szeredi.hu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E1KGTrq-0006qj-1u@pomaz-ex.szeredi.hu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 09, 2008 at 09:13:34AM +0200, Miklos Szeredi wrote:
> On Wed, 9 Jul 2008, Dave Chinner wrote:
> > The argument against Miklos' version is that there may be multiple
> > commands to execute while the fs is frozen.
>=20
> Which is what a shell is for ;)

Yeah, we=C4=BAl, with your method I ca't tell a user to:

	# xfs_freeze -f /mntpt
	# xfs_db -r -c 'sb 0' -c 'p rootino' /dev/foo
	128
	# xfs_db -r -c 'ino 128' -c 'p core.format' /dev/foo
	core.format =3D 2 (extents)
	# xfs_db .....
	.....
	# xfs_freeze -u /mntpt

i.e. using the freeze to force all metadata to disk and
prevent it from changing while doing interactive debugging
of some problem.

Yes, a one-shot freeze/unfreeze mechanism works for some
use cases. The point is that it does not work for them all.....

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
