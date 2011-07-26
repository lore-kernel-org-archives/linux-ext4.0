From: Jan Kara <jack@suse.cz>
Subject: Re: Checks in ext4_ext_fiemap_cb() broken
Date: Tue, 26 Jul 2011 14:12:25 +0200
Message-ID: <20110726121225.GC20131@quack.suse.cz>
References: <20110725155836.GF6107@quack.suse.cz>
 <CAGBYx2ZsxvmEcC0akMRQTgDWUmkUHOp=D4Ff69_pSMb+bGH5Sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Ted Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab1GZMMc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jul 2011 08:12:32 -0400
Content-Disposition: inline
In-Reply-To: <CAGBYx2ZsxvmEcC0akMRQTgDWUmkUHOp=D4Ff69_pSMb+bGH5Sg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Yongqiang,

On Tue 26-07-11 09:20:28, Yongqiang Yang wrote:
> I have been thinking if we can handle fiemap much simpler for a while=
=2E
>  Current code is very ugly due to page cache look up.  I have a
> thought on simplifying these code.  The reason leading us to looking
> up page cache is that delayed extents are not in extents tree.  I
> think we can add an in-memory delayed extents list in inode, and we
> can delete entries in the list after we allocate blocks for them.
> There is no limit on length of extents in the list, this way can an
> entry contain as many blocks as they are contiguous logically.
>=20
> What's your opinion?
  Yes, that should be doable and shouldn't have too big overhead. It's =
just
stupid we'll do all this stuff only for fiemap call which is relatively
rare.

								Honza

> On Mon, Jul 25, 2011 at 11:58 PM, Jan Kara <jack@suse.cz> wrote:
> > =A0Hello,
> >
> > =A0I just had a look at the code checking delayed allocated buffers=
 in
> > ext4_ext_fiemap_cb(). I believe the checks there could use some eli=
miation
> > of common patterns but that's just a minor thing. The main problem =
is that
> > the code can easily crash the kernel when it races with page reclai=
m. You
> > just cannot access most of the page contents (and for buffers it is
> > especially true) without locking the page. Getting a reference via
> > find_get_pages_tag() guarantees you the structure cannot go away bu=
t mm is
> > still free to detach the page from the mapping at any moment. So yo=
u must
> > always lock a page and check that it still belongs to the desired m=
apping
> > before you check 'page_has_buffers()'.
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
> > --
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
> >
>=20
>=20
>=20
> --=20
> Best Wishes
> Yongqiang Yang
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
