From: Theodore Tso <tytso@mit.edu>
Subject: Re: creation time stamps for ext4 ?
Date: Thu, 5 Oct 2006 12:55:04 -0400
Message-ID: <20061005165504.GA23727@thunk.org>
References: <E1GVUd2-0006O6-00@intern.SerNet.DE> <20061005151937.GV22010@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:7662 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1751350AbWJEQzL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Oct 2006 12:55:11 -0400
To: =?utf-8?B?Qmrvv71ybg==?= JACKE <bjacke@sernet.de>,
	ext3-users@redhat.com, linux-ext4@vger.kernel.org
Content-Disposition: inline
In-Reply-To: <20061005151937.GV22010@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 05, 2006 at 09:19:37AM -0600, Andreas Dilger wrote:
> On Oct 05, 2006  15:57 +0200, Bj=EF=BF=BDrn JACKE wrote:
> > I would like to know if there are any plans to introduce a creation=
=20
> > timestamp in future ext3/4 versions. Having a 4th timestamp saving =
the=20
> > creation time would be very good for projekts like Samba for exampl=
e.=20
> > It would be important that creation time can also be set manually=20
> > later on by some system call. Systems like FreeBSD's UFS and Solais=
'=20
> > ZFS already support creation times. Unfortunately Linux doesn't hav=
e=20
> > such a thing standarized anywhere but it would be geat if it would.
> >=20
> > Are there any plans to add this?
>=20
> I've given this some thought for adding as part of the nsec timestamp
> patch.  That is more feasable if we move the nsec ctime into the main
> inode to double as the version field.

Shoehorning an extra creation time field into the inode is relatively
easy, but it's also necessary to have system calls to get and set the
creation time.  The stat structure doesn't have room for the creation
time, so that means a new version of the stat structure exported the
kernel, and a new version of the stat structure exported by glibc.

So there are VFS and glibc changes necessary to make this be useful.
But that doesn't prevent us from reserving space in the inode and
starting to fill it in with the creation time, although it may be
quite a while before it will be easily available to user programs like
Samba.

						- Ted
-
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
