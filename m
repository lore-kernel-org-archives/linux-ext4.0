From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH v2] ext4: make quota as first class supported feature
Date: Mon, 29 Aug 2011 15:42:36 -0700
Message-ID: <CAGr1F2EXgaWVywbRUUdOhPmvv3ZXwt1nnOpkyuBgygSYvJ+h-A@mail.gmail.com>
References: <1313780769-21713-1-git-send-email-adityakali@google.com> <20110829215732.GJ5672@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: adilger@dilger.ca, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:55200 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab1H2WnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Aug 2011 18:43:00 -0400
Received: from hpaq11.eem.corp.google.com (hpaq11.eem.corp.google.com [172.25.149.11])
	by smtp-out.google.com with ESMTP id p7TMgx0E012246
	for <linux-ext4@vger.kernel.org>; Mon, 29 Aug 2011 15:42:59 -0700
Received: from yib18 (yib18.prod.google.com [10.243.65.82])
	by hpaq11.eem.corp.google.com with ESMTP id p7TMgua1021819
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 29 Aug 2011 15:42:57 -0700
Received: by yib18 with SMTP id 18so3676633yib.9
        for <linux-ext4@vger.kernel.org>; Mon, 29 Aug 2011 15:42:56 -0700 (PDT)
In-Reply-To: <20110829215732.GJ5672@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for your feedback.


On Mon, Aug 29, 2011 at 2:57 PM, Jan Kara <jack@suse.cz> wrote:
> On Fri 19-08-11 12:06:09, Aditya Kali wrote:
>> This patch is an attempt towards supporting quotas as first class
>> feature in ext4. It is based on the proposal at:
>> https://ext4.wiki.kernel.org/index.php/Design_For_1st_Class_Quota_in=
_Ext4
>> This patch introduces a new feature - EXT4_FEATURE_RO_COMPAT_QUOTA w=
hich, when
>> turned on, enables quota accounting at mount time iteself. Also, the
>> quota inodes are stored in two additional superblock fields.
>> Some changes introduced by this patch that should be pointed out are=
:
>> 1) Two new ext4-superblock fields - s_usr_quota_inum and s_grp_quota=
_inum
>> =C2=A0 =C2=A0for storing the quota inodes in use.
>> 2) If the QUOTA feature and corresponding quota inodes are set in su=
perblock,
>> =C2=A0 =C2=A0Quotas are turned on at mount time irrespective of the =
quota mount options.
>> =C2=A0 =C2=A0Thus the mount options 'quota', 'usrquota' and 'grpquot=
a' are completely
>> =C2=A0 =C2=A0ignored with the new QUOTA feature flag.
> =C2=A0Hmm, cannot we automatically enable 'usrquota' and 'grpquota' o=
ptions
> when we see QUOTA feature enabled? Quota tools still need these optio=
ns to
> identify a filesystem they can work with (although another option wou=
ld be
> to change quota tools to use GETFMT with ext4 filesystem to identify
> whether quotas are enabled or not).
>
In my current change, these options are just ignored, and the user can
still set them if any user tools depend on them while
mounting/remounting the filesystem.
The design wiki
(https://ext4.wiki.kernel.org/index.php/Design_For_1st_Class_Quota_in_E=
xt4#How_can_userspace_tell_if_quota_is_enabled.3F)
mentions that 'usrquota' & 'grpquota' options won't be used (so I was
under impression that they are being deprecated). Also, if these are
set automatically on mount, it would mean that the user wont be able
to set these options anymore.

>> 3) Default quota inodes are: inode#3 for tracking userquota and inod=
e#4 for
>> =C2=A0 =C2=A0tracking group quota. The superblock fields can be set =
to use other inodes
>> =C2=A0 =C2=A0as well.
>> 4) mke2fs or tune2fs will initialize these inodes when quota feature=
 is
>> =C2=A0 =C2=A0being set. The default reserved inodes will not be visi=
ble to user as
>> =C2=A0 =C2=A0regular files.
>> 5) Once quotas are turned on, they cannot be turned off while the FS=
 is
>> =C2=A0 =C2=A0mounted. This is because we do not want to let the quot=
a get inconsistent.
> =C2=A0Both xfs and ocfs2 allow for mode in which usage is tracked (i.=
e. quota
> information is kept uptodate) but limits are not enforced. I imagine =
this
> might be useful in some cases and also from consistency point of view=
 it
> would be nice.
>
> In ocfs2 I implemented it so that on mount, updating of quota informa=
tion
> is enabled (when appropriate fs feature is enabled) but limits are no=
t
> enforced. Quotaon/quotaoff commands then toggle enforcement of quota
> limits. XFS has mount options which decide whether quota information =
should
> be kept uptodate and whether it should be enforced or not.

Enabling only usage on mount makes sense. The limits can then be
turned on using quotaon. I assume then we will also need to allow
turning the limits off by user (instead of completely denying
quotaoff)?

>
>> 6) With the QUOTA feature set, since the quota inodes are hidden, so=
me of the
>> =C2=A0 =C2=A0utilities from quota-tools will no longer work correctl=
y. Instead, e2fsprogs
>> =C2=A0 =C2=A0will include support for fixing the quota files.
> =C2=A0I think it might be useful in some cases to enable only user qu=
otas but
> leave group quotas disabled (it slightly reduces quota overhead - mai=
nly
> because we have less quota structures to update on disk). So it would=
 be
> useful to have USRQUOTA and GRPQUOTA features separate...
>
It is possible to enable only one type of quotas. Instead of having
two filesystem features, there are already two superblock fields
s_usr_quota_inum and s_grp_quota_inum. The enabling can be disabled by
setting the corresponding field to '0'. This is also supported via
tune2fs:

# to enable only user quotas and not group quotas:
$ tune2fs -Q usrquota /dev/ram1 # this will set the 'quota' feature in
superblock and initialize only usrquota inode.

# to enable both user and group quotas:
$ tune2fs -Q usrquota,grpquota /dev/ram1


> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Honza

--
Aditya
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
