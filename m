From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: System hang with EXT4
Date: Thu, 10 Dec 2009 15:43:06 -0800
Message-ID: <150c16850912101543q231fb703u130c9e646289a8fe@mail.gmail.com>
References: <150c16850911231816t514bb1dds4deb541b14a5bad6@mail.gmail.com>
	 <20091208151816.GB3141@atrey.karlin.mff.cuni.cz>
	 <150c16850912091723x7659bf4ke42f209595ceb147@mail.gmail.com>
	 <150c16850912101541k5293b3d7l947b5850fed707b1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:45852 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbZLJXnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Dec 2009 18:43:00 -0500
Received: by pwj9 with SMTP id 9so237104pwj.21
        for <linux-ext4@vger.kernel.org>; Thu, 10 Dec 2009 15:43:07 -0800 (PST)
In-Reply-To: <150c16850912101541k5293b3d7l947b5850fed707b1@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 9, 2009 at 5:23 PM, Justin Maggard <jmaggard10@gmail.com> w=
rote:
> On Tue, Dec 8, 2009 at 7:18 AM, Jan Kara <jack@suse.cz> wrote:
>> =A0Can you still switch consoles after the system hangs (it's good t=
o
>> debug this on a text console)? If yes, could you press Alt-Sysrq-w a=
nd
>> take a picture of the console by digital camera or so (take pictures=
 of
>> as many screens as possible using console scrollback)? Thanks.
>
> Thanks for the response. =A0Console scrollback doesn't seem to work f=
or
> me in that mode. =A0I tried it three times. =A0Two of the times the l=
ist
> was empty. =A0The other time, the screen just listed a bunch of rm
> processes.

I have a little more information to add. =A0After noticing the recent
"Fix potential quota deadlock" patch on the mailing list, I figured it
would be worth a shot to try it without quotas enabled. =A0This also
avoids the system hang. =A0I tried applying that patch, but still had
the same symptoms using that kernel. =A0So I'm seeing a consistent
system hang with ext4 when delalloc and quotas are enabled on an SMP
system. =A0With either quotas or delalloc disabled, it doesn't hang.
Both enabled on a single processor system also doesn't hang.

-Justin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
