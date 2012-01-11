From: Kamal Mostafa <kamal@canonical.com>
Subject: Re: [PATCH v2 5/7] VFS: Avoid read-write deadlock in
 try_to_writeback_inodes_sb
Date: Wed, 11 Jan 2012 12:29:02 -0800
Message-ID: <1326313742.25050.137.camel@fourier>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
	 <1323367477-21685-6-git-send-email-kamal@canonical.com>
	 <20120106003533.GC3790@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-U2xfAI58b+tRyk5peQa0"
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Surbhi Palande <csurbhi@gmail.com>,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>
To: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120106003533.GC3790@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-U2xfAI58b+tRyk5peQa0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-01-06 at 01:35 +0100, Jan Kara wrote:
> On Thu 08-12-11 10:04:35, Kamal Mostafa wrote:
> > From: Valerie Aurora <val@vaaconsulting.com>
> >=20
> > Use trylock in try_to_writeback_inodes_sb to avoid read-write
> > deadlocks that could be triggered by freeze.

>   Christoph asked about what is the exact deadlock this patch tries to fi=
x.
> I don't think you answered that. So can you elaborate please? Is it someh=
ow
> connected with the fact that ext4 calls try_to_writeback_inodes_sb() with
> i_mutex held?
>=20
> 								Honza

This was discussed in the thread
http://www.spinics.net/lists/linux-fsdevel/msg48754.html
Summarizing...

Jan>   What's exactly the deadlock trylock protects from here?
Jan>   Or is it just an optimization?

Val>   The trylock is an optimization Dave Chinner suggested.  The first
Val>   version I wrote acquired the lock and then checked vfs_is_frozen().

Dave>  It's not so much an optimisation, but the general case of avoiding
Dave>  read-write deadlocks such that freezing can trigger. I think remount
Dave>  can trigger the same deadlock as freezing, so the trylock avoids
Dave>  both deadlock cases rather than just working around the freeze
Dave>  problem....

 -Kamal


> > BugLink: https://bugs.launchpad.net/bugs/897421
> > Signed-off-by: Valerie Aurora <val@vaaconsulting.com>
> > Cc: Kamal Mostafa <kamal@canonical.com>
> > Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
> > [kamal@canonical.com: patch restructure]
> > Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> > ---
> >  fs/fs-writeback.c |   13 ++++++++-----
> >  1 files changed, 8 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index ea89b3f..3a80f1b 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -1274,8 +1274,9 @@ EXPORT_SYMBOL(writeback_inodes_sb);
> >   * try_to_writeback_inodes_sb	-	start writeback if none underway
> >   * @sb: the superblock
> >   *
> > - * Invoke writeback_inodes_sb if no writeback is currently underway.
> > - * Returns 1 if writeback was started, 0 if not.
> > + * Invoke writeback_inodes_sb if no writeback is currently underway
> > + * and no one else holds the s_umount lock.  Returns 1 if writeback
> > + * was started, 0 if not.
> >   */
> >  int try_to_writeback_inodes_sb(struct super_block *sb, enum wb_reason =
reason)
> >  {
> > @@ -1288,15 +1289,17 @@ EXPORT_SYMBOL(try_to_writeback_inodes_sb);
> >   * @sb: the superblock
> >   * @nr: the number of pages to write
> >   *
> > - * Invoke writeback_inodes_sb if no writeback is currently underway.
> > - * Returns 1 if writeback was started, 0 if not.
> > + * Invoke writeback_inodes_sb if no writeback is currently underway
> > + * and no one else holds the s_umount lock.  Returns 1 if writeback
> > + * was started, 0 if not.
> >   */
> >  int try_to_writeback_inodes_sb_nr(struct super_block *sb,
> >  				   unsigned long nr,
> >  				   enum wb_reason reason)
> >  {
> >  	if (!writeback_in_progress(sb->s_bdi)) {
> > -		down_read(&sb->s_umount);
> > +		if (!down_read_trylock(&sb->s_umount))
> > +		    return 0;
> >  		if (nr =3D=3D 0)
> >  			writeback_inodes_sb(sb, reason);
> >  		else
> > --=20
> > 1.7.5.4
> >=20


--=-U2xfAI58b+tRyk5peQa0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJPDfEOAAoJEOf3EFVUCeQi2MgP/in+4Oox6XpRiKDQR6xlSziq
NTEr0GxiFqY5wg64PaJunHJW9c/yFP0qocWsHKm1YUEl6UI0v8VjwMo0T634rBkh
aUYjuHLHvwFjh54fK1Tq2eur/pPA6hzWuDvaGG5S506N4+TSSVpctSmVlUwh1E2+
25q5YfVicX+ym624kasGMWfEQ7a8n6Q53jVryGvSET38ml52BIjz0Jzf6UksC7Zc
J3l09WEIC0eO7RTgHFFD7D1PHxfFtBcloC3T6wP3cb/7Q5qOzTVcCNMHxO0rdX+c
POJP7722IGIxstkiOJjn3kAZg+pcRVhb9u4a9RSmkm/V2fHfhZ0f3oNqxOW/0r8G
sGxLXPa3OBVxHxzg8w3ePd+BI+PJjgADkxdAfua7m028ZVryKBMg1xi8jzLr29Nt
DOz7spHeCbizCGZS33g8nAbkwJnuw7qkeX+5rmtMPHuS+78uk/wE1G+MBalLpUO2
wMEL8dAOg7I/Mr9k2ADVL0IFXVlCdhxxnnNKbNXWgSU+LV7QR8Lnvt1XKXP/5D8+
GiCIK94cWIECYj3sDMBXDAO34CCofN60e3/5WcQJxzOGZtY+o7eTkidfmxwzQA6A
5ISG/2QueOU2oUyR3ErWWgHIJUCGr/VdkTsi/eBv9kS0sjtwjTQAVds7OuB/r8di
bZG28lJk08i9s/9mMxSi
=jaJy
-----END PGP SIGNATURE-----

--=-U2xfAI58b+tRyk5peQa0--

