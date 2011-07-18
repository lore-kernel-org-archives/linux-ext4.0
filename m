From: =?UTF-8?Q?Rog=C3=A9rio_Madureira?= <mr@atipico.com.br>
Subject: How to loop inodes of a damaged ext4 filesystem...
Date: Mon, 18 Jul 2011 13:04:14 -0300
Message-ID: <CAMgn0=Xx-EJdX2AYs86V+W3_2c-gOeSmFmWr160+Od_ofserTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:50269 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab1GRQEf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jul 2011 12:04:35 -0400
Received: by fxd18 with SMTP id 18so6883791fxd.11
        for <linux-ext4@vger.kernel.org>; Mon, 18 Jul 2011 09:04:34 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi everybody,

Does anybody know of any software (or even an script) that's able to
search for the inodes of a (damaged) ext4 filesystem and get meta data
(just like sleuthkit "ils" does in ext3)? I am trying to rebuilt a
script to recover files from a ext4 filesystem. As far as I know there
are few tools able to deal with ext4 for file recovery purposes
(mantaining the name and the folder hierarchy, of course).

The original script is here:
http://matt.matzi.org.uk/2008/07/03/reconstructing-heavily-damaged-hard=
-drives/#comment-209

Wally, the blog's owner said:

"Mate, I=E2=80=99m really sorry. Sounds like ext4 (which if you=E2=80=99=
re not aware,
is a relatively recent FS) isn=E2=80=99t supported =E2=80=93 and probab=
ly won=E2=80=99t be for
a while. It=E2=80=99s partially for this reason I=E2=80=99m sticking wi=
th ext3 for the
time being=E2=80=A6 Don=E2=80=99t give up ;-) Keep an eye out for new S=
leuthkit
releases=E2=80=A6 it=E2=80=99s as always only a matter of time=E2=80=A6=
"

Is him correct or there's any advance on this area?

Thanks for any light,
Rog=C3=A9rio Madureira
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
