From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Subject: Re: Maximum number of directories
Date: Tue, 05 Feb 2013 14:30:24 +0000
Message-ID: <2743619.5F0TAJAmZW@deuteros>
References: <17001225.1MS6YREEfJ@deuteros> <3667261.Q2Z9h3nZ4l@deuteros> <alpine.LFD.2.00.1302051309320.3225@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Prashant Shah <pshah.mumbai@gmail.com>, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from claranet-outbound-smtp04.uk.clara.net ([195.8.89.37]:54968 "EHLO
	claranet-outbound-smtp04.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754378Ab3BEOac convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Feb 2013 09:30:32 -0500
In-Reply-To: <alpine.LFD.2.00.1302051309320.3225@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,

On Tuesday 05 February 2013 14:06:14 Luk=C3=A1=C5=A1 Czerner wrote:
> On Mon, 4 Feb 2013, Tvrtko Ursulin wrote:
> > Date: Mon, 04 Feb 2013 13:36:29 +0000
> > From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
> > To: Prashant Shah <pshah.mumbai@gmail.com>
> > Cc: linux-ext4@vger.kernel.org
> > Subject: Re: Maximum number of directories
> >=20
> > On Monday 04 February 2013 18:49:54 Prashant Shah wrote:
> > > Hi,
> > >=20
> > > On Mon, Feb 4, 2013 at 4:25 PM, Tvrtko Ursulin
> > >=20
> > > <tvrtko.ursulin@onelan.co.uk> wrote:
> > > > I was creating such a (crazy?) tree and hit -ENOSPC at ~31 mill=
ion
> > > > directories created in total with df showing only 40% use:
> > > >=20
> > > > Inode count:              29868032
> > > > Free inodes:              29848131
> > >=20
> > > Since, each directory will use a inode entry, there is some misma=
tch
> > > with ~31 million directories and 19901 inodes in use. The inode u=
sage
> > > count should be much larger. You have max 29 million inodes avail=
able
> > > - so max can be 29 million directories.
> >=20
> > Yeah, I totally forgot about the inode situation on ext filesystems=
=2E So is
> > tune2fs giving wrong stats for live (mounted) filesystems?
>=20
> Not sure what situation you're referring to. Directory as any other
> file is represented by an inode and there is a limited number of
> inodes in the file system.

The situation that inode blocks are statically allocated at mkfs time.

> Using tune2fs on live/mounted file system is bad idea and the
> information might not be correct (exactly for this reason it is
> _NOT_ recommended to run fsck on live file system). Use 'df -i' if
> you want to get information about inode count.

Yes, later I figured out that tune2fs -l does not give current stats fo=
r live=20
filesystems. I did not expect that to be dangerous though. And I also f=
orgot=20
about 'df -i'. Thing is, I did not hit this limit since the previous ce=
ntury=20
so guess I subconsciously assumed inode limits are an outdated concept.=
 :)=20
=20
Regards,

Tvrtko

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
