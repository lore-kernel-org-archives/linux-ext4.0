From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] mk2fs lazy_journal_init option
Date: Tue, 16 Feb 2010 15:15:19 -0700
Message-ID: <7095A240-FB57-4C33-8EE8-33D88B500319@sun.com>
References: <13A447AA-31C7-4E02-8752-DFF75EA31C2E@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Shuichi Ihara <ihara@sun.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:52959 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933440Ab0BPWP0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Feb 2010 17:15:26 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o1GMFLw6016174
	for <linux-ext4@vger.kernel.org>; Tue, 16 Feb 2010 14:15:23 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KXY00600GC26V00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 16 Feb 2010 14:15:21 -0800 (PST)
In-reply-to: <13A447AA-31C7-4E02-8752-DFF75EA31C2E@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-02-10, at 04:44, Andreas Dilger wrote:
> Attached is a patch to skip zeroing of the journal if the
> "-E lazy_journal_init" option is given to mke2fs (named to
> complement the "-E lazy_itable_init" option).  This can
> speed up format time significantly for large journal devices.
> There's only a short-term risk of problems with uninitialized
> journal, until the journal has been overwritten once.
>
> Patch has been lightly tested, showing mke2fs times steady
> at 14s for a 40GB filesystem, regardless of journal size,
> while previously it took up to 45s for an internal 2GB journal.

While testing this patch more thoroughly, we uncovered a bug
in the mke2fs/libext2fs code.  It seems that when running:

mke2fs -J size=X -O extents /dev/XXX

for any size > 512 the journal creation time is growing
exponentially:

no journal-> 12s
size=128 ->  14s
size=256 ->  16s
size=512 ->  21s
size=768 -> 143s
size=1024-> 298s
size=1280-> 663s

We wanted originally to use size=4000, but this took so
long we thought it was hung, and started investigating.

This happens even without the "-E lazy_itable_init" option.
Running ltrace on mke2fs shows lots of zero writes (to be
expected for journal zeroing) followed by a single read
(completes quickly) and many thousands of memcpy() calls.
The mke2fs program is completely CPU bound (99.9% user).

Running with the "-E lazy_itable_init" the writes/reads go
away, and all that is left is an endless stream of memcpy().

It seems to loop in ext2fs_block_iterate2->mkjournal_proc()
forever:

426            for (blockcnt = extent.e_lblk, j = 0;
427                 j < extent.e_len;
428                 blk++, blockcnt++, j++) {
429                    new_blk = blk;
430                    r = (*ctx.func)(fs, &new_blk, blockcnt,
431                                    0, 0, priv_data);


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

