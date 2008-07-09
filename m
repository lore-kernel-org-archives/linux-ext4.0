From: Olaf =?iso-8859-2?Q?Fr=B1czyk?= <olaf@cbk.poznan.pl>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Wed, 09 Jul 2008 14:59:20 +0200
Message-ID: <1215608360.20914.14.camel@venus.local.navi.pl>
References: <20080709010922.GE9957@mit.edu>
	 <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu>
	 <20080709061621.GA5260@infradead.org>
	 <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu>
	 <20080708234120.5072111f@infradead.org>
	 <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu>
	 <20080708235502.1c52a586@infradead.org> <20080709071346.GS11558@disturbed>
	 <20080709110900.GI9957@mit.edu> <20080709114958.GV11558@disturbed>
	 <20080709122401.GK9957@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Arjan van de Ven <arjan@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>,
        hch@infradead.org, pavel@suse.cz, t-sato@yk.jp.nec.com,
        akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
        linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, mtk.manpages@googlemail.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <xfs-bounce@oss.sgi.com>
In-Reply-To: <20080709122401.GK9957@mit.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Wed, 2008-07-09 at 08:24 -0400, Theodore Tso wrote:
> On Wed, Jul 09, 2008 at 09:49:58PM +1000, Dave Chinner wrote:
> > (e) none of the above.  The kernel compilation will appear to pause
> > until the filesystem is unfrozen. No other visible effect should
> > occur. It will get blocked in a write or filesystem transaction
> > because the fs is frozen.
>=20
> So if the process which froze the filesystem accidentally tries
> writing to a log file (or database file containing the backup
> information, or whatever) that happens to be on the filesystem that is
> frozen, that process will get blocked and you end up in a deadlock;
> did I get that right?
Where do you see the deadlock?
The process doesn't have a lock on filesystem or something. You can
always unfreeze from another process.

Regards,

Olaf
--=20
Olaf Fr=C4=85czyk <olaf@cbk.poznan.pl>
