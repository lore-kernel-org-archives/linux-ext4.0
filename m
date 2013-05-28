From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v4 00/20] change invalidatepage prototype to accept length
Date: Tue, 28 May 2013 07:21:44 -0400
Message-ID: <20130528112144.GA11839@thunk.org>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
 <alpine.LFD.2.00.1305211622330.2469@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, hughd@google.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1305211622330.2469@localhost>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 21, 2013 at 04:34:25PM +0200, Luk=C3=A1=C5=A1 Czerner wrote:
> On Tue, 14 May 2013, Lukas Czerner wrote:
>=20
> > Date: Tue, 14 May 2013 18:37:14 +0200
> > From: Lukas Czerner <lczerner@redhat.com>
> > To: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
> >     linux-ext4@vger.kernel.org, akpm@linux-foundation.org, hughd@goog=
le.com,
> >     lczerner@redhat.com
> > Subject: [PATCH v4 00/20] change invalidatepage prototype to accept l=
ength
>=20
> Hi Ted,
>=20
> you've mentioned that you'll carry the changed in the ext4 tree. Are
> you going to take it for the next merge window ?
>=20
> However I still need some review on the mm part of the series,
> Andrew, Hugh, anyone ?

The ext4 tree now has the the v4 version of hte invalidatepage range
patches in it.  So it will be showing up in the next linux-next tree,
for the convenience of the mm folks.  :-)

					- Ted

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
