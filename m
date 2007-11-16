From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH] ext3,4:fdatasync should skip metadata writeout
Date: Fri, 16 Nov 2007 04:17:16 +0100
Message-ID: <20071116031716.GJ13834@lazybastard.org>
References: <6.0.0.20.2.20071116114652.03b9e4e8@172.19.0.2> <20071115185919.7df4cda9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20071115185919.7df4cda9.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 15 November 2007 18:59:19 -0800, Andrew Morton wrote:
> On Fri, 16 Nov 2007 11:47:27 +0900 Hisashi Hifumi <hifumi.hisashi@oss=
=2Entt.co.jp> wrote:
>=20
> > Currently fdatasync is identical to fsync in ext3,4.
> > I think fdatasync should skip journal flush in data=3Dordered and d=
ata=3Dwriteback mode
> > because this syscall is not required to synchronize the metadata.
>=20
> I suppose so.  Although one wonders what earthly point there is in sy=
ncing
> a file's data if we haven't yet written out the metadata which is req=
uired
> for locating that data.
>=20
> IOW, fdatasync() is only useful if the application knows that it is o=
verwriting
> already-instantiated blocks.
>=20
> In which case it might as well have used fsync().  For ext2-style fil=
esystems,
> anyway.

fsync() will sync an inode even if only i_atime was changed.
fdatasync() would ignore such changes.  I guess atime was the major
reason for creating fdatasync() in the first place.

The patch I sent you just minutes ago sorta documents this.
I_DIRTY_DATASYNC was added with patch-2.4.0-test12 for just this reason=
=2E

So basically an application can almost always use fdatasync() instead o=
f
fsync() and rely on the kernel to only cut corners, if doing so will no=
t
endanger the data synced to disk.

J=C3=B6rn

--=20
Joern's library part 6:
http://www.gzip.org/zlib/feldspar.html
-
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
