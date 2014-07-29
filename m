From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add sysfs entry showing whether the fs contains
 errors
Date: Tue, 29 Jul 2014 10:49:03 -0400
Message-ID: <20140729144903.GD2256@thunk.org>
References: <1399382357-12703-1-git-send-email-lczerner@redhat.com>
 <20140506174301.GQ8434@birch.djwong.org>
 <20140506192325.GB5012@thunk.org>
 <alpine.LFD.2.00.1405071040240.2128@localhost.localdomain>
 <20140520094741.GG11499@pcnci.linuxbox.cz>
 <alpine.LFD.2.00.1405201150180.2162@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34505 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbaG2OtK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jul 2014 10:49:10 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405201150180.2162@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 20, 2014 at 11:56:53AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Tue, 20 May 2014, Nikola Ciprich wrote:
>=20
> > Date: Tue, 20 May 2014 11:47:41 +0200
> > From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
> > To: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
> > Cc: Theodore Ts'o <tytso@mit.edu>, Darrick J. Wong <darrick.wong@or=
acle.com>,
> >     linux-ext4@vger.kernel.org, Nikola Ciprich <nikola.ciprich@linu=
xbox.cz>
> > Subject: Re: [PATCH] ext4: add sysfs entry showing whether the fs c=
ontains
> >     errors
> >=20
> > Hello Luk=C3=A1=C5=A1,
> >=20
> > just wanted to ask about the status of this patch.. it didn't make =
it
> > to git yet, did it? Do you plan to make some changes to it? I'm eag=
er
> > to test it ;-)
>=20
> No it did not and it would not given that there was not a merge
> window since then. I've been distracted by other work, but I'll put
> you in cc when I have a new patch - yes I plan to change the format
> of the output to be more compliant with sysfs rules.

Hey Lukas,

I've been looking at old patches still in the ext4 patchwork queue,
and I came across this.  Just a quick reminder you were planning on
updating this patch at some point when you have time.

Cheers,

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
