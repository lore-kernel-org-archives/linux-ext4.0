From: Andreas Dilger <adilger@sun.com>
Subject: Re: Error Propagation bugs in ext4
Date: Sat, 22 Nov 2008 11:39:19 -0600
Message-ID: <20081122173919.GN3186@webber.adilger.int>
References: <adb1f7050810311819s3ea0b8f1mbb4239b108f34c4e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com, cmm@us.ibm.com,
	Ben Liblit <liblit@cs.wisc.edu>
To: Cindy Rubio =?utf-8?Q?Gonz=EF=BF=BDlez?= <crubio@cs.wisc.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:55720 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760031AbYKVRjY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Nov 2008 12:39:24 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAMHdO2J025216
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 09:39:24 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAQ00301WYU3C00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 22 Nov 2008 09:39:24 -0800 (PST)
In-reply-to: <adb1f7050810311819s3ea0b8f1mbb4239b108f34c4e@mail.gmail.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Oct 31, 2008  20:19 -0500, Cindy Rubio Gonz=EF=BF=BDlez wrote:
> I am a graduate student at the University of Wisconsin-Madison. My
> advisor (Prof. Ben Liblit) and I have been working on performing
> static analysis to find error propagation bugs in Linux file system
> implementations. ext4 is one of our case studies. We consider three
> general scenarios in which unchecked error are commonly lost: the
> variable holding the unchecked error value (1) is overwritten with a
> new value, (2) goes out of scope, or (3) is returned by a function bu=
t
> not saved by the caller. Our tool produces detailed witness traces
> that illustrate each bug reported.

I apologize for not getting back to you on this sooner, I've been very
busy and barely able to keep up on my own work for the past few weeks.

> Slice:
> fs/jbd2/transaction.c:105:"ret" receives an error from "TENTATIVE_ENO=
MEM"
> fs/jbd2/transaction.c:241: an unchecked error may be returned
> fs/jbd2/transaction.c:427:"ret" receives an error from function
> "start_this_handle"
> fs/jbd2/transaction.c:428: an unchecked error may be returned
> fs/ext4/ext4_jbd2.h:188:"cabs2cil_" receives an error from function
> "jbd2_journal_restart"
> fs/ext4/ext4_jbd2.h:188: an unchecked error may be returned
> fs/ext4/extents.c:104:"cabs2cil_" receives an error from function
> "ext4_journal_restart"
> fs/ext4/extents.c:104: an unchecked error may be returned
> fs/ext4/extents.c:1933:"err" receives an error from function
> "ext4_ext_journal_restart"
> fs/ext4/extents.c:1980: an unchecked error may be returned

In this particular example, it appears that there is a logic error
in the simulator.  This is the fragment of code that is in question:

2037     while (i >=3D 0 && err =3D=3D 0) {
2038             if (i =3D=3D depth) {
2039                     /* this is leaf block */
2040                     err =3D ext4_ext_rm_leaf(handle, inode, path, =
start);
2041                     /* root level has p_bh =3D=3D NULL, brelse() e=
ats this */
2042                     brelse(path[i].p_bh);
2043                     path[i].p_bh =3D NULL;
2044                     i--;
2045                     continue;
2046             }

> fs/ext4/extents.c:2040:"err" receives an error from "ext4_ext_rm_leaf=
"
2040                     err =3D ext4_ext_rm_leaf(handle, inode, path, =
start);
> fs/ext4/extents.c:2042:"err" may have an unchecked error
2042                     brelse(path[i].p_bh);
> include/linux/buffer_head.h:270:"err" may have an unchecked error
2043                     path[i].p_bh =3D NULL;
> fs/ext4/extents.c:2043:"err" may have an unchecked error
2043                     path[i].p_bh =3D NULL;
> fs/ext4/extents.c:2044:"err" may have an unchecked error
2044                     i--;
> fs/ext4/extents.c:2045:"err" may have an unchecked error
2045                     continue;
> fs/ext4/extents.c:2037:"err" may have an unchecked error
2037     while (i >=3D 0 && err =3D=3D 0) {
> fs/ext4/extents.c:2037:"err" may have an unchecked error
> fs/ext4/extents.c:2037:"err" may have an unchecked error
> fs/ext4/extents.c:2038:"err" may have an unchecked error
:
:
> fs/ext4/extents.c:2075:"err" may have an unchecked error
2075                         bh =3D sb_bread(sb, idx_pblock(path[i].p_i=
dx));
> fs/ext4/extents.c:2076:"err" may have an unchecked error
2076                         if (!bh) {
> fs/ext4/extents.c:2078: overwriting potential non-tentative unchecked
> error in "err"
2078                                 err =3D -EIO;
> =3D=3D=3D=3D

It is clear that this loop should terminate because "err =3D=3D 0" is n=
ow
false.  Not only did the simulator fail to detect that the error in
"err" was checked at this point, the simulator execution flow incorrect=
ly
shows the loop continuing until line 2078 where "err" is ostensibly
overwritten, but that is not what would actually happen.


I haven't looked at the other failure cases, because I suspect there
may be some similar false positives and I'd rather that the software
detect them than me.

That said, I'm a HUGE fan of static code analysis, and I'd be happy if
you could re-run your analysis and forward the results to the list agai=
n.
I think this is an excellent way of detecting bugs that happen rarely
enough that there are no good reproduction cases, but likely hit users
on occasion and are otherwise impossible to diagnose.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
