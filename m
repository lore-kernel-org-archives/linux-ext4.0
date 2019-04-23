Return-Path: <SRS0=E3Xq=SZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B086C282E1
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Apr 2019 17:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC4DC21738
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Apr 2019 17:16:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y5GWoYoc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbfDWRQX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 23 Apr 2019 13:16:23 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:38040 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfDWRQX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Apr 2019 13:16:23 -0400
Received: by mail-yw1-f68.google.com with SMTP id i66so1873264ywe.5
        for <linux-ext4@vger.kernel.org>; Tue, 23 Apr 2019 10:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g3T77yqZJMe1qswiJgxzxS6pAsqLXpPMxdOnm+lBM4E=;
        b=Y5GWoYocQ4eb5zga5g5j9h5RECpENQqtMthIB5pedH+P/CPcipOYk4+SrQ8EAhoP1I
         c4c22LQvPk05ewHoupqa+wvt7dj35Nl/2GXgEnvKaOWrzuz8kUaZY1Y6EpUJhg3lL3hu
         1jZoEzLK6jXgDExOEqFJQcQ9uQW8Ge4dWFHpw2x/fMy/QSdgvcn8NDsuwN43xf5qXKPe
         7HO8yfcGrt8R9rJ4hmjmf4lahd7N7+CoD42CGVfwz+MVPTkFFb5Hn7a/5JeE+Z2uuxmd
         NelYHDdN2PGKJv7DyPbTGqNBqIFt/pei3TOEGY1CBeSBH8cAuQgGWPAyv1y/eTplVbVh
         Y+Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g3T77yqZJMe1qswiJgxzxS6pAsqLXpPMxdOnm+lBM4E=;
        b=afEV0eQ0n89RASCbkjSYWAyzOScMpJkVa3dn/erXop5EoXCsXDFbrOVHUdr8daxuZD
         NfsATUuOxOiAAx+vePcGq4Q4glavtkTmSFQYlvXJCjhEqcL2mc8k+aiy8EgV30BPVmZn
         Fx1GVzP//5KEvjf+3fLF3ge1iR0aL+Daf3JfXQhSGvc5rXyEh8+Hwi33nsA6cM4Y+Zcz
         Rc8EAdIT0+oznLgK6XK+QZrieuJH18fQeu+kbSqWjcBZvSg4aLBikN9Q30pr6O638NGi
         LtgAq33TMaMLkJrS6eJu0LWYtFaet5JfFQ97OJhZ3dm+4M5pid8AGxgXiceBev3dNQ/q
         JTfQ==
X-Gm-Message-State: APjAAAXYavIbMcpjhsyBg7xfS3tJ6/3bt+REmYv6MmwErWW7EFxIJ48w
        tdBK5ihpjEkbx/qJ8MYVERYp34lvYAejw6x+rQtfng==
X-Google-Smtp-Source: APXvYqxx3W4CgkV6x2r0WAmwpahB8VurbOMz3+wQ0ZYRON8CtzQn5jiRcQGe7KgKK9gYvc+quqqsQfNkFASNLHpDleg=
X-Received: by 2002:a81:30d8:: with SMTP id w207mr12068553yww.362.1556039781035;
 Tue, 23 Apr 2019 10:16:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190423163021.GA185682@google.com> <20190423170127.GA26119@magnolia>
In-Reply-To: <20190423170127.GA26119@magnolia>
From:   Guenter Roeck <groeck@google.com>
Date:   Tue, 23 Apr 2019 10:16:09 -0700
Message-ID: <CABXOdTdr4YE0owk-w9i77j62AgQFWZ7wgabEnb-h2mfC4Bn+FQ@mail.gmail.com>
Subject: Re: 5a9d929d6e13 ("iomap: report collisions between directio and
 buffered writes to userspace")
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Zubin Mithra <zsm@chromium.org>,
        "# v4 . 10+" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>, bo.li.liu@oracle.com,
        viro@zeniv.linux.org.uk, linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 23, 2019 at 10:01 AM Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>
> On Tue, Apr 23, 2019 at 09:30:22AM -0700, Zubin Mithra wrote:
> > Hello,
> >
> > Syzkaller has triggered a kernel WARNING with the following stacktrace when fuzzing a 4.14 kernel.
> >
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:17 [inline]
> >  dump_stack+0xb7/0x107 lib/dump_stack.c:53
> >  panic+0x1c9/0x3ae kernel/panic.c:181
> >  __warn+0x160/0x1a8 kernel/panic.c:543
> >  report_bug+0x123/0x18b lib/bug.c:186
> >  fixup_bug+0x3e/0x77 arch/x86/kernel/traps.c:177
> >  do_error_trap+0xdd/0x1e6 arch/x86/kernel/traps.c:295
> >  invalid_op+0x1b/0x40 arch/x86/entry/entry_64.S:944
> >  do_blockdev_direct_IO+0x1b08/0x1b95 fs/direct-io.c:1373
> >  ext4_direct_IO_write fs/ext4/inode.c:3696 [inline]
> >  ext4_direct_IO+0x8de/0xdad fs/ext4/inode.c:3826
> >  generic_file_direct_write+0x223/0x36b mm/filemap.c:2927
> >  __generic_file_write_iter+0x12f/0x2f8 mm/filemap.c:3106
> >  ext4_file_write_iter+0x97d/0xade fs/ext4/file.c:264
> >  call_write_iter include/linux/fs.h:1782 [inline]
> >  do_iter_readv_writev+0x1e4/0x27c fs/read_write.c:678
> >  do_iter_write+0x136/0x18f fs/read_write.c:957
> >  vfs_iter_write+0x81/0x98 fs/read_write.c:970
> >  iter_file_splice_write+0x4dc/0x7a6 fs/splice.c:749
> >  do_splice_from fs/splice.c:851 [inline]
> >  direct_splice_actor+0x11e/0x129 fs/splice.c:1018
> >  splice_direct_to_actor+0x342/0x5b0 fs/splice.c:973
> >  do_splice_direct+0x180/0x1ff fs/splice.c:1061
> >  do_sendfile+0x3e6/0x61c fs/read_write.c:1438
> >  SYSC_sendfile64 fs/read_write.c:1499 [inline]
> >  SyS_sendfile64+0xe9/0x128 fs/read_write.c:1485
> >  do_syscall_64+0x203/0x241 arch/x86/entry/common.c:290
> >  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> >
> > Could the following patch be applied in order to v4.14.y(The patch is present in v4.19.y)?
> > 5a9d929d6e13 ("iomap: report collisions between directio and buffered writes to userspace")
>
> That patch only teaches the kernel to emit warnings in dmesg when
> programs mix directio and buffered writes.  It doesn't fix any buggy
> directio usage.  Someone on the ext4 list [cc'd] might know more about
> this.
>

Not sure I understand. Is your argument that systems configured to
panic on warnings should indeed panic if the situation is encountered,
ie that the backtrace and potential panic is warranted ? Isn't this a
potential DOS problem if the situation can be triggered from userspace
on such systems ?

Thanks,
Guenter

> --D
>
> >
> > Tests run:
> > - Chrome OS tryjobs
> > - Syzkaller reproducer
> >
> >
> > Thanks,
> > - Zubin
