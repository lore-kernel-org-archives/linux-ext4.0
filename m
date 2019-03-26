Return-Path: <SRS0=u157=R5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA315C43381
	for <linux-ext4@archiver.kernel.org>; Tue, 26 Mar 2019 10:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70BBD20830
	for <linux-ext4@archiver.kernel.org>; Tue, 26 Mar 2019 10:33:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nmmq/MsT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbfCZKdA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 26 Mar 2019 06:33:00 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:47046 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfCZKdA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Mar 2019 06:33:00 -0400
Received: by mail-io1-f68.google.com with SMTP id b9so10258278iot.13
        for <linux-ext4@vger.kernel.org>; Tue, 26 Mar 2019 03:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=wSIz+wNjEwZtwIy3B/dESp+TxXQ6/XjhWbXz+hGLnvc=;
        b=Nmmq/MsT06jV+15M8kU7R3ZwUJRdKVR2k/Ownjitt7LJblb7luzDxJpmsj/9AGQdRN
         xcma1ngehUAcHZAFObm7EjGBwP4j7OiRgah5hPVUwHeqRpUZycKxh477nyEm41NN7cgv
         0CiexOZEgtdkifYYot9dTYLT/+JWyqZEydwaqIJl+pm6s3Z2Mo6AbrR7Jp7YppJe0u2R
         53cbLxIIC0qYgnoUERnyfUkqwedfEkqVkSdIVuScjUI6VcT8ew3ib6WszGXONKKNcFOJ
         tfVbkmFqb1x/IIzX89C8sfufN21rlbbzW2bQ/TXyQv8D9xfBO7laxHZ/b+xxUU/7Lzp1
         Q4pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=wSIz+wNjEwZtwIy3B/dESp+TxXQ6/XjhWbXz+hGLnvc=;
        b=OJS76C6KzUZoaWh2doFodTTGxYGE0n/mRZUDuAQZ14x1s928qK02mChimEM/YYs0/P
         CFniwYYU51LhvWg9ZSx/BWd9ws5J4u7Zv/XoohdR3o3L9b7P3PmDNOKa7TRtlUkEydOM
         B0aCbqABHaUyUTF9AuOr6CnaQpk/4d8PJiyZJLRUd1l3UW8vEfxjs32E66e82M8qSEUI
         oJuhiDJH90JufLqtleZ0gEYtEK4rex0m7yu2YY6Ao9uM2GvUlUkMBTscY1YrvIGPP9I7
         1v4hRJ4yYuDqNIUro2lPrG3wwgv84v8U1El8MTJSAe5BCsnGHA0KXldVwO8na511wiep
         FzsA==
X-Gm-Message-State: APjAAAWnP1wKQbMXG7KdZJIYbFmuxU3/tkREB4IivdmITeHej+1dK+aT
        KWyI+p2niQuDUAO7Zqqu60k123lIbeQ+XABKpDhdPw==
X-Google-Smtp-Source: APXvYqzeJAifoY3bE3luERaySf4cd4sINgL8AJQkBzf0oCe8pI5IKRGodbb++0Xvl5b3tmHZU30T8m6tZfCdLQmdGsI=
X-Received: by 2002:a5d:9457:: with SMTP id x23mr3866669ior.271.1553596379219;
 Tue, 26 Mar 2019 03:32:59 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000cd1e2205785951c2@google.com> <00000000000088ea3e0584b5872d@google.com>
 <CACT4Y+bBPvfnU4T=4ojw67FP0GBC49L2kKV+HQYxsV-DwT2b7w@mail.gmail.com> <20190323135619.GB5675@mit.edu>
