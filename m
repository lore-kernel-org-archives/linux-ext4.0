From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: E2fsprogs master branch now has all 64-bit patch applied
Date: Mon, 14 Jun 2010 15:15:40 -0500
Message-ID: <4C168DEC.1040106@redhat.com>
References: <E1OO9sy-0006P1-Nr@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab0FNUPo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jun 2010 16:15:44 -0400
In-Reply-To: <E1OO9sy-0006P1-Nr@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/14/2010 08:39 AM, Theodore Ts'o wrote:
> It's taken way too long, but I've finally finished integrating the
> 64-bit patches into e2fsprogs's mainline repository.  All of the
> necessary patches should now be in the master branch for e2fsprogs.

FWIW, this:

commit cf828f1a72ec1eb0c1e819307137879447c909b7
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Oct 25 21:46:01 2009 -0400

    libext2fs: Byte-swap 64-bit block group descriptors

    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

is blowing up all over on ppc, with glibc-detected memory problems like:

Running e2fsprogs test suite...

d_loaddump: debugfs load/dump test: *** glibc detected ***
../debugfs/debugfs: free(): invalid next size (fast): 0x000001001bb03130 ***
======= Backtrace: =========
/lib64/libc.so.6[0x803da3f744]
../debugfs/debugfs[0x100213e4]
../debugfs/debugfs[0x100037c8]
../debugfs/debugfs[0x100040b4]
/lib64/libc.so.6[0x803d9dbc78]
/lib64/libc.so.6(__libc_start_main-0x184e60)[0x803d9dbe70]
======= Memory map: ========
10000000-10040000 r-xp 00000000 fd:00 1443282
 /root/e2fsprogs/debugfs/debugfs
10040000-10050000 rw-p 00040000 fd:00 1443282
 /root/e2fsprogs/debugfs/debugfs
803d920000-803d950000 r-xp 00000000 fd:00 134600
 /lib64/ld-2.12.so
803d950000-803d960000 r--p 00020000 fd:00 134600
 /lib64/ld-2.12.so
803d960000-803d970000 rw-p 00030000 fd:00 134600
 /lib64/ld-2.12.so
803d990000-803db50000 r-xp 00000000 fd:00 134601
 /lib64/libc-2.12.so
803db50000-803db60000 r--p 001b0000 fd:00 134601
 /lib64/libc-2.12.so
803db60000-803db70000 rw-p 001c0000 fd:00 134601
 /lib64/libc-2.12.so
803db70000-803db80000 rw-p 00000000 00:00 0
803db80000-803db90000 r-xp 00000000 fd:00 134602
 /lib64/libdl-2.12.so
803db90000-803dba0000 r--p 00000000 fd:00 134602
 /lib64/libdl-2.12.so
803dba0000-803dbb0000 rw-p 00010000 fd:00 134602
 /lib64/libdl-2.12.so
803dbb0000-803dbd0000 r-xp 00000000 fd:00 134613
 /lib64/libpthread-2.12.so
803dbd0000-803dbe0000 r--p 00010000 fd:00 134613
 /lib64/libpthread-2.12.so
803dbe0000-803dbf0000 rw-p 00020000 fd:00 134613
 /lib64/libpthread-2.12.so
1001bb00000-1001bb30000 rw-p 00000000 00:00 0
 [heap]
fffab260000-fffab280000 r-xp 00000000 00:00 0
 [vdso]
ffffb920000-ffffba70000 rw-p 00000000 00:00 0
 [stack]
./d_loaddump/script: line 22:  2743 Aborted                 (core
dumped) $DEBUGFS -R "write $TEST_DATA test_data" -w $TMPFILE >> $OUT.new
2>&1
