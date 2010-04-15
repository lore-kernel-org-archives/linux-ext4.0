From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: EXT4_IOC_MOVE_EXT file corruption!
Date: Thu, 15 Apr 2010 17:27:50 +0900
Message-ID: <4BC6CE06.3070302@rs.jp.nec.com>
References: <20100405220220.GT29604@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:63357 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab0DOI2U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Apr 2010 04:28:20 -0400
In-Reply-To: <20100405220220.GT29604@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Darrick,

(2010/04/06 7:02), Darrick J. Wong wrote:
> Hi all,
>
> I wrote a program called e4frag that deliberately tries to fragment an ext4
> filesystem via EXT4_IOC_MOVE_EXT so that I could run e4defrag through its
> paces.  While running e4frag and e4defrag concurrently on a kernel source tree,
> I discovered ongoing file corruption.  It appears that if e4frag and e4defrag
> hit the same file at same time, the file ends up with a 4K data block from
> somewhere else.  "Somewhere else" seems to be a small chunk of binary gibberish
> followed by contents from other files(!)  Obviously this isn't a good thing to
> see, since today it's header files but tomorrow it could be the credit card/SSN
> database. :)
>
> Ted asked me to send out a copy of the program ASAP, so the test program source
> code is at the end of this message.  To build it, run:
>
> $ gcc -o e4frag -O2 -Wall e4frag.c
>
> and then to run it:
>
> (unpack something in /path/to/files)
> $ cp -pRdu /path/to/files /path/to/intact_files
> $ while true; do e4defrag /path/to/files&  done
> $ while true; do ./e4frag -m 500 -s random /path/to/files&  done
> $ while true; do diff -Naurp /path/to/intact_files /path/to/files; done
>
> ...and wait for diff to cough up differences.  This seems to happen on
> 2.6.34-rc3, and only if e4frag and e4defrag are running concurrently.  Running
> e4frag or e4defrag in a serial loop doesn't produce this corruption, so I think
> it's purely a concurrent access problem.

I couldn't reproduce this problem, somehow.

My environment is:
Arch: i386
Kernel: 2.6.34-rc3
e2fsprogs: 1.41.11
Mount option: delalloc, data=ordered, async
Block size: 4KB
Partition size: 100GB

Is there any difference in your case?
And how long does this file corruption take to be detected?

I ran below program all day long, but problem did not occur.

---
#!/bin/bash

TARGET="/mnt/mp1/TEST/linux-2.6.34-rc3"
ORIG="/mnt/mp1/TEST/linux-2.6.34-rc3-orig"

cp -pRdu $TARGET $ORIG
while true; do ./e4defrag -v $TARGET & done
while true; do ./e4frag -m 500 -s random $TARGET & done
while true; do diff -Naurp $ORIG $TARGET; done
---

# The OOM killer sometimes runs while running this program
   because this is a heavy load for system, though.

Regards,
Akira Fujita
