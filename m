Return-Path: <SRS0=GMxu=SN=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF62AC10F13
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 09:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D8A4217D4
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 09:58:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=movia-biz.20150623.gappssmtp.com header.i=@movia-biz.20150623.gappssmtp.com header.b="aGfPgY+k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfDKJ6G (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 11 Apr 2019 05:58:06 -0400
Received: from mail-it1-f181.google.com ([209.85.166.181]:55974 "EHLO
        mail-it1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfDKJ6G (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Apr 2019 05:58:06 -0400
Received: by mail-it1-f181.google.com with SMTP id y134so8569109itc.5
        for <linux-ext4@vger.kernel.org>; Thu, 11 Apr 2019 02:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=movia-biz.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=yOlfYUgHQ0yw3We09JDqM+Oihb93jZwKiq9FwM6pvUM=;
        b=aGfPgY+kCrOA/GbuTP5bozEIHLCFcQLsdrFUSivDsgggh0qNRqHwWqCjRI+X7Z4c7Q
         X9eopb4RdKUuJLs6F/sceWs4R/H94kB2RV7c5jV3JHLNgkWQYiak7ZeiSOmcP7UBQOMl
         EZFiXA6/loxIc9QKgVzp0q1CBjvZjcrq7DGCSSoSVLBEWPYj+K75H2WZvoG8tFeZZQLi
         aU7VwvfYfYuECo9vXbi5DfeUgKb6MMhWhBl0uD+lAUx0EJcwG4HVpQrY27egSQXHOG9w
         TxPg4k/CDNUm+U39w2N+2tQp3rL/fWqKHNV13eiJbupUjzuHFxtUPJ1bHxvephNe0RBP
         185A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=yOlfYUgHQ0yw3We09JDqM+Oihb93jZwKiq9FwM6pvUM=;
        b=rYgYx9KxlE/pz8e7WS3NGtalkV/3Sw8e1QbjyXj44gxWejNK+IE10pVPP/JrsLf/lf
         XafIwRARm2HpAw4PGKYPyVUnuT93D7oMBqrWcyRxHC8BwZ9VyYWhZ+7kdy/m83xOD7NR
         ApK6JKV8GIp0C+fVm8RgMgQZQIZJmKfz6cfXiB95C9TLrQu4Xan2aTusjY1QxcXXL8IS
         gUoSBjqMfEVFpDrzTnI9nLakOKcZ9pFBtX2BDq7KC1wuaLkrRgMo5OjJqw33NTPGknk/
         wrBz2KCyB3Vie39WmQrC70l26izYndr5rlCXxyeEpnL+uCURY7hciLBDr8Qe4o0XAs0L
         JXuA==
X-Gm-Message-State: APjAAAXdKUfgfbI6DBP1v+vYdxPav71I0SYUxNAZEsZxlH4uReU6SZbg
        KEKtAlVnWAcolkfnZj6qG+Pm9Ue5WByCMet5dVqlZQ1gn5g=
X-Google-Smtp-Source: APXvYqymZ05QMU0amdpFk5jBrPQnIVgZKCjKRlO4oGhr0foodq4tF+t1p2xFjdy8NblXs92bPtypM5aXOu3e6MonKQQ=
X-Received: by 2002:a24:1c11:: with SMTP id c17mr7151296itc.3.1554976685337;
 Thu, 11 Apr 2019 02:58:05 -0700 (PDT)
MIME-Version: 1.0
References: <CABxFBzGv9vJsw_f9FJmJvQ2GZaz1NnVkK9a6y6CT58bv3mZj2A@mail.gmail.com>
 <CABxFBzE-kOtf3hO26RH1S7CmM+AeB6qso8OQBDOysH1L9rmjnQ@mail.gmail.com>
 <093e8c89-79f7-e207-6cb5-d66dadab60c2@thelounge.net> <CABxFBzGK9qSny7PdFOxpjK2evr8xZ5xCECRkcKCou1R-uyVu+g@mail.gmail.com>
In-Reply-To: <CABxFBzGK9qSny7PdFOxpjK2evr8xZ5xCECRkcKCou1R-uyVu+g@mail.gmail.com>
From:   Andrea Lo Pumo <alopumo@movia.biz>
Date:   Thu, 11 Apr 2019 11:57:54 +0200
Message-ID: <CABxFBzE6u4o-0DDHEpKQftgMB0g5AZcjER+PdNBb5M3U7BHaWQ@mail.gmail.com>
Subject: Re: Run mkfs.ext4 on an already existing ext4 filesystem. Seeking
 professional help or programming hints for the recovery.
Cc:     linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

To clarify, the commands run on the machine were:

   cryptsetup luksOpen /dev/sda1 secure_storage
   mkfs.ext4 /dev/mapper/secure_storage  <--- this messed everything

Through the emails I used "/dev/sda1" to make the story simpler, as I
believe that /dev/mapper/secure_storage is the same as a normal
partition.

Thank you again.

Il giorno gio 11 apr 2019 alle ore 11:45 Andrea Lo Pumo
<alopumo@movia.biz> ha scritto:
>
> Il giorno gio 11 apr 2019 alle ore 11:42 Reindl Harald
> <h.reindl@thelounge.net> ha scritto:
> >
> > Am 11.04.19 um 11:37 schrieb Andrea Lo Pumo:
> > > On /dev/sda1(*) there was an ext4 file system with a lot of large
> > > files. Now, by mistake, mkfs.ext4 has been run on /dev/sda1. The
> > > result is that now /dev/sda1 is "empty": mounting it shows no files.
> > >
> > > Note *: actually, it is /dev/mapper/secure_storage, an encrypted
> > > volume opened with LUKS: cryptsetup luksOpen /dev/sda1 secure_storage
> >
> > no
> >
> > you said you had a LUKS volume on /dev/sda1 which means by directly
> > create a fs on /dev/sda1 you have overwritten parts of the encryption
> > layer *and* at the same time the filesystem *on top* of it
>
> Sorry, I explained it badly. The commands were:
>
>   cryptsetup luksOpen /dev/sda1 secure_storage
>   mkfs.ext4 /dev/mapper/secure_storage