In-Reply-To: <20190323135619.GB5675@mit.edu>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 26 Mar 2019 11:32:48 +0100
Message-ID: <CACT4Y+Zt+fjBwJk-TcsccohBgxRNs37Hb4m6ZkZGy7u5P2+aaA@mail.gmail.com>
Subject: Re: possible deadlock in __generic_file_fsync
To:     "Theodore Ts'o" <tytso@mit.edu>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+5cd33f0e6abe2bb3e397@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Mar 23, 2019 at 2:56 PM Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Sat, Mar 23, 2019 at 08:16:36AM +0100, Dmitry Vyukov wrote:
> >
> > This is a lockdep-detected bug, but it is reproduced with very low
> > probability...
> >
> > I would expect that for lockdep it's only enough to trigger each path
> > involved in the deadlock once. Why is it so hard to reproduce then? Is
> > it something to improve in lockdep?
>
> It's a false positive report.  The problem is that without doing some
> fairly deep code analysis --- the kind that a human needs to do; this
> is not the kind of thing that ML and adjusting weights in a nueral net
> can deal with --- a computer can't determine what the completion
> handler will need to do.
>
> The root cause here is that we have N CPU's that are trying to do
> direct I/O's, and on the very first DIO write for a fd, we need to
> create a workqueue.  (Why do we do it here?  Because most fd's don't
> do DIO, so we don't want to waste resources unnecessarily.  Why don't
> we fix it by adding a mutex?  Because it would slow down *all* Direct
> I/O operations just to suppress a rare, false positive, lockdep
> report.)
>
> The reason why it's so hard for lockdep to reproduce is because it's
> extremely rare for this situation to get hit.  When it does get hit,
> several CPU's will try to create the workqueue, and all but one will
> lose the cmpxchg, and so all but one will need to destroy the
> workqueue which they had just created.  Since the wq in question has
> never been used, it's safe to call destroy_workqueue(wq) while holding
> the inode mutex --- but lockdep doesn't know this.  As I pointed out
> in [1] one way to fix this is to create a new API and use it instead:
>
>    I_solemnly_swear_this_workqueue_has_never_been_used_please_destroy()
>
> [1] https://lore.kernel.org/patchwork/patch/1003553/#1187773
>
> Unfortunately, this trades off fixing a very low probability lockdep
> false positive report that in practice only gets hit with Syzkaller,
> with making the code more fragile if the developer potentially uses
> the API incorrectly.
>
> As you can see from the date on the discussion, it's been over six
> months, and there still hasn't been a decision about the best way to
> fix this.  I think the real problem is that it's pretty low priority,
> since it's only something that Syzkaller notices.
>
> The reality is in a world without Syzkaller, maybe once a decade, it
> would get hit on a real-life workload, and so we'd have to close a bug
> report with "Won't Fix; Not reproducible", and add a note saying that
> it's a false positive lockdep report.  Syzkaller is adding stress to
> the system by demanding perfection from lockdep, and it isn't that,
> for better or for worse.  =E2=80=BE\_(=E3=83=84)_/=E2=80=BE The question =
is what is the best
> way to annotate this as a false positive, so we can suppress the
> report, either in Lockdep or in Syzkaller.

Hi Ted,

Thanks for the analysis.

So we can classify the reason for wrong bisection result as "too hard
to trigger bug".

Re lockdep perfection, do you see any better alternative then what is
happening now?
One alternative is obviously to stop testing kernel which would remove
all related stress from all involved parties and remove any
perfection/quality requirement from everything :)
But it does not look like a better path forward.

Re I_solemnly_swear_this_workqueue_has_never_been_used_please_destroy,
I wonder if it's possible to automatically note the fact that the
workqueue was used. It should not make the code more fragile and
should not use to incorrect uses of API. It can slightly move the
situation from "reporting false positives" to "not reporting true
positives", but all bugs should be detected eventually (we just need
any test where a single item was submitted to the queue). And in my
experience not reporting false positives is much more important then
reporting 100% of true positives.
Something along the lines of:

on submission of an item:
#ifdef LOCKDEP
  WRITE_ONCE(wq->was_used, 1);
#endif

in flush:
#ifdef LOCKDEP
  if (READ_ONCE(wq->was_used) {
    lock_map_acquire(&wq->lockdep_map);
    lock_map_release(&wq->lockdep_map);
  }
#endif
