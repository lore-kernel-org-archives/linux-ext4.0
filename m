From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: BUG at fs/ext4/inode.c:1590!
Date: Mon, 20 May 2013 07:32:16 -0500
Message-ID: <519A17D0.4050807@redhat.com>
References: <5199514D.5090606@gmx.de> <20130519235504.GA8404@thunk.org> <51998A31.7060200@redhat.com> <5199D615.20106@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741Ab3ETMcV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 May 2013 08:32:21 -0400
In-Reply-To: <5199D615.20106@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/20/13 2:51 AM, Toralf F=C3=B6rster wrote:
> On 05/20/2013 04:28 AM, Eric Sandeen wrote:
>> It's probably possible that it's memory corruption too.
>>
>>>> Can you replicate it?   Do you have the corrupted file system?
>> Right, these bugs need to be narrowed down to be useful.
>>
> When the bug occurred I was neither able to cd into the directory whe=
re
> the log files resides nor I could do a sync. psgrep and friends hang =
too.
> On the other hand I was able to write an email with thunderbird and s=
end
> it out before I had to power off the system - sysrq key alt+print+b
> didn't worked too.
>=20
>> Does trinity start w/ a random seed, so you can restart?  Or better
>> yet, restart w/ that seed and show the last 20 syscalls before the
>> bug, etc?
> yes - trinity uses a randomly choosen seed. SO a replay is possible l=
ater.
> But because the bug occurred after 3 hours /me thinks that a simple
> replay with just few syscalls won't work.

Then maybe it needs an option to say "start with this seed, but only
start operation at the Nth syscall in the series" where N is indicated =
by
the last bit of info in the logs.

i.e. rather than start with seed S and do 10,000 operations and crash,
start with seed S, skip the first 9,990 operations, and do the next 10.
If that doesn't work, skip the first 9,900 ... back up until you get
a small set of reproducing steps.

>> "I threw random garbage at the kernel and something fell off after a
>> few hours" is a bit vague.  ;)
>=20
> yes - I do know that the bug report lacks data to easy reproduce it -
> OTOH I thought it is better to report that then to ignore.

Possibly.  :)  (fwiw I think davej asks that he be cc'd on bugs that
it finds as well)

> To speed up things for fuzzy tests I do use file systems living in a
> tempfs. I'll change my scripts to hold at least the main log file of
> trinity on a hard disk and came back if I do have useful log data too=
=2E

Ok, I do think it's worth testing, but it's not actionable this way.

Given the fact that it's a purely random and usually intended to be
invalid input, it's going to be something that's never been seen
before, and very hard to solve by inspection.

Thanks,
-Eric

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
