From: Jan Kara <jack@suse.cz>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Fri, 4 Feb 2011 14:17:39 +0100
Message-ID: <20110204131739.GC4104@quack.suse.cz>
References: <20110203144011.GA28409@quack.suse.cz>
 <4D4AC4E2.701@redhat.com>
 <AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	lsf-pc@lists.linuxfoundation.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Michael Rubin <mrubin@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 03-02-11 11:32:01, Michael Rubin wrote:
> On Thu, Feb 3, 2011 at 7:08 AM, Eric Sandeen <sandeen@redhat.com> wro=
te:
> > If we can have a real plan for moving in this direction though, I'd
> > support it. =A0I'm just not sure how we get enough real testing und=
er
> > our belts to be comfortable with dropping ext[23], especially as
> > most distros now default to ext4 anyway.
>=20
> Eric what sort of testing are you looking for?
I believe Ted wrote a good summary of what combinations of options woul=
d
need to be tested on a regular basis to get at least some confidence th=
at
the switch could work.

> I admit I like having ext2 around for comparisons in bug situations.
> It really helps to isolate the problem area. How painful is the
> upkeep?
Well, for me it's a couple of hours per week on average I'd say. Plus
there is some work other people do when changing some VFS/MM interfaces
influencing all the filesystems.

The time I spend is enough to keep ext3 in a good shape I believe but I
have a feeling that ext2 is slowly bitrotting. Sometime when I look at
ext2 code I see stuff we simply do differently these days and that's ju=
st
a step away from the code getting broken... It would not be too much wo=
rk
to clean things up and maintain but it's a work with no clear gain (if =
you
do the thankless job of maintaining old code, you should at least have
users who appreciate that ;) so naturally no one does it.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
