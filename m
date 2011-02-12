From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Sat, 12 Feb 2011 13:05:02 +0200
Message-ID: <AANLkTin=6wY6y0LZCDtMGiy8vmdok=UUj-7rmsTPAVuh@mail.gmail.com>
References: <20110203144011.GA28409@quack.suse.cz>
	<4D4AC4E2.701@redhat.com>
	<AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com>
	<20110204131739.GC4104@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Michael Rubin <mrubin@google.com>,
	Eric Sandeen <sandeen@redhat.com>,
	lsf-pc@lists.linuxfoundation.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110204131739.GC4104@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Feb 4, 2011 at 3:17 PM, Jan Kara <jack@suse.cz> wrote:
>
> On Thu 03-02-11 11:32:01, Michael Rubin wrote:
> > On Thu, Feb 3, 2011 at 7:08 AM, Eric Sandeen <sandeen@redhat.com> w=
rote:
> > > If we can have a real plan for moving in this direction though, I=
'd
> > > support it. =A0I'm just not sure how we get enough real testing u=
nder
> > > our belts to be comfortable with dropping ext[23], especially as
> > > most distros now default to ext4 anyway.
> >
> > Eric what sort of testing are you looking for?
> I believe Ted wrote a good summary of what combinations of options wo=
uld
> need to be tested on a regular basis to get at least some confidence =
that
> the switch could work.
>

So the problem is that people don'y have much incentive to test "ext3
mode" as long as they have, well, ext3.

I can offer an incentive in the form of snapshots support, which may
appeal for some users, to whom performance improvements is not a good
enough reason to upgrade their fs.

Most conveniently, ext4 snapshots is short of extents and delalloc
support at the moment, but the rest of the code, which was ported from
next3 is ready to be stabilized/cleaned up for submission.

So it can be claimed, that pursuing my cause, of pushing the snapshots
feature for early testers as soon as possible (i.e. before extent
move-on-write implementation), may also be beneficial to the cause of
getting "ext3 mode" tested by a larger number of users.

What do you say, Jan. Do you think that some of your upgrading
customers could be lured into using ext4 code if we offer them
snapshots in "ext3 mode"?

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
