From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: Question about ext4 online defrag test case
Date: Sat, 16 Jan 2010 22:58:30 +0530
Message-ID: <ea11fea31001160928s68853d34l47d64131751b1653@mail.gmail.com>
References: <4B4EEF94.5000902@rs.jp.nec.com> <87f94c371001141304n18bcd208kd97f08646d37d1e2@mail.gmail.com>
	<37d33d831001150541o1b674580u14719e72e3ad8e78@mail.gmail.com>
	<20100116062930.GB25273@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: SandeepKsinha <sandeepksinha@gmail.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Akira Fujita <a-fujita@rs.jp.nec.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:61943 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab0APR2u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Jan 2010 12:28:50 -0500
Received: by iwn32 with SMTP id 32so1272580iwn.33
        for <linux-ext4@vger.kernel.org>; Sat, 16 Jan 2010 09:28:50 -0800 (PST)
In-Reply-To: <20100116062930.GB25273@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 16, 2010 at 11:59 AM,  <tytso@mit.edu> wrote:
> On Fri, Jan 15, 2010 at 07:11:28PM +0530, SandeepKsinha wrote:
>> >> I found your comment about ext4 online defrag on Ubuntu BBS by ac=
cident.
>> >> https://bugs.launchpad.net/ubuntu/+source/e2fsprogs/+bug/321528
>> >>
>> >> I would like to address this problem so I ran e4defrag on the sys=
tem
>> >> which was under memory pressure. But unfortunately I could not fi=
nd the bug.
>> >> If you have already known how to reproduce this kind of problem,
>> >> could you teach me how?
>
> I'm sorry I wasn't clear. =A0I don't know of any specific problem wit=
h
> the code,

Hi Akira/Ted,

I am trying to use EXT4_TOC_MOVE_EXT ioctl for one of my test programs
to move blocks in a file (the code has been copied from e4defrag) But
it fails with below error.


Little bit of debugging reveals that the ioctl  expects the source
file also to be in both read write mode. Once I open the file in rw
mode it succeeds, but e4defrag also seems to be opening the source
file in readonly mode only.  Wondering how it succeeds
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
	case EXT4_IOC_MOVE_EXT: {
		struct move_extent me;
		struct file *donor_filp;
		int err;
                /* Manish debug code */
		printk(KERN_CRIT "Read mode : %d\n", filp->f_mode & FMODE_READ);
		printk(KERN_CRIT "Write mode : %d\n", filp->f_mode & FMODE_WRITE);
		if (!(filp->f_mode & FMODE_READ) ||
		    !(filp->f_mode & FMODE_WRITE))
			return -EBADF;

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Dmesg output =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[ 7893.627735] Read mode : 1
[ 7893.627744] Write mode : 0

Is intended ? or has been changed in recent code ?

Thanks -
Manish

> but I and some other ext4 developers remain a bit conerned
> about the code because of how it is structured, and the fact that
> there is so much code and there hasn't been a lot of people spent a
> lot of time going through it and cleaning it up. =A0We also don't hav=
e
> good regression tests for the kernel defrag support code.
>
> This is partially my fault; I haven't had enough time to do more
> testing and code clean up on the defrag code. =A0I need to spend more
> time doing some testing and code cleanup before I'll be comfortable
> telling people that it is as reliable as other parts of ext4 in terms
> of not potentially losing their data. =A0Maybe it's just my paranoia.=
=2E..
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0- Ted
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
