From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Return EIO on read error in ext4_find_entry
Date: Fri, 23 Jun 2017 15:36:57 -0600
Message-ID: <C37CE24B-A6E7-4B65-B0C4-4965B3C45007@dilger.ca>
References: <20170622232307.48392-1-khazhy@google.com>
 <20170623044314.7f23ighkelnpgnah@thunk.org>
 <204110E6-EECE-4925-9020-EC6D9633C822@dilger.ca>
 <20170623122603.jmvyw4oqkojcapv3@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_490ADF7A-14FE-4D3C-855D-8CA9C8046731";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Khazhismel Kumykov <khazhy@google.com>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:34567 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbdFWVhG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Jun 2017 17:37:06 -0400
Received: by mail-it0-f67.google.com with SMTP id y134so8468112itc.1
        for <linux-ext4@vger.kernel.org>; Fri, 23 Jun 2017 14:37:06 -0700 (PDT)
In-Reply-To: <20170623122603.jmvyw4oqkojcapv3@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_490ADF7A-14FE-4D3C-855D-8CA9C8046731
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 23, 2017, at 6:26 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> On Fri, Jun 23, 2017 at 12:33:02AM -0600, Andreas Dilger wrote:
>> On Jun 22, 2017, at 22:43, Theodore Ts'o <tytso@mit.edu> wrote:
>>>=20
>>>> On Thu, Jun 22, 2017 at 04:23:07PM -0700, Khazhismel Kumykov wrote:
>>>> Previously, a read error would be ignored and we would eventually =
return
>>>> NULL from ext4_find_entry, which signals "no such file or =
directory". We
>>>> should be returning EIO.
>>>>=20
>>>> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
>>>=20
>>> Thanks, applied.
>>=20
>> I don't necessarily agree that this is an improvement.
>>=20
>> If the requested entry is not in the bad block, this will return an
>> error even if the file name could be found in another block. It
>> would be better to save the error until the end and only return -EIO
>> if the entry cannot be found.
>=20
> The problem is that if we continue, successive reads may all take
> seconds or minutes to fail, thus tieing up the process for a long
> time.

Sorry, I don't understand where the seconds or minutes of delay come =
from?
Is that because of long SCSI retries in the block layer, or in the disk
itself, or something caused specifically because of this code?

This is in the non-htree lookup path, so it is already doing a linear
directory scan to find the entry.  If this is a non-htree directory =
because
the directory is only a single block in size, then saving the EIO to =
return
at "the end" is identical to returning it immediately.  If it is using =
this
codepath because it is a large non-htree directory, then there is a real
chance that the entry can be found in another block, and this will cause =
the application to fail trying to find the file when it doesn't need to.

Since this is after EXT4_ERROR_INODE() then the filesystem must be =
mounted
with "errors=3Dcontinue", so I'd think in that case the filesystem =
should try
to continue in the face of errors.

> If this process happens to be, say, the node's Kubernetes
> management server it can take down the entire node (since if there is
> a watchdog daemon which assumes that if the management server is down,
> it's time to kill and reset the entire node), and the file system is,
> say, a network file system error which should only kill the individual
> job, and not the entire node, the results could be quite unfortunate.

Sorry, I don't understand your example.  It isn't clear where the error =
is
coming from?  Is this a media error or I don't understand how this could =
be
a network filesystem error?  To my reading, the patch removing the =
ability
to skip a bad directory leaf block would _induce_ an error rather than =
avoid it.

> By returning EIO right away, we can "fast fail".

But it seems like you don't necessarily need to fail at all?  Something =
like the
following would return an error if the entry is not found, but still =
search the
rest of the leaf blocks (if any) before giving up:

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index b81f7d4..c75b6dc 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1434,6 +1434,8 @@ static struct buffer_head * ext4_find_entry =
(struct inode *dir,
 			EXT4_ERROR_INODE(dir, "reading directory lblock =
%lu",
 					 (unsigned long) block);
 			brelse(bh);
+			/* if entry isn't found in a later block, return =
an error */
+			ret =3D ERR_PTR(-EIO);
 			goto next;
 		}
 		if (!buffer_verified(bh) &&

Cheers, Andreas






--Apple-Mail=_490ADF7A-14FE-4D3C-855D-8CA9C8046731
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZTYn7pIg59Q01vtYRAjWIAJ0f28KzdbKFXQ1kugokYkIt7C+aCACeKLYO
ehWqKvdTQEcAWcDK8zL4OcQ=
=eFbt
-----END PGP SIGNATURE-----

--Apple-Mail=_490ADF7A-14FE-4D3C-855D-8CA9C8046731--
