From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 fixes for 3.1-rc5
Date: Wed, 31 Aug 2011 17:42:33 -0400
Message-ID: <20110831214233.GA6666@thunk.org>
References: <E1Qyos7-0001in-99@tytso-glaptop.cam.corp.google.com>
 <CA+55aFzFRo0vmuED2wbab6ZU9oH4Rriav6R13zGNtUnS2UStMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44593 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244Ab1HaVmg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 17:42:36 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFzFRo0vmuED2wbab6ZU9oH4Rriav6R13zGNtUnS2UStMA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 31, 2011 at 11:25:58AM -0700, Linus Torvalds wrote:
> On Wed, Aug 31, 2011 at 10:46 AM, Theodore Ts'o <tytso@mit.edu> wrote=
:
> >
> > Please pull from:
> >
> > =A0 =A0 =A0 =A0git://github.com/tytso/ext4.git for_linus-20110831 #=
 8c0bec2151a
> >
> > to get the following bug fix. =A0It address a lockdep warning which=
 a lot
> > of people have been complaining about.
>=20
> So what's up? Bad English and a github address makes me unhappy.
>=20
> I can imagine that you decided not to use kernel.org due to hera bein=
g
> down, but this still makes me want to say "please more references".

Yes, I decided to use github because master.kernel.org is down.
for_linus-20110831 is a signed tag, which you can verify.

Sorry for the bad english, I was doing too many other things at the
same time when I was composing the pull request.  The pull should
consist of a single commit to fix a Lockddep complain; see:

https://bugzilla.kernel.org/show_bug.cgi?id=3D41682

I just realized I forgot to include the BZ URL in the commit
description; sigh, sorry about that.  Would you prefer that I ammend
the commit and send you a new pull request?

					- Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
