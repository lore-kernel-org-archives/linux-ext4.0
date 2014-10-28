From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix overflow when updating superblock backups
 after resize
Date: Tue, 28 Oct 2014 16:40:59 -0400
Message-ID: <20141028204059.GC20378@thunk.org>
References: <1413988148-11433-1-git-send-email-jack@suse.cz>
 <alpine.LFD.2.00.1410221700200.2250@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	stable@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1410221700200.2250@localhost.localdomain>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 22, 2014 at 05:00:47PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Wed, 22 Oct 2014, Jan Kara wrote:
> > When there are no meta block groups update_backups() will compute t=
he
> > backup block in 32-bit arithmetics thus possibly overflowing the bl=
ock
> > number and corrupting the filesystem. OTOH filesystems without meta
> > block groups larger than 16 TB should be rare. Fix the problem by d=
oing
> > the counting in 64-bit arithmetics.
>=20
> Looks good, thanks.
>=20
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
