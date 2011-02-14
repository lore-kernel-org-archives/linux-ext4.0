From: Jan Kara <jack@suse.cz>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Mon, 14 Feb 2011 18:25:04 +0100
Message-ID: <20110214172504.GC3018@quack.suse.cz>
References: <20110203144011.GA28409@quack.suse.cz>
 <4D4AC4E2.701@redhat.com>
 <AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com>
 <20110204131739.GC4104@quack.suse.cz>
 <AANLkTin=6wY6y0LZCDtMGiy8vmdok=UUj-7rmsTPAVuh@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Michael Rubin <mrubin@google.com>,
	Eric Sandeen <sandeen@redhat.com>,
	lsf-pc@lists.linuxfoundation.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTin=6wY6y0LZCDtMGiy8vmdok=UUj-7rmsTPAVuh@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat 12-02-11 13:05:02, Amir Goldstein wrote:
> On Fri, Feb 4, 2011 at 3:17 PM, Jan Kara <jack@suse.cz> wrote:
> >
> > On Thu 03-02-11 11:32:01, Michael Rubin wrote:
> > > On Thu, Feb 3, 2011 at 7:08 AM, Eric Sandeen <sandeen@redhat.com>=
 wrote:
> > > > If we can have a real plan for moving in this direction though,=
 I'd
> > > > support it. =A0I'm just not sure how we get enough real testing=
 under
> > > > our belts to be comfortable with dropping ext[23], especially a=
s
> > > > most distros now default to ext4 anyway.
> > >
> > > Eric what sort of testing are you looking for?
> > I believe Ted wrote a good summary of what combinations of options =
would
> > need to be tested on a regular basis to get at least some confidenc=
e that
> > the switch could work.
>=20
> So the problem is that people don'y have much incentive to test "ext3
> mode" as long as they have, well, ext3.
>=20
> I can offer an incentive in the form of snapshots support, which may
> appeal for some users, to whom performance improvements is not a good
> enough reason to upgrade their fs.
>=20
> Most conveniently, ext4 snapshots is short of extents and delalloc
> support at the moment, but the rest of the code, which was ported fro=
m
> next3 is ready to be stabilized/cleaned up for submission.
>=20
> So it can be claimed, that pursuing my cause, of pushing the snapshot=
s
> feature for early testers as soon as possible (i.e. before extent
> move-on-write implementation), may also be beneficial to the cause of
> getting "ext3 mode" tested by a larger number of users.
>=20
> What do you say, Jan. Do you think that some of your upgrading
> customers could be lured into using ext4 code if we offer them
> snapshots in "ext3 mode"?
  Well, some people might be interested in snapshotting and might move =
to
ext4 for that reason but these would be mostly people installing new
systems anyway, not the ones just updating older systems. So I don't fe=
el
this would be a major game changer...=20

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
