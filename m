From: Andreas Dilger <adilger@dilger.ca>
Subject: Y2038 bug in ext4 recently_deleted() function
Date: Thu, 17 Aug 2017 15:51:41 -0600
Message-ID: <BCA34CA8-FDDF-49FA-A5B4-9CCCEAC0C8D0@dilger.ca>
References: <20170808050517.7160-1-wshilong@ddn.com>
 <20170816164211.GA31117@quack2.suse.cz>
 <3ED34739A4E85E4F894367D57617CDEFEDA401CE@LAX-EX-MB2.datadirect.datadirectnet.com>
 <20170817091959.GB7644@quack2.suse.cz>
 <20170817092153.GA14074@quack2.suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_770854FE-2373-45C0-9E7F-AF1B4755902A";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Wang Shilong <wshilong@ddn.com>,
        Wang Shilong <wangshilong1991@gmail.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Shuichi Ihara <sihara@ddn.com>, Li Xi <lixi@ddn.com>,
        Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35200 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752632AbdHQVvu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Aug 2017 17:51:50 -0400
Received: by mail-io0-f182.google.com with SMTP id m88so27413517iod.2
        for <linux-ext4@vger.kernel.org>; Thu, 17 Aug 2017 14:51:49 -0700 (PDT)
In-Reply-To: <20170817092153.GA14074@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_770854FE-2373-45C0-9E7F-AF1B4755902A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Aug 17, 2017, at 3:21 AM, Jan Kara <jack@suse.cz> wrote:
>=20
> On Thu 17-08-17 11:19:59, Jan Kara wrote:
>> Hi Shilong!
>>=20
>> On Thu 17-08-17 06:23:26, Wang Shilong wrote:
>>>     thanks for good suggestion, just one question we could not hold =
lock
>>> with nojounal mode, how about something attached one?
>>>=20
>>> please let me know if you have better taste for it, much =
appreciated!
>>=20
>> Thanks for quickly updating the patch! Is the only reason why you =
cannot
>> hold the lock in the nojournal mode that sb_getblk() might sleep? The
>> attached patch should fix that so that you don't have to special-case =
the
>> nojournal mode anymore.
>=20
> Forgot to attach the patch - here it is. Feel free to include it in =
your
> series as a preparatory patch.

Strange, I never even knew recently_deleted() existed, even though it =
was
added to the tree 4 years ago yesterday.  It looks like this is only =
used
with the no-journal code, which I don't really interact with.

One thing I did notice when looking at it is that there is a Y2038 bug =
in
recently_deleted(), as it is comparing 32-bit i_dtime directly with =
64-bit
get_seconds().  To fix this, it would be possible to either use a =
wrapped
32-bit comparison, like time_after() for jiffies, something like:

	u32 now, dtime;

	/* assume dtime is within the past 30 years, see time_after() */
        now =3D get_seconds();
	if (dtime && (dtime - now < 0) && (dtime + recentcy - now < 0))
		ret =3D 1;

or use i_ctime_extra to implicitly extend i_dtime beyond 2038, something =
like:

	/* assume dtime epoch same as ctime, see EXT4_INODE_GET_XTIME() =
*/
	dtime =3D le32_to_cpu(raw_inode->i_dtime);
	if (EXT4_INODE_SIZE(sb) > EXT4_GOOD_OLD_INODE_SIZE &&
	    offsetof(typeof(*raw_inode), i_ctime_extra) + 4 <=3D
	    EXT4_GOOD_OLD_INODE_SIZE + =
le32_to_cpu(raw_inode->i_extra_isize))
                dtime +=3D (long)(le32_to_cpu(raw_inode->i_ctime_extra) =
&
				EXT4_EPOCH_MASK) << 32;

Cheers, Andreas






--Apple-Mail=_770854FE-2373-45C0-9E7F-AF1B4755902A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZlg/vpIg59Q01vtYRAp4zAKDy8UsM/cV91s92HH1hawDeZ+0pSQCfbF0C
S2G7TL2k52zBTdTz9zQr9i0=
=gbZi
-----END PGP SIGNATURE-----

--Apple-Mail=_770854FE-2373-45C0-9E7F-AF1B4755902A--
