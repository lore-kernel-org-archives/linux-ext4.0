From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Subject: Re: Maximum number of directories
Date: Tue, 05 Feb 2013 14:58:15 +0000
Message-ID: <3384808.0kkUZK9dS1@deuteros>
References: <17001225.1MS6YREEfJ@deuteros> <2743619.5F0TAJAmZW@deuteros> <alpine.LFD.2.00.1302051538270.3225@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Prashant Shah <pshah.mumbai@gmail.com>, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from claranet-outbound-smtp01.uk.clara.net ([195.8.89.34]:56568 "EHLO
	claranet-outbound-smtp01.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755679Ab3BEO6X convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Feb 2013 09:58:23 -0500
In-Reply-To: <alpine.LFD.2.00.1302051538270.3225@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday 05 February 2013 15:43:51 Luk=C3=A1=C5=A1 Czerner wrote:
> > > > Yeah, I totally forgot about the inode situation on ext filesys=
tems.
> > > > So is
> > > > tune2fs giving wrong stats for live (mounted) filesystems?
> > >=20
> > > Not sure what situation you're referring to. Directory as any oth=
er
> > > file is represented by an inode and there is a limited number of
> > > inodes in the file system.
> >=20
> > The situation that inode blocks are statically allocated at mkfs ti=
me.
>=20
> Yes, that is true.

Indeed it is. :)
=20
> > > Using tune2fs on live/mounted file system is bad idea and the
> > > information might not be correct (exactly for this reason it is
> > > _NOT_ recommended to run fsck on live file system). Use 'df -i' i=
f
> > > you want to get information about inode count.
> >=20
> > Yes, later I figured out that tune2fs -l does not give current stat=
s for
> > live filesystems. I did not expect that to be dangerous though. And=
 I
> > also forgot about 'df -i'. Thing is, I did not hit this limit since=
 the
> > previous century so guess I subconsciously assumed inode limits are=
 an
> > outdated concept. :)
> Running tune2fs -l on live file system is not dangerous, I did not
> said that. Running fsck on live file system on the other hand _is_
> dangerous.

:) Neither have I said I was running fsck or anything other than 'tune2=
fs -l'.

Regards,

Tvrtko

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
