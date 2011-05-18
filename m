From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests: device busy when umount
Date: Wed, 18 May 2011 16:31:53 +1000
Message-ID: <20110518063153.GZ19446@dastard>
References: <BANLkTimQW+kyqjmzpAHH_W5x2v1EWW2AZA@mail.gmail.com>
 <4DD286E5.8090105@redhat.com>
 <BANLkTi=pZS6sTjS61UmpbOsj+vF+ithVvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:29005 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753733Ab1ERGc0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 02:32:26 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTi=pZS6sTjS61UmpbOsj+vF+ithVvw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 17, 2011 at 06:01:14PM +0300, Amir Goldstein wrote:
> On Tue, May 17, 2011 at 5:32 PM, Eric Sandeen <sandeen@redhat.com> wr=
ote:
> > On 5/17/11 4:03 AM, Yongqiang Yang wrote:
> >> Hi,
> >>
> >> I noticed that all tests which contain 'device busy' errors have
> >> falloc operations. =A0Does the error have something to do with fal=
loc?

<shrug>

Perhaps a bit more detail about what you are testing, how you've set
up xfstests, etc, and some analysis of the problem is in order first?

> > cc'ing xfs list since xfs devs maintain xfstests.
> >
> > What tests have "device busy" errors? =A0What do the usual investig=
ative
> > steps such as "lsof" and "fuser" tell you when this happens?
>=20
> I tried running lsof | grep $TEST_DIR before umount
> and I tried sleep 1 before umount and it didn't yield anything.

Which usually indicates that you've got some kind of reference
counting problem preventing the filesystem from being unmounted.

> > Are there loop devices that didn't get cleaned up, or processes tha=
t
> > have not terminated?
> >
> > What tests have these problems?
>=20
> for me 124 always fails to umount, and 198 and 213 sometimes fails to=
 umount.

What, exactly, are you testing on? test 124 uses XFS_IOC_RESVSP
directly, not fallocate(), so all it is doing on a non-XFS
filesystem is iterating a loop that writes a 1MB file, reads it back
then unlinks it....

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
