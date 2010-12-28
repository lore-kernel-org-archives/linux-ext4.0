From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Tue, 28 Dec 2010 12:30:59 +0200
Message-ID: <AANLkTim_5Yx1RQFHYbmh40xx7c5sU9XsXZEzegC4G=1x@mail.gmail.com>
References: <201012280953.46149.kernel@kolivas.org>
	<20101228025343.GD10149@thunk.org>
	<20101228081917.GA1351@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Rogier Wolff <R.E.Wolff@bitwizard.nl>,
	Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-usb@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59772 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab0L1KbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Dec 2010 05:31:00 -0500
In-Reply-To: <20101228081917.GA1351@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 28, 2010 at 10:19 AM, Rogier Wolff <R.E.Wolff@bitwizard.nl>=
 wrote:
> On Mon, Dec 27, 2010 at 09:53:43PM -0500, Ted Ts'o wrote:
>> On Tue, Dec 28, 2010 at 09:53:45AM +1100, Con Kolivas wrote:
>> > [1048401.773270] EXT4-fs (sde8): mounted filesystem with writeback=
 data mode.
>> > Opts: (null)
>> > [1048702.736011] EXT4-fs (sde8): error count: 3
>> > [1048702.736016] EXT4-fs (sde8): initial error at 1289053677:
>> > ext4_journal_start_sb:251
>> > [1048702.736018] EXT4-fs (sde8): last error at 1289080948: ext4_pu=
t_super:719
>>
>> That's actually not an error. =A0It's a report which is generated ev=
ery
>> 24 hours, indicating that there has been 3 errors since the last tim=
e
>> the error count has been cleared, with the first error taking place =
at
>> Sat Nov 6 10:27:57 2010 (US/Eastern) in the function
>> ext4_journal_start_sb(), at line 251, and the most recent error taki=
ng
>> place at Sat Nov 6 18:02:28 2010 (US/Eastern), in the function
>> ext4_put_super() at line 719. =A0This is a new feature which was add=
ed
>> in 2.6.36.
>
> Nice. But the issue you're not mentioning is: What errors could have
> happened on the 6th of november? Should Con worry about those errors?
>

Ted,

I would like to use this opportunity to remind you about my
record_journal_errstr()
implementation, see:
https://github.com/amir73il/ext4-snapshots/blob/next3-stable/fs/next3/s=
uper.c#L157

It records the initial errors messages (which I found to be the most
interesting),
in a message buffer on the unused space after the journal super block
(3K on a 4K block fs).

fsck prints out those messages and clears the buffer.
In under a year of Next3 fs in beta and production, it has helped me ma=
ny times
to analyse bugs post-mortem and find the problem.

If there is demand, I can post the patch for Ext4.

Amir.

> OK, the chances are that he has rebooted since november, and that an
> older fsck fixed the errors, but not cleared the "fs errror log". Wou=
ld
> these errors have triggered a "remount-readonly" if the fs was mounte=
d
> like that?
>
> I don't reboot that often:
>
> obelix:~> uptime
> =A009:16:19 up 175 days, 19:04, 19 users, =A0load average: 110.10, 11=
0.61, 111.22
>
> (and yes, the load is quite high on that machine. I won't polute this
> thread about that....)
>
> =A0 =A0 =A0 =A0Roger.
>
> --
> ** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-26009=
98 **
> ** =A0 =A0Delftechpark 26 2628 XH =A0Delft, The Netherlands. KVK: 272=
39233 =A0 =A0**
> *-- BitWizard writes Linux device drivers for any device you may have=
! --*
> Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous state=
ment.
> Does it sit on the couch all day? Is it unemployed? Please be specifi=
c!
> Define 'it' and what it isn't doing. --------- Adapted from lxrbot FA=
Q
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
