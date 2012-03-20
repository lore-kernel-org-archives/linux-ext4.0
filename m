From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Tue, 20 Mar 2012 10:27:38 +0100
Message-ID: <CAMuHMdWwP8CYQ2JaeFgyErfvCqKO9VThcq1_-RV1sNb3smtL5Q@mail.gmail.com>
References: <20120320025835.GE14363@thunk.org>
	<1332212574.7847.49.camel@joe2Laptop>
	<216818.1332222366@turing-police.cc.vt.edu>
	<20120320.031001.1532841232287663716.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Valdis.Kletnieks@vt.edu, joe@perches.com, tytso@mit.edu,
	anca.emanuel@gmail.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41480 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab2CTJ1j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Mar 2012 05:27:39 -0400
In-Reply-To: <20120320.031001.1532841232287663716.davem@davemloft.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 20, 2012 at 08:10, David Miller <davem@davemloft.net> wrote=
:
> From: Valdis.Kletnieks@vt.edu
> Date: Tue, 20 Mar 2012 01:46:06 -0400
>
>> OK. Say I'm a scraper. =C2=A0How do I distinguish between:
>>
>> pr_info("foo");
>> printk(KERN_INFO "foo");
>>
>> Oh my. seems that both result in exactly the same thing ending up in=
 the
>> dmesg buffer
>
> No it doesn't result in the same output, read the definitions again.
>
> pr_info can be influenced by pr_fmt, plain printk cannot

And for pr_debug(), there's even more, cfr. CONFIG_DYNAMIC_DEBUG.

Gr{oetje,eeting}s,

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0=C2=A0 -- Linus Torvalds
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
