From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [v14 3/4] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface support
Date: Fri, 05 Jun 2015 10:45:34 +0300
Message-ID: <87bngulhsx.fsf@openvz.org>
References: <1429728997-21464-1-git-send-email-lixi@ddn.com> <1429728997-21464-4-git-send-email-lixi@ddn.com> <20150426232033.GQ15810@dastard> <CAPTn0cAHOHP060cW8k0-HnyfKdVaUwAVOyLZU43AXtECK6_EaA@mail.gmail.com> <20150428044331.GV21261@dastard> <CAPTn0cBymWmQ5JKAPpFzqzivbEpjzY=s+M5O5bCsne7LbEeiLA@mail.gmail.com> <20150429075924.GB31089@quack.suse.cz> <CAPTn0cDZ3rHBxo2rQCWM=cZsjrL3QJUAkbkaj1ax3b72OUn0Rg@mail.gmail.com> <20150429220717.GX15810@dastard> <CAPTn0cBM5_8TaPzZRqcr_Rk7aHYiErmUdKR69XG55z179p1fZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: Jan Kara <jack@suse.cz>,
	"linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	"viro\@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch\@infradead.org" <hch@infradead.org>,
	John Stultz <john.stultz@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>
To: Li Xi <pkuelelixi@gmail.com>, Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAPTn0cBM5_8TaPzZRqcr_Rk7aHYiErmUdKR69XG55z179p1fZg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=
Content-Type: text/plain

Li Xi <pkuelelixi@gmail.com> writes:

> Hi,
>
> I tried hard to run xfstests on original linux-4.0. In order to do so,
> I skipped some of the tests which cause kernel crash. However, about
> ten tests were skipped. But the crash seems endless. I was using the
> latest xfstests from git repository. I guess there is some mismatch
> between the versions of XFS and xfstests that I used? Should I use
> some special version of xfstests or XFS? Please advise.
IMHO, the best version of the test is the one which cause a kernel crash.
So your have got the best one. But as far as Jan already mentioned this
is likely core mm/timer issue, not XFS specific one.
Google points me that code affected was changed here https://lkml.org/lkml/2015/3/26/14
Likely that you can trigger the crush w/o your patches. Is it correct?
You can try to fix original bug, or simply migrate patches to some
recent stable kernel version.

>
> Regards,
> Li Xi
>
> On Thu, Apr 30, 2015 at 6:07 AM, Dave Chinner <david@fromorbit.com> wrote:
>> On Wed, Apr 29, 2015 at 07:45:40PM +0800, Li Xi wrote:
>>> On Wed, Apr 29, 2015 at 3:59 PM, Jan Kara <jack@suse.cz> wrote:
>>> >   Hi,
>>> >
>>> > On Wed 29-04-15 13:49:08, Li Xi wrote:
>>> >> Thanks for the advices. I tried to run latest xfstests again. However,
>>> >   Dave actually asked you to update 'xfsprogs' not xfstests. Not that
>>> > updating xfstests would be a wrong thing to do but you still need to update
>>> > xfsprogs for xfstests to be able to run some tests. But that's unrelated to
>>> > the oops you reported below.
>>> Understood. I updated both xfstests and xfsprogs to the latest version from git
>>> repository. However, I didn't update xfsdump because of a build failure caused
>>> by missing definitons of 'min' and 'max'
>>
>> The /usr/include/xfs header files are stale. Upgrade your
>> xfslibs-dev package, if there is one for your distro.
>>
>> And, please, report package build failures to the appropriate list,
>> next time, rather than ignoring them?
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJVcVOeAAoJELhyPTmIL6kBo/sH/2kKCuaq/u4C9y2XR62l9wXu
5Qv/ACsKgo46Bw8n/0t8sQ6/R/m4rJcdDcCAvorNCltIvr2v3MqcyZNzTczhgggT
zhPhw/VE+6Avks81DeZ2dSp9uzwoiaVRIKbgj7HeFbQmulrm+SJLgMT2m4iJ1y0o
hTeQJQnta0IhJclde2H0VSBqHwQAbhX0ToZiX+59BaMj2lsDxgmg88tjA0blkYRQ
WsifELjFFUQrHoDd5UY5k8i8nRqRSvA+YEYGflRvLWxSjNX0HtB5YbXLrlOtbqrm
A3Sx9d/2OPwbo246oFFddj9Yh7FRPassUxH5nYbnqEgCrFamzjqdUy03dm8FSxE=
=OzBi
-----END PGP SIGNATURE-----
--=-=-=--
