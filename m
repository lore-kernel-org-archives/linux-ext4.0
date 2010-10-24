From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from previous
 mount: IO failure
Date: Sun, 24 Oct 2010 10:50:13 +0200
Message-ID: <AANLkTim94HAvxTgvhdhmJ6oPR0YpaPT97TEXq8ZCfTPU@mail.gmail.com>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm>
	<20101022172536.GP3127@thunk.org>
	<AANLkTi=jYWSKwz1=pHQyaVq22bjgO-EF5xC53x9mGdvN@mail.gmail.com>
	<20101023221714.GB24650@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Bernd Schubert <bs_lists@aakef.fastmail.fm>,
	linux-ext4@vger.kernel.org, Bernd Schubert <bschubert@ddn.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35119 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab0JXIuO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Oct 2010 04:50:14 -0400
Received: by qwk3 with SMTP id 3so688521qwk.19
        for <linux-ext4@vger.kernel.org>; Sun, 24 Oct 2010 01:50:14 -0700 (PDT)
In-Reply-To: <20101023221714.GB24650@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 24, 2010 at 12:17 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sat, Oct 23, 2010 at 06:00:05PM +0200, Amir Goldstein wrote:
>>
>> IMHO, and I've said it before, the mount flag which Bernd requests
>> already exists, namely 'errors=3D', both as mount option and as
>> persistent default, but it is not enforced correctly on mount time.
>> If an administrator decides that the correct behavior when error is
>> detected is abort or remount-ro, what's the sense it letting the
>> filesystem mount read-write without fixing the problem?
>
> Again, consider the case of the root filesystem containing an error.
> When the error is first discovered during the source of the system's
> operation, and it's set to errors=3Dpanic, you want to immediately
> reboot the system. =A0But then, when root file system is mounted, it
> would be bad to have the system immediately panic again. =A0Instead,
> what you want to have happen is to allow e2fsck to run, correct the
> file system errors, and then system can go back to normal operation.
>
> So the current behavior was deliberately designed to be the way that
> it is, and the difference is between "what do you do when you come
> across a file system error", which is what the errors=3D mount option=
 is
> all about, and "this file system has some kind of error associated
> with it". =A0Just because it has an error associated with it does not
> mean that immediately rebooting is the right thing to do, even if the
> file system is set to "errors=3Dpanic". =A0In fact, in the case of a =
root
> file system, it is manifestly the wrong thing to do. =A0If we did wha=
t
> you suggested, then the system would be trapped in a reboot loop
> forever.
>

Yes, I do realize that to panic on mount would be stupid :-)
this is why I wrote that there is no sense in mounting the file system
read-write.
let me rephrase the 3 error behaviors as the designer (you?) intended:
errors=3Dcontinue - "always stay out of my way and let me corrupt my
file system as much as I want".
errors=3Dread-only - "never let me corrupt my file system more than it
already is".
errors=3Dpanic - "never let me corrupt my file system ... and never let
me view files which may not be there after I reboot".

If you agree with my interpretations to the errors behavior codes,
than you should agree to enforcing on mount time:
errors=3Dcontinue - if ERROR_FS, go a head and corrupt your file system
errors=3Dread-only - if ERROR_FS, allow only read-only mount
errors=3Dpanic - if ERROR_FS, allow only read-only mount (files you see
now are safely stored on disk)

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
