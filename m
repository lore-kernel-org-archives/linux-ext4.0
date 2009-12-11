From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: System hang with EXT4
Date: Thu, 10 Dec 2009 18:17:09 -0800
Message-ID: <150c16850912101817g497588b2g3aa4dcaf7c5aed7a@mail.gmail.com>
References: <150c16850911231816t514bb1dds4deb541b14a5bad6@mail.gmail.com>
	 <20091208151816.GB3141@atrey.karlin.mff.cuni.cz>
	 <150c16850912091723x7659bf4ke42f209595ceb147@mail.gmail.com>
	 <150c16850912101541k5293b3d7l947b5850fed707b1@mail.gmail.com>
	 <150c16850912101543q231fb703u130c9e646289a8fe@mail.gmail.com>
	 <87fx7ixppv.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:40646 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750AbZLKCRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Dec 2009 21:17:04 -0500
Received: by pwj9 with SMTP id 9so305049pwj.21
        for <linux-ext4@vger.kernel.org>; Thu, 10 Dec 2009 18:17:09 -0800 (PST)
In-Reply-To: <87fx7ixppv.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 10, 2009 at 5:29 PM, Dmitry Monakhov <dmonakhov@openvz.org>=
 wrote:
> Justin Maggard <jmaggard10@gmail.com> writes:
>> I have a little more information to add. =A0After noticing the recen=
t
>> "Fix potential quota deadlock" patch on the mailing list, I figured =
it
>> would be worth a shot to try it without quotas enabled. =A0This also
>> avoids the system hang. =A0I tried applying that patch, but still ha=
d
>> the same symptoms using that kernel. =A0So I'm seeing a consistent
>> system hang with ext4 when delalloc and quotas are enabled on an SMP
>> system. =A0With either quotas or delalloc disabled, it doesn't hang.
>> Both enabled on a single processor system also doesn't hang.
> You also may try another patch
> "[PATCH] ext4: fix sleep inside spinlock issue aka #14739 V2"

Yes, that patch looks like it did the trick.  Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
