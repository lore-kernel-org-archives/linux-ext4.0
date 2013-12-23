From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] directory quota survey on xfs
Date: Tue, 24 Dec 2013 10:43:56 +1100
Message-ID: <20131223234355.GK3220@dastard>
References: <20131222095929.GA11444@gmail.com>
 <20131223014222.GC3220@dastard>
 <201312231012.19204.arekm@maven.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Dmitry Monakhov <dmonakhov@openvz.org>, Ben Myers <bpm@sgi.com>
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:1350 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753066Ab3LWXoE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Dec 2013 18:44:04 -0500
Content-Disposition: inline
In-Reply-To: <201312231012.19204.arekm@maven.pl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 23, 2013 at 10:12:19AM +0100, Arkadiusz Mi=C5=9Bkiewicz wro=
te:
> On Monday 23 of December 2013, Dave Chinner wrote:
>=20
> > > As always, any comment or idea are welcome.
> >=20
> > I'd suggest that you implement project quotas, not directory quotas=
=2E
> > They are way more flexible than pure directory quotas, but with onl=
y
> > a few lines of code and a special directory flag they can be used t=
o
> > > implement directory subtree quotas....
>=20
> Would be also nice to allow a file to belong to more than one project=
=2E

Not possible. Apart from there only being a single project ID to an
inode, having to account an inode ot mulitple project quotas
effectively makes every transaction in XFS have to modify an unbound
number of dquots. We don't have the infrastructure to do that, we
can't reserve log space for unbound sized transactions, etc.

> Let say I want to have
>=20
> /projects/ with 10GB quota
> and
> /projects/projectA/ with 1GB quota
> /projects/projectB/ with 2GB quota
> and so on that's still limited by /projects/ 10GB quota limit.

What you get is exclusive accounting - the 10GB limit on /projects/
excludes the limits set on /projects/projectA/ and
/projects/projectB/.

Think about it for a minute - if we make subtrees nest like you
suggest, then:

/projects/ with 10GB quota
/projects/projectA/ with 5GB quota
/projects/projectA/subproj1 with 3GB quota
/projects/projectA/subproj1/ssp2 with 2GB quota
/projects/projectA/subproj1/ssp2/sssp3 with 1GB quota

if we modify a file in ..../sssp3/, then we have 5 project quotas we
have to check for limit enforcement, reserve blocks on and then
transactionally modify (plus user and group for the file itself).

That's exceedingly complex because we don't have pointers to all
the inodes in the path back up to the root, so just to find that we
have nested project quotas requires a reverse path walk to find the
directory inodes to get their project IDs to look up the dquots we'd
need to modify. The complexity and performance overhead of recursive
project quota accounting simply isn't worth it.

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
