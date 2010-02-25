From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] fix dblist size accounting (was Re: Invalid superblock after
 e2fsck)
Date: Thu, 25 Feb 2010 11:05:48 -0700
Message-ID: <392E3076-B50A-48D7-A4D3-8E03F7AE4574@sun.com>
References: <1266753077.6554.24.camel@x61s> <4B82EEA9.8050402@redhat.com>
 <76957c4508f13d87ccfd919d88399180@localhost> <4B83F137.8030600@redhat.com>
 <1266945068.5772.19.camel@x61s>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_ltXp2f2Ij+yfC+1nRBiR1g)"
Cc: Eric Sandeen <sandeen@redhat.com>, ext3-users@redhat.com,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?ISO-8859-1?Q?Albert_Sellar=E8s?= <whats@wekk.net>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58298 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187Ab0BYSFx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Feb 2010 13:05:53 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o1PI5mPb016660
	for <linux-ext4@vger.kernel.org>; Thu, 25 Feb 2010 10:05:53 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KYE00200SE18Z00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Thu,
 25 Feb 2010 10:05:48 -0800 (PST)
In-reply-to: <1266945068.5772.19.camel@x61s>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_ltXp2f2Ij+yfC+1nRBiR1g)
Content-type: text/plain; delsp=yes; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: QUOTED-PRINTABLE

On 2010-02-23, at 10:11, Albert Sellar=E8s wrote:
> I already tried to check the filesystem with last e2fsprogs version
> (1.41.10) but with this version I did get a segfault.
>
> I opened a bug with all the information [1]
>
> Thank you!
>
> [1]
> http://sourceforge.net/tracker/?func=3Ddetail&aid=3D2956459&group_i=
d=3D2406&atid=3D102406

I'm not sure if it is related, but I noticed that the above bug is =
=20
segfaulting in ext2fs_add_dir_block(), and I have a patch in my tree =
=20
that fixes the block dblist accounting in the case that realloc() =
=20
fails its allocation.  I'm just in the process of sending out all of =
=20
the patches I've accumulated, so I may as well send this one now.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--Boundary_(ID_ltXp2f2Ij+yfC+1nRBiR1g)
Content-type: application/octet-stream; name=e2fsprogs-dblist.patch;
 x-unix-mode=0644
Content-transfer-encoding: BASE64
Content-disposition: attachment; filename=e2fsprogs-dblist.patch

Rml4IGRibGlzdCBzaXplIGFjY291bnRpbmcgaW4gdGhlIGNhc2Ugd2hlcmUgZXh0
MmZzX3Jlc2l6ZV9tZW0oKSBmYWlscw0KdG8gYWxsb2NhdGUgYSBsYXJnZXIgYnVm
ZmVyLg0KDQpJbmRleDogZTJmc3Byb2dzLTEuNDEuMTAvbGliL2V4dDJmcy9kYmxp
c3QuYw0KPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PQ0KLS0tIGUyZnNwcm9ncy0xLjQxLjEw
Lm9yaWcvbGliL2V4dDJmcy9kYmxpc3QuYw0KKysrIGUyZnNwcm9ncy0xLjQxLjEw
L2xpYi9leHQyZnMvZGJsaXN0LmMNCkBAIC0xNjksNyArMTY5LDcgQEAgZXJyY29k
ZV90IGV4dDJmc19hZGRfZGlyX2Jsb2NrKGV4dDJfZGJsaQ0KIAkJCQkJICAgc2l6
ZW9mKHN0cnVjdCBleHQyX2RiX2VudHJ5KSwNCiAJCQkJCSAgICZkYmxpc3QtPmxp
c3QpOw0KIAkJaWYgKHJldHZhbCkgew0KLQkJCWRibGlzdC0+c2l6ZSAtPSAxMDA7
DQorCQkJZGJsaXN0LT5zaXplID0gb2xkX3NpemUgLyBzaXplb2Yoc3RydWN0IGV4
dDJfZGJfZW50cnkpOw0KIAkJCXJldHVybiByZXR2YWw7DQogCQl9DQogCX0NCg==

--Boundary_(ID_ltXp2f2Ij+yfC+1nRBiR1g)--
