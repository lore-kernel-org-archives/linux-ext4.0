From: Clemens Gruber <clemens.gruber@pqgruber.com>
Subject: Re: Fast ext4 cleanup to avoid data loss after power failure
Date: Tue, 07 Oct 2014 00:04:02 +0200
Message-ID: <543311D2.10102@pqgruber.com>
References: <542EA00B.4040401@pqgruber.com> <alpine.LFD.2.00.1410031550090.2333@localhost.localdomain> <542EC343.7090905@pqgruber.com> <542EC445.5030503@redhat.com> <20141004034707.GA4581@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.pqgruber.com ([178.189.19.235]:42711 "EHLO
	mail.pqgruber.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaJFWF5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2014 18:05:57 -0400
In-Reply-To: <20141004034707.GA4581@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thank you very much for your thorough response, Ted! It helped me out a
lot. Also big thanks to Luk=E1=9A and Eric!

At the moment I am changing every application state update to an atomic
"fwrite to tempfile, fsync (or fdatasync) tempfile, rename, fsync paren=
t
dir".
As the amount of writes I need for application updates is usually small
(1-3 fwrites), I decided to update the application state file without a=
n
extra journal log for now. But if the amount of necessary writes grows,
then I'll introduce a journal log file to minimize the writes needed fo=
r
each application state update.
Or would you consider adding an application level journal anyway?

So after following this design pattern for the application and locking
the filesystem with FIFREEZE before the power fails, does it matter wha=
t
flags I set for the ext4 filesystem?
Should I stay with the default settings data=3Dordered and commit=3D5?

Regards,
Clemens
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
