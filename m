From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Fri, 7 Jan 2011 21:41:24 +0200
Message-ID: <AANLkTinyc+H7t5yF8w81XXts0jfbdt4ROWM8MHEUjNeD@mail.gmail.com>
References: <201012280953.46149.kernel@kolivas.org>
	<20101228025343.GD10149@thunk.org>
	<20101228081917.GA1351@bitwizard.nl>
	<AANLkTim_5Yx1RQFHYbmh40xx7c5sU9XsXZEzegC4G=1x@mail.gmail.com>
	<4D1F6244.7050203@redhat.com>
	<AANLkTimAe-p1-ApmnueybQY474J3_G9JL+8WJ2WTn+04@mail.gmail.com>
	<20110107052613.GE2857@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Rogier Wolff <R.E.Wolff@bitwizard.nl>,
	Con Kolivas <kernel@kolivas.org>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52410 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab1AGTl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Jan 2011 14:41:26 -0500
Received: by qwa26 with SMTP id 26so18141439qwa.19
        for <linux-ext4@vger.kernel.org>; Fri, 07 Jan 2011 11:41:25 -0800 (PST)
In-Reply-To: <20110107052613.GE2857@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 7, 2011 at 7:26 AM, Ted Ts'o <tytso@mit.edu> wrote:
> Am I missing something? =A0The kernel stores up to 3k worth of data, =
on
> a 4k block file system. =A0Whereas e2fsck patch blindly assume 2k wor=
hth
> of data regardless of the block size. =A0The kernel patch looks ok, b=
ut
> the e2fsprogs patch seems badly broken....
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>

I thought that ext4 super block on 4K block is 1K at offset 1K, so
kernel only uses the remaining 2K.

It may very well be that e2fsck patch only works with 4K block size pro=
perly,
because I never tested it on other block sizes.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
