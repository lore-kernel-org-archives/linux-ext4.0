From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
Date: Thu, 25 Jul 2013 14:46:47 -0400
Message-ID: <20130725184647.GD15590@logfs.org>
References: <1374699833.7083.2.camel@localhost>
 <20130724233628.GD3641@logfs.org>
 <51F14136.30409@mozilla.com>
 <20130725180545.GB15590@logfs.org>
 <20130725200939.GH26554@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dhaval Giani <dgiani@mozilla.com>, linux-kernel@vger.kernel.org,
	tytso@mit.edu, tglek@mozilla.com, vdjeric@mozilla.com,
	glandium@mozilla.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Zach Brown <zab@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130725200939.GH26554@lenny.home.zabbo.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 25 July 2013 13:09:39 -0700, Zach Brown wrote:
>=20
> > > What about introducing a new flag, O_COMPR which tells the
> > > kernel, btw, we want this file to be decompressed if it can be. I=
t
> > > can fallback to O_RDONLY or something like that? That gets rid of
> > > the chattr ugliness.
> >=20
> > How is that different from chattr ugliness, which also comes down t=
o a
> > single flag? ;)
>=20
> It's much worse because it's per fd instead of per inode.
>=20
> The page cache, where the undisclosed complexity of this proposal lur=
ks,
> where compressed and uncompressed cached copies of the data need to b=
e
> managed somehow, is per inode.

You've been giving it away!  Bad Zach, no cookies tonight.

J=C3=B6rn

--
With a PC, I always felt limited by the software available. On Unix,
I am limited only by my knowledge.
-- Peter J. Schoenster
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
