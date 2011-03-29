From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: breaking ext4 to test recovery
Date: Tue, 29 Mar 2011 13:33:51 -0400
Message-ID: <AANLkTinJ4-PPTi0q76fThmq9a_qe1PadVueObPtRLruY@mail.gmail.com>
References: <25B374CC0D9DFB4698BB331F82CD0CF20D61B8@wdscexbe08.sc.wdc.com>
 <4D91E39A.3000800@redhat.com> <20110329143305.GA6057@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	Daniel Taylor <Daniel.Taylor@wdc.com>,
	linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39260 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab1C2ReL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Mar 2011 13:34:11 -0400
Received: by iwn34 with SMTP id 34so371456iwn.19
        for <linux-ext4@vger.kernel.org>; Tue, 29 Mar 2011 10:34:11 -0700 (PDT)
In-Reply-To: <20110329143305.GA6057@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 29, 2011 at 10:33 AM, Rogier Wolff <R.E.Wolff@bitwizard.nl>=
 wrote:
> On Tue, Mar 29, 2011 at 08:50:18AM -0500, Eric Sandeen wrote:
>> Another tool which can be useful for this sort of thing is
>> fsfuzzer. =A0It writes garbage; using dd to write zeros actually
>> might be "nice" corruption.
>
> Besides writing blocks of "random data", you could write blocks with =
a
> small percentage of bits (byte) set to non-zero, or just toggle a
> configurable number of bits (bytes). This is slightly more devious th=
an just
> "random data".

I don't know what exactly is being tested, but "hdparm
--make-bad-sector" can be used to create a media error on a specific
sector.

Thus allowing you to simulate a sector failing in the middle of the jou=
rnal.

I assume that is a relevant test.

fyi: --repair-sector undoes the damage.  You may need to follow that
with a normal write to put legit data there.

If you try a normal data write without first repairing, the drive
should mark the sector permanently bad and remap that sector to a
spare sector.

I have only used these tools with raw drives, no partitions, etc.  So
I've never had to worry about data loss, etc.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
