From: ChunYu Wang <chunwang@redhat.com>
Subject: Re: kernel BUG at fs/ext4/fsync.c:LINE!
Date: Fri, 15 Sep 2017 02:22:01 +0800
Message-ID: <CAOm2TWzK0VugZo5ZpWLj5c+f3M0mKPxecjs1oA1g86v1e3kGFA@mail.gmail.com>
References: <CACbyUSr1AEJ3E+wB7a1ftuxH4sSK=i5v1Z+KUJ0TMygUrtdPRQ@mail.gmail.com>
 <CAOm2TWy7OJ0MAAbQ+U4deNuMtL9nwRv5nauEpOj-Ry8=uPVoog@mail.gmail.com> <CE0032C8-A8FE-42C2-BFD8-06411B393FF3@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: GeneBlue <geneblue.mail@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:53771 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751316AbdINSWC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Sep 2017 14:22:02 -0400
Received: by mail-qt0-f173.google.com with SMTP id 47so163331qts.10
        for <linux-ext4@vger.kernel.org>; Thu, 14 Sep 2017 11:22:02 -0700 (PDT)
In-Reply-To: <CE0032C8-A8FE-42C2-BFD8-06411B393FF3@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 15, 2017 at 12:41 AM, Andreas Dilger <adilger@dilger.ca> wrote:
> I don't think a reproducer is needed.  It looks like the fsync callpath
> is happening from an IRQ context due to IO completion, and then re-entering
> the filesystem while a transaction is already started.  It looks like the
> original IO was submitted with AIO based on the functions on the IRQ stack,
> which is likely why nobody has hit it (AIO isn't very commonly used).
>
> That said, I don't follow the reasoning behind the convoluted series of AIO
> callbacks that has IO _completion_ calling vfs_fsync_range() and re-entering
> the filesystem to flush out more data?

Thanks for analyzing, and I do think the syzkaller reproducer(in fact,
log) may also answer your question and help positioning the precise
issue trigger in-depth. Moreover, for me, I am not professional enough
to analyze such a complex problem with call trace and code only :)

- ChunYu
