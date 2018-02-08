From: "Hornseth, Brenan [USA]" <Hornseth_Brenan@bah.com>
Subject: Buffer overflow in e2fsprog's fsck utility
Date: Thu, 8 Feb 2018 19:27:59 +0000
Message-ID: <92451605ac374b46bc990e64ce79e303CO2PR0601MB792D3182CC5DFFAF8D1616E84F30@CO2PR0601MB792.namprd06.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: "linux-ext4@VGER.KERNEL.ORG" <linux-ext4@VGER.KERNEL.ORG>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mclniron02-ext.bah.com ([128.229.5.22]:35000 "EHLO
        prodesa04-ext.bah.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751756AbeBHT2I (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Feb 2018 14:28:08 -0500
Content-Language: en-US
Content-ID: <625D4ECEB77A4F47804A603A1F5C27D7@namprd06.prod.outlook.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hopefully this is the correct place to report this; I recently found a buff=
er overflow bug in the "fsck" command-line utility on an old version of the=
 tool. Today I checked out the e2fsprogs master and compiled it on my x86-6=
4 ubuntu 16.04 machine and confirmed the bug still exists.

I have been able to produce the bug on multiple machines with a command-lin=
e like:

fsck -t AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAA /dev/sda

Which results in a message: "*** buffer overflow detected ***: fsck termina=
ted"

=20

I believe the bug stems from fsck.c, execute() line 448. Relevant code foll=
ows:

=20
=A0=A0=A0 438=A0=A0=A0=A0=A0=A0=A0=A0 char *s, *argv[80], prog[80];
=A0=A0=A0 439=A0=A0=A0=A0=A0=A0=A0=A0 int=A0 argc, i;
=A0=A0=A0 440=A0=A0=A0=A0=A0=A0=A0=A0 struct fsck_instance *inst, *p;
=A0=A0=A0 441=A0=A0=A0=A0=A0=A0=A0=A0 pid_t=A0=A0 pid;
=A0=A0=A0 442=20
=A0=A0=A0 443=A0=A0=A0=A0=A0=A0=A0=A0 inst =3D malloc(sizeof(struct fsck_in=
stance));
=A0=A0=A0 444=A0=A0=A0=A0=A0=A0=A0=A0 if (!inst)
=A0=A0=A0 445=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return ENOMEM=
;
=A0=A0=A0 446=A0=A0=A0=A0=A0=A0=A0=A0 memset(inst, 0, sizeof(struct fsck_in=
stance));
=A0=A0=A0 447=20
=A0=A0=A0 448=A0=A0=A0=A0=A0=A0=A0=A0 sprintf(prog, "fsck.%s", type);

Note that the sprintf() call does no bounds checking of the "type" argument=
 and that "prog" is only 80 bytes in size.

Please let me know if you need anything else or would prefer a patch (and w=
hat format is preferred).

Thanks,

Brenan=
