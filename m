From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Fri, 7 Jan 2011 21:43:33 +0200
Message-ID: <AANLkTi=tKCZHPSWj1CiA+o1dw9T_6df=9CXyXVA1Xsh4@mail.gmail.com>
References: <201012280953.46149.kernel@kolivas.org>
	<20101228025343.GD10149@thunk.org>
	<20101228081917.GA1351@bitwizard.nl>
	<AANLkTim_5Yx1RQFHYbmh40xx7c5sU9XsXZEzegC4G=1x@mail.gmail.com>
	<4D1F6244.7050203@redhat.com>
	<AANLkTimAe-p1-ApmnueybQY474J3_G9JL+8WJ2WTn+04@mail.gmail.com>
	<20110107052834.GF2857@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Rogier Wolff <R.E.Wolff@bitwizard.nl>,
	Con Kolivas <kernel@kolivas.org>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46891 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab1AGTnf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Jan 2011 14:43:35 -0500
Received: by qwa26 with SMTP id 26so18143354qwa.19
        for <linux-ext4@vger.kernel.org>; Fri, 07 Jan 2011 11:43:34 -0800 (PST)
In-Reply-To: <20110107052834.GF2857@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 7, 2011 at 7:28 AM, Ted Ts'o <tytso@mit.edu> wrote:
> Also, the kernel patch seems to write the messages in 256-byte
> records, whereas the e2fsck patch assumes the messages are packed
> together in null-terminated packed lines....
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>

I guess that is the reason I always see only the first message on fsck =
:-)
It was always enough information for me though...
feel free to amend to e2fsck patch to match the kernel side.

Thanks,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
