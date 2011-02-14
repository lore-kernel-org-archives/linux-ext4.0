From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Mon, 14 Feb 2011 21:00:58 +0200
Message-ID: <AANLkTimdApPPK6FkH+CPrXdNpND6_twE2voRiNhgQOOE@mail.gmail.com>
References: <20110203144011.GA28409@quack.suse.cz>
	<4D4AC4E2.701@redhat.com>
	<AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com>
	<20110204131739.GC4104@quack.suse.cz>
	<AANLkTin=6wY6y0LZCDtMGiy8vmdok=UUj-7rmsTPAVuh@mail.gmail.com>
	<20110214172504.GC3018@quack.suse.cz>
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63201 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab1BNTA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Feb 2011 14:00:59 -0500
In-Reply-To: <20110214172504.GC3018@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 14, 2011 at 7:25 PM, Jan Kara <jack@suse.cz> wrote:
> On Sat 12-02-11 13:05:02, Amir Goldstein wrote:
>> On Fri, Feb 4, 2011 at 3:17 PM, Jan Kara <jack@suse.cz> wrote:
>> >
>> > On Thu 03-02-11 11:32:01, Michael Rubin wrote:
>> > > On Thu, Feb 3, 2011 at 7:08 AM, Eric Sandeen <sandeen@redhat.com=
> wrote:
>> > > > If we can have a real plan for moving in this direction though=
, I'd
>> > > > support it. =A0I'm just not sure how we get enough real testin=
g under
>> > > > our belts to be comfortable with dropping ext[23], especially =
as
>> > > > most distros now default to ext4 anyway.
>> > >
>> > > Eric what sort of testing are you looking for?
>> > I believe Ted wrote a good summary of what combinations of options=
 would
>> > need to be tested on a regular basis to get at least some confiden=
ce that
>> > the switch could work.
>>
>> So the problem is that people don'y have much incentive to test "ext=
3
>> mode" as long as they have, well, ext3.
>>
>> I can offer an incentive in the form of snapshots support, which may
>> appeal for some users, to whom performance improvements is not a goo=
d
>> enough reason to upgrade their fs.
>>
>> Most conveniently, ext4 snapshots is short of extents and delalloc
>> support at the moment, but the rest of the code, which was ported fr=
om
>> next3 is ready to be stabilized/cleaned up for submission.
>>
>> So it can be claimed, that pursuing my cause, of pushing the snapsho=
ts
>> feature for early testers as soon as possible (i.e. before extent
>> move-on-write implementation), may also be beneficial to the cause o=
f
>> getting "ext3 mode" tested by a larger number of users.
>>
>> What do you say, Jan. Do you think that some of your upgrading
>> customers could be lured into using ext4 code if we offer them
>> snapshots in "ext3 mode"?
> =A0Well, some people might be interested in snapshotting and might mo=
ve to
> ext4 for that reason but these would be mostly people installing new
> systems anyway, not the ones just updating older systems. So I don't =
feel
> this would be a major game changer...
>

Yes, of course. Upgraders won't be the ones using snapshots.
My intension was to state that those people installing new systems to t=
est
snapshots would be functioning as testers for "ext3 mode", because:
1. when no snapshots exists it boils down to testing "ext3 mode".
2. it is unlikely that snapshots will mask "ext3 mode" bugs.

So my claim is that "ext3 mode" would benefit from a transition period =
in which
snapshots and (extens,delalloc) are mutually exclusive in ext4.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
