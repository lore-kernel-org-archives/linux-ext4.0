Return-Path: <SRS0=oERZ=R2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9785EC10F05
	for <linux-ext4@archiver.kernel.org>; Sat, 23 Mar 2019 13:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71AB5218B0
	for <linux-ext4@archiver.kernel.org>; Sat, 23 Mar 2019 13:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfCWN4b (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 23 Mar 2019 09:56:31 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:57119 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726909AbfCWN4b (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Mar 2019 09:56:31 -0400
Received: from callcc.thunk.org ([70.42.157.31])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2NDuKKq028470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 23 Mar 2019 09:56:22 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 564F7421A01; Sat, 23 Mar 2019 09:56:19 -0400 (EDT)
Date:   Sat, 23 Mar 2019 09:56:19 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+5cd33f0e6abe2bb3e397@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: possible deadlock in __generic_file_fsync
Message-ID: <20190323135619.GB5675@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+5cd33f0e6abe2bb3e397@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <000000000000cd1e2205785951c2@google.com>
 <00000000000088ea3e0584b5872d@google.com>
 <CACT4Y+bBPvfnU4T=4ojw67FP0GBC49L2kKV+HQYxsV-DwT2b7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACT4Y+bBPvfnU4T=4ojw67FP0GBC49L2kKV+HQYxsV-DwT2b7w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Mar 23, 2019 at 08:16:36AM +0100, Dmitry Vyukov wrote:
> 
> This is a lockdep-detected bug, but it is reproduced with very low
> probability...
> 
> I would expect that for lockdep it's only enough to trigger each path
> involved in the deadlock once. Why is it so hard to reproduce then? Is
> it something to improve in lockdep?

It's a false positive report.  The problem is that without doing some
fairly deep code analysis --- the kind that a human needs to do; this
is not the kind of thing that ML and adjusting weights in a nueral net
can deal with --- a computer can't determine what the completion
handler will need to do.

The root cause here is that we have N CPU's that are trying to do
direct I/O's, and on the very first DIO write for a fd, we need to
create a workqueue.  (Why do we do it here?  Because most fd's don't
do DIO, so we don't want to waste resources unnecessarily.  Why don't
we fix it by adding a mutex?  Because it would slow down *all* Direct
I/O operations just to suppress a rare, false positive, lockdep
report.)

The reason why it's so hard for lockdep to reproduce is because it's
extremely rare for this situation to get hit.  When it does get hit,
several CPU's will try to create the workqueue, and all but one will
lose the cmpxchg, and so all but one will need to destroy the
workqueue which they had just created.  Since the wq in question has
never been used, it's safe to call destroy_workqueue(wq) while holding
the inode mutex --- but lockdep doesn't know this.  As I pointed out
in [1] one way to fix this is to create a new API and use it instead:

   I_solemnly_swear_this_workqueue_has_never_been_used_please_destroy()

[1] https://lore.kernel.org/patchwork/patch/1003553/#1187773

Unfortunately, this trades off fixing a very low probability lockdep
false positive report that in practice only gets hit with Syzkaller,
with making the code more fragile if the developer potentially uses
the API incorrectly.

As you can see from the date on the discussion, it's been over six
months, and there still hasn't been a decision about the best way to
fix this.  I think the real problem is that it's pretty low priority,
since it's only something that Syzkaller notices.

The reality is in a world without Syzkaller, maybe once a decade, it
would get hit on a real-life workload, and so we'd have to close a bug
report with "Won't Fix; Not reproducible", and add a note saying that
it's a false positive lockdep report.  Syzkaller is adding stress to
the system by demanding perfection from lockdep, and it isn't that,
for better or for worse.  ‾\_(ツ)_/‾ The question is what is the best
way to annotate this as a false positive, so we can suppress the
report, either in Lockdep or in Syzkaller.

Cheers,

					- Ted
