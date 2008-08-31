From: Andreas Dilger <adilger@sun.com>
Subject: Re: Do we need dump for ext4?
Date: Sat, 30 Aug 2008 20:43:00 -0600
Message-ID: <20080831024300.GB3392@webber.adilger.int>
References: <48B6BD02.3080307@redhat.com> <48B7ED40.6020508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Ric Wheeler <rwheeler@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:61637 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbYHaCnN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Aug 2008 22:43:13 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7V2h2iF028500
	for <linux-ext4@vger.kernel.org>; Sat, 30 Aug 2008 19:43:12 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K6G00F0120YD800@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 30 Aug 2008 19:43:02 -0700 (PDT)
In-reply-to: <48B7ED40.6020508@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 29, 2008  07:36 -0500, Eric Sandeen wrote:
> at Ric & hch's  request here is tar on the other fs's as well, re-sorted
>  by level 0 dump time.  I put acp into the mix as well.
> 
> Oh, and this time I remembered to set the elevator to something sane
> (noop) for this storage, oops (was cfq last time)
> 
> Also, this time the dup/tar/acp was written to /dev/null rather than
> another filesystem.  Interesting how routing to /dev/null alone changed
> the ranking quite a bit.

Note that tar has a (questionable) optimization when writing to /dev/null.
It will NOT open the file or read the data, and just do the filename
traversal to generate the file list and total file size.  It does this by
comparing the output file to "/dev/null":


$ strace tar cvf /dev/null /t# mp/scheduler.pdf 
:
[opening libs and stuff]
:
creat("/dev/null", 0666)                = 3
fstat(3, {st_mode=S_IFCHR|0666, st_rdev=makedev(1, 3), ...}) = 0
write(1, "/tmp/scheduler.pdf\n", 19/tmp/scheduler.pdf
)    = 19
lstat("/tmp/scheduler.pdf", {st_mode=S_IFREG|0664, st_size=150262, ...}) = 0
close(3)                                = 0
close(1)                                = 0
munmap(0x7f2c00dd7000, 4096)            = 0
close(2)                                = 0
exit_group(0)                           = ?



A way to get around this is to hard link to /dev/null and use that as output:

# cp -a /dev/null /tmp/foo
$ ls -l /tmp/foo
0 crw-rw-rw- 1 root root 1, 3 2008-08-18 18:15 /tmp/foo
$ strace tar cvf /dev/null /t# mp/scheduler.pdf 
:
[opening libs and stuff]
:
creat("/tmp/foo", 0666)                 = 3
fstat(3, {st_mode=S_IFCHR|0666, st_rdev=makedev(1, 3), ...}) = 0
stat("/dev/null", {st_mode=S_IFCHR|0666, st_rdev=makedev(1, 3), ...}) = 0
lstat("/tmp/scheduler.pdf", {st_mode=S_IFREG|0664, st_size=150262, ...}) = 0
open("/tmp/scheduler.pdf", O_RDONLY)    = 4
write(1, "/tmp/scheduler.pdf\n", 19/tmp/scheduler.pdf) = 19
read(4, "%PDF-1.4\n%\303\244\303\274\303\266\303\237\n2 0 obj\n<</Le"..., 9728) = 9728
write(3, "tmp/scheduler.pdf\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 10240) = 10240
read(4, "\5\351\204\216\220N\224\304\344\331\355\366\264\216\311n\345\365\224\370\352.\205\354\341\0237\306\31>\201"..., 10240) = 10240
:
[repeats]
:
write(3, "\253\2708\264\262\275\36\335\323\212\262\33\244\301\226\246\256d^\214n\246\220BW\363\306\25b%_L"..., 10240) = 10240
read(4, "i\264\364\243\264\220\327+u\3B\1\21\210\376\23\2035@D2\316t\356\271\v\37\210S\307]["..., 7414) = 7414
fstat(4, {st_mode=S_IFREG|0664, st_size=150262, ...}) = 0
close(4)                                = 0
write(3, "i\264\364\243\264\220\327+u\3B\1\21\210\376\23\2035@D2\316t\356\271\v\37\210S\307]["..., 10240) = 10240
close(3)                                = 0
close(1)                                = 0
munmap(0x7fb194cea000, 4096)            = 0
close(2)                                = 0
exit_group(0)                           = ?



Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

