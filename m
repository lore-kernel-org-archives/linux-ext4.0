From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: what happened with dccaf33fa37 "ext4: flush any pending end_io
 requests before DIO" for 3.0?
Date: Mon, 19 Mar 2012 10:30:01 -0700
Message-ID: <CAFgt=MAGZTZAN5ShVsN-BrSrGSMzZ=-_zrM9KqVA-EK2Fi9FDA@mail.gmail.com>
References: <4ED6942F.7070006@msgid.tls.msk.ru>
	<4F4CBDA1.1080302@msgid.tls.msk.ru>
	<4F6459F2.8010403@msgid.tls.msk.ru>
	<20120319164256.GB10561@quack.suse.cz>
	<20120319172101.GA25038@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, stable@kernel.org,
	linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Michael Tokarev <mjt@tls.msk.ru>
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33034 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030680Ab2CSRaC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Mar 2012 13:30:02 -0400
Received: by qcqw6 with SMTP id w6so1345044qcq.19
        for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2012 10:30:01 -0700 (PDT)
In-Reply-To: <20120319172101.GA25038@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 19, 2012 at 10:21 AM, Greg KH <gregkh@linuxfoundation.org> =
wrote:
> On Mon, Mar 19, 2012 at 05:42:56PM +0100, Jan Kara wrote:
>> On Sat 17-03-12 13:31:30, Michael Tokarev wrote:
>> > Ping?
>> >
>> > Maybe just a one-line reply isn't THAT difficult?
>> >
>> > We've a data corruption bug in current longterm stable kernel
>> > series which is known and has a fix and tagged for -stable for
>> > over half a year already...
>> =A0 Greg, any idea why this patch was not included?
>
> I have no idea, sorry, that was way back in August of 2011, I can bar=
ely
> remember what patches were and were not applied last week...
>
> If it's still needed for 3.0, let me know and I'll be glad to queue i=
t
> up.
Yes. it is still needed. The commit ID of the change is
dccaf33fa37a1bc5d651baeb3bfeb6becb86597b.
Please let me know if there is any problem on applying the change. Than=
ks!

Jiaying

>
> thanks,
>
> greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
