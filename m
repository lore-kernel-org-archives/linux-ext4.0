From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: ext5
Date: Thu, 11 Feb 2010 09:08:36 +0530
Message-ID: <ea11fea31002101938y7bd5d6f4u5f7cdda972ea72e2@mail.gmail.com>
References: <fe37fadb578fb9a3df9c878f8b9e9c3e@remailer.privacy.at>
	<20100210215028.GD739@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Anonymous Remailer (austria)" <mixmaster@remailer.privacy.at>,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f185.google.com ([209.85.223.185]:39958 "EHLO
	mail-iw0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab0BKDi5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Feb 2010 22:38:57 -0500
Received: by iwn15 with SMTP id 15so874863iwn.19
        for <linux-ext4@vger.kernel.org>; Wed, 10 Feb 2010 19:38:56 -0800 (PST)
In-Reply-To: <20100210215028.GD739@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 11, 2010 at 3:20 AM,  <tytso@mit.edu> wrote:
> On Wed, Feb 10, 2010 at 12:40:05AM +0100, Anonymous Remailer (austria=
) wrote:
>>
>> will there be ext5? ext4 works just fine so far. but it could be
>> even more faster. otherwise i have to jump to btrfs (when it's
>> done).
>
> We currently don't have any plans for an "ext5". =A0There might be so=
me
> new features that might gradually trickle into ext4; for example
> there's someone who I may be mentoring who is interested in working o=
n
> an idea I've had to add read-only compression to ext4. =A0(Actually, =
the
> design I've sketched out makes 90% of the work be file system
> independent,
Hi Ted,

Is this design somewhere on net so that we can read/lookup it up ?

Thanks -
Manish
> so it's something that could be retrofitted into other
> filesystems: xfs, btrfs, etc.)
>
> The benchmarks I've seen don't show that btrfs is that much faster;
> for some workloads its faster, for others its slower. =A0Of course,
> there may be some file system tuning that still remains to be done,
> both for btrfs and ext4, that may change the performance numbers
> slightly.
>
> The main reason why I suspect people will be interested in btrfs is t=
o
> because of some of its features (i.e., file system level snapshots,
> data level checksums, etc.) that are unlikely to show up in ext4. =A0=
I
> also suspect that btrfs will take a while to mature, as all file
> systems do. =A0ZFS for example took good five years to development, a=
nd
> perhaps another 3-4 before people started really trusting it for
> critical production uses.
>
> Regards,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks -
Manish
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[$\*.^ -- I miss being one of them
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
