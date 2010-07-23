From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Ext4: batched discard support - simplified version
Date: Fri, 23 Jul 2010 11:30:30 -0400
Message-ID: <AANLkTi=E8dT8+cSge=uPGP4ahrJn4GkZnSxJq45JQcHA@mail.gmail.com>
References: <1278489212-12110-1-git-send-email-lczerner@redhat.com>
	<20100723143604.GF13090@thunk.org>
	<x49hbjqjknj.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	eshishki@redhat.com, rwheeler@redhat.com,
	linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43165 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760732Ab0GWPae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Jul 2010 11:30:34 -0400
Received: by iwn7 with SMTP id 7so302685iwn.19
        for <linux-ext4@vger.kernel.org>; Fri, 23 Jul 2010 08:30:34 -0700 (PDT)
In-Reply-To: <x49hbjqjknj.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 23, 2010 at 11:13 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> "Ted Ts'o" <tytso@mit.edu> writes:
>
>> On Wed, Jul 07, 2010 at 09:53:30AM +0200, Lukas Czerner wrote:
>>>
>>> Hi all,
>>>
>>> since my last post I have done some more testing with various SSD's=
 and the
>>> trend is clear. Trim performance is getting better and the performa=
nce loss
>>> without trim is getting lower. So I have decided to abandon the ini=
tial idea
>>> to track free blocks within some internal data structure - it takes=
 time and
>>> memory.
>>
>> Do you have some numbers about how bad trim actually might be on
>> various devices?
>
> I'll let Lukas answer that when he gets back to the office next week.
> The performance of the trim command itself varies by vendor, of cours=
e.
>
>> I can imagine some devices where it might be better (for wear
>> levelling and better write endurance if nothing else) where it's
>> better to do the trim right away instead of batching things.
>
> I don't think so. =A0In all of the configurations tested, I'm pretty =
sure
> we saw a performance hit from doing the TRIMs right away. =A0The queu=
e
> flush really hurts. =A0Of course, I have no idea what you had in mind=
 for
> the amount of time in between batched discards.

It was my understanding that way back when, Intel was pushing for the
TRIMs to be right away.  That may be why they never fully implemented
the TRIM command to accept more than one sectors worth of vectorized
data.  (That is still multiple ranges per discard, just not
hundreds/thousands.)

Along those lines, does this patch create multi-sector discard trim
commands when there is a large list of discard ranges (ie. thousands
of ranges to discard)?  And if so, does it have a blacklist for SSDs
like the Intel that don't implement the multi-sector payload part of
the spec?

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
