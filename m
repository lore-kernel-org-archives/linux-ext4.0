From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] tune2fs: warn if the filesystem journal is dirty
Date: Tue, 24 Nov 2015 17:18:58 -0700
Message-ID: <1CF774AF-6D76-42C4-B31D-8538FBAB5C6C@dilger.ca>
References: <1448405834-25328-1-git-send-email-adilger@dilger.ca> <20151124232603.GB10580@birch.djwong.org> <7BF1ADDF-050A-425C-93B8-88F19267A6F6@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_F438EA56-60A1-4805-B006-667205044866"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33418 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbbKYATE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Nov 2015 19:19:04 -0500
Received: by pabfh17 with SMTP id fh17so38921363pab.0
        for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2015 16:19:03 -0800 (PST)
In-Reply-To: <7BF1ADDF-050A-425C-93B8-88F19267A6F6@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_F438EA56-60A1-4805-B006-667205044866
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 24, 2015, at 4:42 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>=20
> On Nov 24, 2015, at 4:26 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>>=20
>> On Tue, Nov 24, 2015 at 03:57:14PM -0700, Andreas Dilger wrote:
>>> From: Jim Garlick <garlick@llnl.gov>
>>>=20
>>> Running tune2fs on a filesystem with an unrecovered journal can
>>> cause the tune2fs settings changes in the superblock to be reverted
>>> when the journal is replayed if it contains an uncommitted copy of
>>> the superblock.  Print a warning if this is detected so that the
>>> user isn't surprised if it happens.
>>>=20
>>> Signed-off-by: Jim Garlick <garlick@llnl.gov>
>>> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
>>> ---
>>> misc/tune2fs.c |   12 ++++++++++++
>>> 1 files changed, 12 insertions(+), 0 deletions(-)
>>>=20
>>> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
>>> index cd1d17f..fcb963a 100644
>>> --- a/misc/tune2fs.c
>>> +++ b/misc/tune2fs.c
>>> @@ -2397,6 +2397,7 @@ retry_open:
>>> 		ext2fs_mark_super_dirty(fs);
>>> 		printf(_("Setting stripe width to %d\n"), stripe_width);
>>> 	}
>>> +
>>> 	if (ext_mount_opts) {
>>> 		strncpy((char *)(fs->super->s_mount_opts), =
ext_mount_opts,
>>> 			sizeof(fs->super->s_mount_opts));
>>> @@ -2406,6 +2407,17 @@ retry_open:
>>> 		       ext_mount_opts);
>>> 		free(ext_mount_opts);
>>> 	}
>>> +
>>> +	/* Warn if file system needs recovery and it is opened for =
writing. */
>>> +	if ((open_flag & EXT2_FLAG_RW) && !(mount_flags & =
EXT2_MF_MOUNTED) &&
>>> +	    (sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
>>> +	    (sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER)) {
>>=20
>> ext2fs_has_feature_journal(sb) &&
>> ext2fs_has_feature_journal_needs_recovery(sb)
>=20
> Those patches don't exist on maint or master...  Maybe Ted will =
consider to
> cherry-pick 86f3b6cf98 and dependent patches to those branches?
>=20
>>> +		fprintf(stderr,
>>> +			_("Warning: needs_recovery flag is set. You may =
wish\n"
>>> +			  "replay the journal then rerun this command, =
or any\n"
>>=20
>> "You may wish to replay the journal..."
>>=20
>>> +			  "changes may be overwritten by journal =
recovery.\n"));
>>=20
>> I wonder if we ought simply to replay the journal in this situation, =
since
>> debugfs/fuse2fs can do it.
>>=20
>> ...or at least tell the user how to replay? ("e2fsck -E =
journal_only"/mount)
>=20
> I'm not sure if there is some reason they may _not_ want the journal =
to be
> replayed in this case?  I agree at least with telling them how to do =
it.
> I'll send a new patch for this update.
>=20
>=20
> We had a bad time with "tune2fs" doing too much stuff to the =
filesystem
> unexpectedly a few weekends ago (related to the "quota update" bug).  =
The
> more automagic added to tune2fs (e.g. huge reorganization of the =
filesystem
> when setting a feature), the more likely it is that there will be a =
bad
> outcome for some user that isn't expecting tune2fs to make major =
changes.
>=20
> At a minimum, I think anything in tune2fs that is changing more than a =
single
> flag or field in the superblock (e.g. change inode size, recompute =
checksums,
> etc. that used to require a separate e2fsck run) should pause/prompt =
like:
>=20
>   This may take several minutes/hours and cannot be interrupted. Are =
you sure?
>=20
> for interactive users ala proceed_question().
>=20
> That should be done before the 1.43 release I think, since the number =
of such
> actions taken by tune2fs has increased significantly in that release.

Actually, it looks like tune2fs doesn't have any other checks before =
"dangerous"
changes whether the journal needs to be replayed, which could =
potentially lead
to significant corruption if e.g. the inode size is changed and then the =
journal
is replayed afterward.

Some functions call check_fsck_needed(), but that doesn't check if the =
journal
needs to be replayed.  Definitely something for 1.43 before these =
features in
tune2fs become generally available.

Cheers, Andreas

>> --D
>>=20
>>> +	}
>>> +
>>> 	free(device_name);
>>> 	remove_error_table(&et_ext2_error_table);
>>>=20
>>> --
>>> 1.7.3.4
>>>=20
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe =
linux-ext4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
> Cheers, Andreas
>=20
>=20
>=20
>=20
>=20


Cheers, Andreas






--Apple-Mail=_F438EA56-60A1-4805-B006-667205044866
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVlT+cnKl2rkXzB/gAQh+jw/+L1CJaJEBzDtvPaHiUDB/wAiUjcJ1IX8s
V+ggPPZF8QDueXsdtcnu9ndLYTVumjM9RkAKFL9r9yicJ9zgUPnFYD1eWXMPIaU5
klXSdq0MmrWj31Zhq7HPcBKjxJq5eevbXcAhNyVcDwYGhyT3OUmHfgUdZqhzRLBx
r9X3cx8VGMyvAQ1ZHMhaDw/6Mh1f5Jz+Qe+nKnFVPbHGjlNtcfBb4D7TG9wXbRa8
qPFZ7zYy/q23Qd9woF1MQIiVPy3qrJy9oD2JnYVyZ6FcguDVZrEzLykROUaRZsJU
FdSKWIh9lo+8xot+4Z7ZPu7rr1V2f9O5IYjPSX4J8nKoY1cNK6lDSy7YL8qZaub2
D2dpGBywGqSZK9D6tC9jFDVVJ2mc1sGcXQONDEHrYS9nDiJdY6SasyATzMds0TtH
MfqRlee0iwgpjg+k5LmAkb2eXpEbItqAC8jfceaevIiB1gBXok3pQyo9KB3Qc//P
d2XjJsowsqxl9kBy/9GwcTLRH23F3NgJ1E1qOCdhypfJPY7KdYXtfqMajzcB9A2d
QLu8XPBrW67oT7ShLop2czWCEb7suyPNE5ZdVXA8DBDTyWHVA7zCJRFHDA7roCJs
X5W6kIfddIXpoGV2q5eLZyaeFndr7ByfrfxZ5WVTSljL+ONYzXP8ngfm8+gCiaBl
inR2ZTeTIzA=
=QUIv
-----END PGP SIGNATURE-----

--Apple-Mail=_F438EA56-60A1-4805-B006-667205044866--
