From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 37/37] ext5: define new subtype to add features and
 reduce testing complexity
Date: Mon, 5 May 2014 18:59:50 -0700
Message-ID: <20140506015950.GP8434@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
 <20140501231629.31890.34812.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1405021133520.2154@localhost.localdomain>
 <20140502140407.GB842@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34866 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933564AbaEFB74 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 May 2014 21:59:56 -0400
Content-Disposition: inline
In-Reply-To: <20140502140407.GB842@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 02, 2014 at 10:04:07AM -0400, Theodore Ts'o wrote:
> On Fri, May 02, 2014 at 11:45:25AM +0200, Luk=C3=A1=C5=A1 Czerner wro=
te:
> > This is definitely NACK by me. I do not like this and there are
> > several reasons why.
> >=20
> > First of all the name. Given the history of ext file system we tend
> > to increase then number with the new version of file system. Howeve=
r
> > you're saying that this is just for testing features ... in that
> > case it does not make any sense to call it ext5, but not just that
> > it's stupid to call it ext5 especially since we might actually want
> > to release ext5 in the future and this would be really confusing fo=
r
> > everybody involved.
>=20
> Yes, the messaging involved with the "ext3" vs "ext4" bump has been
> really unfortunate.  If I had to do it all over again, I would have
> created "ext3dev", and then when it was stable, I would done a:
>=20
> 	git rm -rf fs/ext3 ; git mv fs/ext3dev fs/ext4
>=20
> For example, it would have avoided the problem with SuSE product
> managers refusing to support ext4 for multiple years, etc.
>=20
> It also would have avoided the problem with people doing comparisons
> of ext3 versus xfs, even in April 2014 (see a recent Hacker News
> promoted blog article, where in someone kvetched that ext3 didn't
> support fallocate).  Sigh....

We could still do that, delete ext3 once we think "ext4 + new
features" is stable enough.  It's not quite having only one extN
featureset in operation at a given time, but "a stable one" and "the
one we're working on" seems like plenty.

> > What about just simply using mkefs.conf to specify the feature set
> > we want and use that?
>=20
> Yes, it's likely that for 1.43 we'll enable various features by
> default.  It's been quite deliberate that I haven't enabled by
> default, because I wanted to make 100% sure they were completely
> stable before enabling them by default.  Some of them we may have bee=
n

Maybe I should have called this 'ext5alpha' or something, just to see
if I could generate wider interest in testing.  I feel like these new
features are stable enough for some thorough testing, but they're a
pretty long way from 'completely stable'.

How widely are these features being tested?  I'm rather dismayed that
I still find plenty of bugs to stick in the patchbomb.  (Though I'm as
guilty as anyone else for contributing new features.)

> able to enable by default earlier, but be that as it may, 1.43 is a
> good time to make that change.

Hmm, I guess you were intending to update the mke2fs.conf definition of=
 ext4,
then?

--D
>=20
> 				- Ted
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
