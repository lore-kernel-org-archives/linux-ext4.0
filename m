From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: EXT4_IOC_MOVE_EXT file corruption!
Date: Thu, 15 Apr 2010 15:25:33 -0400
Message-ID: <n2z87f94c371004151225q6aed9b2eud2d6bbd01419a189@mail.gmail.com>
References: <20100405220220.GT29604@tux1.beaverton.ibm.com>
	 <4BC6CE06.3070302@rs.jp.nec.com>
	 <20100415191724.GW29604@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:53543 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab0DOTZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Apr 2010 15:25:34 -0400
Received: by pzk42 with SMTP id 42so1426434pzk.4
        for <linux-ext4@vger.kernel.org>; Thu, 15 Apr 2010 12:25:33 -0700 (PDT)
In-Reply-To: <20100415191724.GW29604@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 15, 2010 at 3:17 PM, Darrick J. Wong <djwong@us.ibm.com> wr=
ote:
> On Thu, Apr 15, 2010 at 05:27:50PM +0900, Akira Fujita wrote:
>> Hi Darrick,
>>
>> (2010/04/06 7:02), Darrick J. Wong wrote:
>>> Hi all,
>>>
>>> I wrote a program called e4frag that deliberately tries to fragment=
 an ext4
>>> filesystem via EXT4_IOC_MOVE_EXT so that I could run e4defrag throu=
gh its
>>> paces. =A0While running e4frag and e4defrag concurrently on a kerne=
l source tree,
>>> I discovered ongoing file corruption. =A0It appears that if e4frag =
and e4defrag
>>> hit the same file at same time, the file ends up with a 4K data blo=
ck from
>>> somewhere else. =A0"Somewhere else" seems to be a small chunk of bi=
nary gibberish
>>> followed by contents from other files(!) =A0Obviously this isn't a =
good thing to
>>> see, since today it's header files but tomorrow it could be the cre=
dit card/SSN
>>> database. :)
>>>
>>> Ted asked me to send out a copy of the program ASAP, so the test pr=
ogram source
>>> code is at the end of this message. =A0To build it, run:
>>>
>>> $ gcc -o e4frag -O2 -Wall e4frag.c
>>>
>>> and then to run it:
>>>
>>> (unpack something in /path/to/files)
>>> $ cp -pRdu /path/to/files /path/to/intact_files
>>> $ while true; do e4defrag /path/to/files& =A0done
>>> $ while true; do ./e4frag -m 500 -s random /path/to/files& =A0done
>>> $ while true; do diff -Naurp /path/to/intact_files /path/to/files; =
done
>>>
>>> ...and wait for diff to cough up differences. =A0This seems to happ=
en on
>>> 2.6.34-rc3, and only if e4frag and e4defrag are running concurrentl=
y. =A0Running
>>> e4frag or e4defrag in a serial loop doesn't produce this corruption=
, so I think
>>> it's purely a concurrent access problem.
>>
>> I couldn't reproduce this problem, somehow.
>>
>> My environment is:
>> Arch: i386
>> Kernel: 2.6.34-rc3
>> e2fsprogs: 1.41.11
>> Mount option: delalloc, data=3Dordered, async
>> Block size: 4KB
>> Partition size: 100GB
>>
>> Is there any difference in your case?
>> And how long does this file corruption take to be detected?
>>
>> I ran below program all day long, but problem did not occur.
>
> Hmm. =A0I was running with 2.6.34-rc3 on x86-64, same block size, tho=
ugh with a
> 2TB mdraid0. =A0It usually took a few hours to reproduce, though I've=
 noticed
> that if I kick off at least as many e4defrags and e4frags, it will sh=
ow up much
> sooner. =A0Thank you for trying this out!

If its not reproducible on a simple disk, it could be a bug in the
barrier code for mdraid.

But I think raid0 support for barriers has been around for a long time.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
