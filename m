From: Fredrik Andersson <nablaman@gmail.com>
Subject: Re: Fwd: Ext4 bug with fallocate
Date: Tue, 27 Oct 2009 09:17:03 +0100
Message-ID: <a125a870910270117qa90debp8d5a9f90ffb8434@mail.gmail.com>
References: <a125a870910180836i66781e1ey8113e7f8569f1fad@mail.gmail.com>
	 <a125a870910180847s5f3eaf6cxfe58e6ceb26419c6@mail.gmail.com>
	 <4AE67A1B.8060704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:46604 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110AbZJ0IQ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Oct 2009 04:16:59 -0400
Received: by ewy4 with SMTP id 4so4391676ewy.37
        for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2009 01:17:03 -0700 (PDT)
In-Reply-To: <4AE67A1B.8060704@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Not trying to ignore you, but trying to sort out some corruption issu=
es that
> I'm afraid I have to rank higher than a hang for now...

I understand. Good to know someone is thinking about it anyway :-)

>
> From the traces, things are hung up on the i_data_sem; several pdflus=
hes
> want it for read in ext4_get_blocks_wrap, and drbdmakes presumably ha=
ve it
> downed for write in ext4_ext_truncate. =A0I'm not immediately seeing =
the
> deadlock tonight, but then it's getting late...
>
> Is the application that's triggering this something you can share?
>

Sorry, I can't provide source code for these applications.

But drdbmake does what is described above: Preallocates a very big
chunk on disk and then
truncates it to its final length once it's done.

Please let me know if you need more details.

/Fredrik
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
