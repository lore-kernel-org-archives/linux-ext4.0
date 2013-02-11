From: "gnehzuil.liu" <gnehzuil.liu@gmail.com>
Subject: Re: ext4 xfstests-bld results for 3.8-rc6 on Pandaboard ES
Date: Mon, 11 Feb 2013 11:36:17 +0800
Message-ID: <4D4DE7C7-35AE-4D26-9283-DA489CC449A4@gmail.com>
References: <20130207220536.GA16092@wallace> <20130208035547.GA19703@gmail.com> <20130211013523.GD10801@thunk.org> <20130211020836.GC13161@thunk.org> <20130211032451.GA14298@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Whitney <enwlinux@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:51171 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab3BKDgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Feb 2013 22:36:23 -0500
Received: by mail-pb0-f51.google.com with SMTP id un15so502369pbc.24
        for <linux-ext4@vger.kernel.org>; Sun, 10 Feb 2013 19:36:23 -0800 (PST)
In-Reply-To: <20130211032451.GA14298@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



=B7=A2=D7=D4=CE=D2=B5=C4 iPad

=D4=DA 2013-2-11=A3=AC=C9=CF=CE=E711:24=A3=ACTheodore Ts'o <tytso@mit.e=
du> =D0=B4=B5=C0=A3=BA

> On Sun, Feb 10, 2013 at 09:08:36PM -0500, Theodore Ts'o wrote:
>> BEGIN TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents S=
un Feb 10 16:29:53 EST 2013
>> Failures: 255
>=20
> Whoops, I spoke too soon.  This looks like a regression, which needs
> investigation...

Hi Ted,

Sorry, I haven't xfstests code in my hand, but I remember that #255 is =
used to test hole punching feature.  So I suspect that no extents is th=
e root cause because my patch set of indirect-based hole punching will =
cause it failed.

Regards,
                                                - Zheng

>=20
>                    - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
