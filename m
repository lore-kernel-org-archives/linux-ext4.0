From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] ext4: make quota as first class supported feature
Date: Tue, 30 Aug 2011 01:17:03 +0200
Message-ID: <20110829231703.GL5672@quack.suse.cz>
References: <1313780769-21713-1-git-send-email-adityakali@google.com>
 <20110829215732.GJ5672@quack.suse.cz>
 <CAGr1F2EXgaWVywbRUUdOhPmvv3ZXwt1nnOpkyuBgygSYvJ+h-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, adilger@dilger.ca, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242Ab1H2XWy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Aug 2011 19:22:54 -0400
Content-Disposition: inline
In-Reply-To: <CAGr1F2EXgaWVywbRUUdOhPmvv3ZXwt1nnOpkyuBgygSYvJ+h-A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 29-08-11 15:42:36, Aditya Kali wrote:
> On Mon, Aug 29, 2011 at 2:57 PM, Jan Kara <jack@suse.cz> wrote:
> > On Fri 19-08-11 12:06:09, Aditya Kali wrote:
> >> This patch is an attempt towards supporting quotas as first class
> >> feature in ext4. It is based on the proposal at:
> >> https://ext4.wiki.kernel.org/index.php/Design_For_1st_Class_Quota_=
in_Ext4
> >> This patch introduces a new feature - EXT4_FEATURE_RO_COMPAT_QUOTA=
 which, when
> >> turned on, enables quota accounting at mount time iteself. Also, t=
he
> >> quota inodes are stored in two additional superblock fields.
> >> Some changes introduced by this patch that should be pointed out a=
re:
> >> 1) Two new ext4-superblock fields - s_usr_quota_inum and s_grp_quo=
ta_inum
> >> =A0 =A0for storing the quota inodes in use.
> >> 2) If the QUOTA feature and corresponding quota inodes are set in =
superblock,
> >> =A0 =A0Quotas are turned on at mount time irrespective of the quot=
a mount options.
> >> =A0 =A0Thus the mount options 'quota', 'usrquota' and 'grpquota' a=
re completely
> >> =A0 =A0ignored with the new QUOTA feature flag.
> > =A0Hmm, cannot we automatically enable 'usrquota' and 'grpquota' op=
tions
> > when we see QUOTA feature enabled? Quota tools still need these opt=
ions to
> > identify a filesystem they can work with (although another option w=
ould be
> > to change quota tools to use GETFMT with ext4 filesystem to identif=
y
> > whether quotas are enabled or not).
> >
> In my current change, these options are just ignored, and the user ca=
n
> still set them if any user tools depend on them while
> mounting/remounting the filesystem.
> The design wiki
> (https://ext4.wiki.kernel.org/index.php/Design_For_1st_Class_Quota_in=
_Ext4#How_can_userspace_tell_if_quota_is_enabled.3F)
> mentions that 'usrquota' & 'grpquota' options won't be used (so I was
> under impression that they are being deprecated). Also, if these are
> set automatically on mount, it would mean that the user wont be able
> to set these options anymore.
  OK, probably makes sense in the long run. I'll update quota tools to =
use
GETFMT quotactl then...

> >> 3) Default quota inodes are: inode#3 for tracking userquota and in=
ode#4 for
> >> =A0 =A0tracking group quota. The superblock fields can be set to u=
se other inodes
> >> =A0 =A0as well.
> >> 4) mke2fs or tune2fs will initialize these inodes when quota featu=
re is
> >> =A0 =A0being set. The default reserved inodes will not be visible =
to user as
> >> =A0 =A0regular files.
> >> 5) Once quotas are turned on, they cannot be turned off while the =
=46S is
> >> =A0 =A0mounted. This is because we do not want to let the quota ge=
t inconsistent.
> > =A0Both xfs and ocfs2 allow for mode in which usage is tracked (i.e=
=2E quota
> > information is kept uptodate) but limits are not enforced. I imagin=
e this
> > might be useful in some cases and also from consistency point of vi=
ew it
> > would be nice.
> >
> > In ocfs2 I implemented it so that on mount, updating of quota infor=
mation
> > is enabled (when appropriate fs feature is enabled) but limits are =
not
> > enforced. Quotaon/quotaoff commands then toggle enforcement of quot=
a
> > limits. XFS has mount options which decide whether quota informatio=
n should
> > be kept uptodate and whether it should be enforced or not.
>=20
> Enabling only usage on mount makes sense. The limits can then be
> turned on using quotaon. I assume then we will also need to allow
> turning the limits off by user (instead of completely denying
> quotaoff)?
  Yes.

> >> 6) With the QUOTA feature set, since the quota inodes are hidden, =
some of the
> >> =A0 =A0utilities from quota-tools will no longer work correctly. I=
nstead, e2fsprogs
> >> =A0 =A0will include support for fixing the quota files.
> > =A0I think it might be useful in some cases to enable only user quo=
tas but
> > leave group quotas disabled (it slightly reduces quota overhead - m=
ainly
> > because we have less quota structures to update on disk). So it wou=
ld be
> > useful to have USRQUOTA and GRPQUOTA features separate...
> >
> It is possible to enable only one type of quotas. Instead of having
> two filesystem features, there are already two superblock fields
> s_usr_quota_inum and s_grp_quota_inum. The enabling can be disabled b=
y
> setting the corresponding field to '0'. This is also supported via
> tune2fs:
>=20
> # to enable only user quotas and not group quotas:
> $ tune2fs -Q usrquota /dev/ram1 # this will set the 'quota' feature i=
n
> superblock and initialize only usrquota inode.
>=20
> # to enable both user and group quotas:
> $ tune2fs -Q usrquota,grpquota /dev/ram1
  Ah, I see. OK.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
