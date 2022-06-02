Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89AC1C433EF
	for <linux-ext4@archiver.kernel.org>; Thu,  2 Jun 2022 17:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237687AbiFBRrU (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 2 Jun 2022 13:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237692AbiFBRrK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jun 2022 13:47:10 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [46.235.227.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D078DF90
        for <linux-ext4@vger.kernel.org>; Thu,  2 Jun 2022 10:47:08 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 0A4E71F448FB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1654192027;
        bh=jjzgjBu4o0gFqYsRSsZNho2KmjMT0qTwI0gwRlJQGY8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=oR75TZamq4WJni7EaJyHeb/PKfXed+nPEsucr8Nra8oYXTKnFkP0xprOERTQUoRwd
         hjm8+wENx5PJiiDpjiDcLXNJh+0b9a7PFwqYsdKkMPdUnJPbGcY9OhZ8uE1grL8tQw
         QiddwlhVp5AJNt9tqOA4q4XOAbY2FUKixvJl06F7mbyr1N2h8fXl1bu+MuEpLIdj+K
         4WZD48hMxjxkp4sPZDlRkwooOqP+8dLgUqMnYa2AgA3k2aX31F4/ni830tPw52+aEJ
         goOhhk5f/5Xk3xv2pHpiCnXE8Vs3aAjDuQYfmwjHipqsM0bkirEobT5KZ4XZJFyQ+2
         qMQ9lm2Tx4Qig==
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     "Stephen E. Baker" <baker.stephen.e@gmail.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: simplify ext4_sb_read_encoding regression
Organization: Collabora
References: <CAFDdnB38yRcZ+mQButh9UwGoh928xsZCgmjQ7r3HPEpEwdrZbg@mail.gmail.com>
        <87sfor85j1.fsf@collabora.com>
        <CAFDdnB3U67YJ7pivdHQaMB-CkdmvvTbcpxp1FXxBmFyAgJPknw@mail.gmail.com>
Date:   Thu, 02 Jun 2022 13:47:03 -0400
In-Reply-To: <CAFDdnB3U67YJ7pivdHQaMB-CkdmvvTbcpxp1FXxBmFyAgJPknw@mail.gmail.com>
        (Stephen E. Baker's message of "Mon, 30 May 2022 18:27:29 -0400")
Message-ID: <874k13t0tk.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

"Stephen E. Baker" <baker.stephen.e@gmail.com> writes:

> On Mon, May 30, 2022 at 10:21 AM Gabriel Krisman Bertazi
> <krisman@collabora.com> wrote:
>>
>> "Stephen E. Baker" <baker.stephen.e@gmail.com> writes:
>>
>> > Hello,
>> >
>> > I have a Samsung Chromebook Plus (rk3399-gru-kevin) which boots linux
>> > off an external ssd plugged into USB. The root filesystem is ext4 with
>> > unicode support, case folding is enabled only on some directories in
>> > my home directory.
>> >
>> > Since 5.17 the system has been unbootable. I ran a git bisect and it
>> > pointed to aa8bf298a96acaaaa3af07d09cf7ffeb9798e48a ext4: simplify
>> > ext4_sb_read_encoding
>>
>> Hi Stephen,
>>
>> This series moved the UTF-8 data tables to a kernel module; before it,
>> the module had to be built-in.
>>
>> Since you have your rootfs as a case-insensitive filesystem, either the
>> utf8data module needs to be available in the initramfs or unicode
>> needs to be built-in.  Are you building your own kernel?
>>
>> Can you confirm that utf8data.ko exists in your initramfs, and
>> regenerate it if missing?  Alternatively, make sure that you have
>> CONFIG_UNICODE=y in your kernel configuration file.
>>
> Thanks Gabriel, I've verified that CONFIG_UNICODE=y, as well as
> CONFIG_UNICODE_UTF8_DATA which exists in this patch for that
> purpose, though it was removed earlier.

Thanks for checking.  Indeed, UNICODE_UTF8_DATA was just transitional,
and went away right before being part of a release.  CONFIG_UNICODE=y
should have adressed it, if it was a problem with module not being
available early enough.

>
>> If that doesn't work, can you provide the kernel log?  If you can't
>> collect the console output, a photo of the screen displaying the error
>> will suffice.
>>
> I don't have any output to provide unfortunately. It fails before the
> backlight turns on, and nothing is written to disk. I seem to remember
> that someone else at Collabora had figured out a way to get a serial
> console on this device - perhaps Tomeu. I'm not equipped for that
> personally, particularly if it involves soldering.

I'm following the discussion with Ted on the other subthread, but I
don't have anything to add at the moment other than what is already
said.

Nothing stands out on that commit specifically and I couldn't reproduce
it in a vm.  I've reached out to Tomeu to get my hands on that exact
chromebook, to try to reproduce it there.  I will report back with my
findings.

-- 
Gabriel Krisman Bertazi
