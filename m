From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: e2fsprogs/ext4 version compatibility
Date: Thu, 24 Feb 2011 11:22:34 +0200
Message-ID: <AANLkTi=cgVAbEd+vmXeRRHD7wWdbt_Dyf=vYRLFH-45r@mail.gmail.com>
References: <10FC03A59E498D4A90A45E4A105AD3ED02DCB0363A@EXCH-MBX-2.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Hari Subramanian <hari@vmware.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54473 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009Ab1BXJWh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Feb 2011 04:22:37 -0500
Received: by qyg14 with SMTP id 14so300781qyg.19
        for <linux-ext4@vger.kernel.org>; Thu, 24 Feb 2011 01:22:36 -0800 (PST)
In-Reply-To: <10FC03A59E498D4A90A45E4A105AD3ED02DCB0363A@EXCH-MBX-2.vmware.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 23, 2011 at 11:09 PM, Hari Subramanian <hari@vmware.com> wr=
ote:
> Hi,
>
> I'm running a SLES11 SP1 GA based kernel (2.6.32.23) with ext4 filesy=
stem. The e2fsprogs package that's installed on the box is version 1.41=
=2E9 (22-Aug-2009). I was wondering if there was a version in compatibi=
lity between the filesystem implementation and the tools package, esp. =
since there have been 5 revisions of the package since 1.41.9
>

I am using the same kernel/e2fsprogs versions and they don't seem to
have any comparability issues
(none of the kernel/e2fsprogs versions should have comparability issues=
 AFAIK)

> The reason I'm asking the question is my machine recently rebooted af=
ter a crash but fsck failed with an error code of 4 and the following m=
essage:
>
> "Inodes that were part of a corrupted orphan linked list found"
> "UNEXPECTED INCONSISTENCY: RUN fsck MANUALLY"

This doesn't look like a kernel/e2fsprogs compatibility issue.
=46sck is telling you it found an inode, which looks like it should hav=
e
been on the orphan list,
but wasn't found on the list.

It could also be that you deleted an inode back in the 80's,
but I think the code is trying to rule that option out somehow
with the busted_fs_time:

                if (inode->i_dtime && !busted_fs_time &&
                    inode->i_dtime < ctx->fs->super->s_inodes_count) {
                        if (fix_problem(ctx, PR_1_LOW_DTIME, &pctx)) {
                                inode->i_dtime =3D inode->i_links_count=
 ?
                                        0 : ctx->now;
                                e2fsck_write_inode(ctx, ino, inode,
                                                   "pass1");
                        }
                }

In any case, saying yes to fix that problem seems to be mostly harmless=
=2E
later passes of fsck would figure out what to do with that inode, which
is why fsck requires you to run it manually, so you can answer importan=
t
questions like: delete inode XXX?

>
> There were no files being created or deleted at the time of the crash=
 although IOs were probably inflight. So, the inodes being a part of or=
phaned link list doesn't make sense to me. I don't claim deep knowledge=
 in filesystem internals either. Before I go suspecting a corrupted fil=
esystem, I wanted to make sure I was running the right version of fsck.

An inode is added to orphan list before every write that is about to
change the file size, so it does make sense to
have inodes on the orphan list after crash, but it doesn't explain why
the orphan list is corrupted.

Could it be that your system had skewed time before the crash? 1/1/1970=
?

>
> Thanks in advance for your help!
> ~ Hari
>
> P.S. I wasn't sure if this is the right forum to post this question b=
ut I couldn't find a e2fsprogs mailing list and linux-ext4 seemed like =
a good alternative. Sorry, if this is the wrong forum.
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
