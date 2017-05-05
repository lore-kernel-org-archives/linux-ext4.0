From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Clear lockdep subtype for quota files on quota off
Date: Fri, 5 May 2017 14:20:38 -0600
Message-ID: <0A0D0EE6-38A2-4701-87EF-E8D63CA136C0@dilger.ca>
References: <20170505085327.27103-1-jack@suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_616CD087-4732-4E60-AC69-90710362D393";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:36776 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755892AbdEEUUt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 5 May 2017 16:20:49 -0400
Received: by mail-io0-f193.google.com with SMTP id x86so3857834ioe.3
        for <linux-ext4@vger.kernel.org>; Fri, 05 May 2017 13:20:49 -0700 (PDT)
In-Reply-To: <20170505085327.27103-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_616CD087-4732-4E60-AC69-90710362D393
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On May 5, 2017, at 2:53 AM, Jan Kara <jack@suse.cz> wrote:
>=20
> Quota files have special ranking of i_data_sem lock. We inform lockdep
> about it when turning on quotas however when turning quotas off, we
> don't clear the lockdep subclass from i_data_sem lock and thus when =
the
> inode gets later reused for a normal file or directory, lockdep gets
> confused and complains about possible deadlocks. Fix the problem by
> resetting lockdep subclass of i_data_sem on quota off.
>=20
> Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Fixes: daf647d2dd58cec59570d7698a45b98e580f2076
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
The change to skip clearing the NOATIME/IMMUTABLE inode flags and times
on every mount/unmount when the journaled quota feature is enabled is
good, since it avoids needless overhead, but isn't really described in
the commit comment.  This isn't directly related to the lockdep, but
rather improving 957153fce8d2 "ext4: Set flags on quota files directly"
AFAICS.

It might be worthwhile to add a line to this commit like:

 Don't clear NOATIME/IMMUTABLE flags when journaled quota is enabled.

It also looks like ext4_quota_on() could use a similar check, to avoid
setting the NOATIME/IMMUTABLE flags on every mount if they are already
set.

I guess it isn't harmful to clear IMMUTABLE in the case of non-journaled
quotas, to maximize compatibility with older quota utilities, so long as
we don't incur this needless overhead for the newer journaled quota =
case.


There is a separate issue of what to do if the filesystem wasn't =
unmounted
cleanly and IMMUTABLE is still set?  If the userspace quotacheck always
clears IMMUTABLE when it is run, then there isn't much benefit in =
setting
the IMMUTABLE flag in the first place.  Is there some other way that the
userspace quota utilities know whether it is safe to update the quota =
files?

One possibility would be to use a similar open(O_EXCL) hack as we use
with block devices to avoid userspace trying to modify the quota file =
while
the kernel is using it?

Cheers, Andreas

> ---
> fs/ext4/super.c | 14 +++++---------
> 1 file changed, 5 insertions(+), 9 deletions(-)
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index a9c72e39a4ee..77043dc7f704 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -846,14 +846,9 @@ static inline void ext4_quota_off_umount(struct =
super_block *sb)
> {
> 	int type;
>=20
> -	if (ext4_has_feature_quota(sb)) {
> -		dquot_disable(sb, -1,
> -			      DQUOT_USAGE_ENABLED | =
DQUOT_LIMITS_ENABLED);
> -	} else {
> -		/* Use our quota_off function to clear inode flags etc. =
*/
> -		for (type =3D 0; type < EXT4_MAXQUOTAS; type++)
> -			ext4_quota_off(sb, type);
> -	}
> +	/* Use our quota_off function to clear inode flags etc. */
> +	for (type =3D 0; type < EXT4_MAXQUOTAS; type++)
> +		ext4_quota_off(sb, type);
> }
> #else
> static inline void ext4_quota_off_umount(struct super_block *sb)
> @@ -5476,7 +5471,7 @@ static int ext4_quota_off(struct super_block =
*sb, int type)
> 		goto out;
>=20
> 	err =3D dquot_quota_off(sb, type);
> -	if (err)
> +	if (err || ext4_has_feature_quota(sb))
> 		goto out_put;
>=20
> 	inode_lock(inode);
> @@ -5496,6 +5491,7 @@ static int ext4_quota_off(struct super_block =
*sb, int type)
> out_unlock:
> 	inode_unlock(inode);
> out_put:
> +	lockdep_set_quota_inode(inode, I_DATA_SEM_NORMAL);
> 	iput(inode);
> 	return err;
> out:
> --
> 2.12.0
>=20


Cheers, Andreas






--Apple-Mail=_616CD087-4732-4E60-AC69-90710362D393
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZDN6XpIg59Q01vtYRAihSAKC3mxi7EMXCX3CJd4UtcZwtP9vhtQCfer3K
ocr+Z2N+dvkmryy43uxj52Q=
=uKOd
-----END PGP SIGNATURE-----

--Apple-Mail=_616CD087-4732-4E60-AC69-90710362D393--
