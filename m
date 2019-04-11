Return-Path: <SRS0=GMxu=SN=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE617C10F13
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 09:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A389E20693
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 09:38:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=movia-biz.20150623.gappssmtp.com header.i=@movia-biz.20150623.gappssmtp.com header.b="a7WfWHC7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbfDKJiH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 11 Apr 2019 05:38:07 -0400
Received: from mail-it1-f180.google.com ([209.85.166.180]:37475 "EHLO
        mail-it1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbfDKJiH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Apr 2019 05:38:07 -0400
Received: by mail-it1-f180.google.com with SMTP id u65so8385822itc.2
        for <linux-ext4@vger.kernel.org>; Thu, 11 Apr 2019 02:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=movia-biz.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=BJESBRaRa3r2QX0w58U1ClaCO1mGP5ffrbKjBY8GnmQ=;
        b=a7WfWHC7W3xLIepGYynSrOu+g+kqPoj7wgRV9wt/Z4stlHAP5c2N0QVtrGHT8+7A5p
         jLJHu/9T5oWcwSgyVtyUk0G78eGPFYPqsTbmcrm6IirSpQWurwjLeOpcnaa4ldFZlmmw
         /fTfXB57OjPLBeDgpPttt5o0Nej5coRCTX3mIuCLrIX2wSUw6FHtN4GbEg7U76Jl0OjV
         bRD9RKIvv/0m6xdyT9uZJR6Pz52ws2asgstv7zBuFXsWbrYUIb5ezCkKYkkY/uGZOjCL
         3w8Y7+ZEu7WMhrPeyuluBBo6+6YnJEMJKALZeTI1atbCJx4WntY9DRHFdyW9aTe++9wp
         dzdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=BJESBRaRa3r2QX0w58U1ClaCO1mGP5ffrbKjBY8GnmQ=;
        b=BMCn9ffW0KjyFji/Kkt93f21nsQRLqNvlYaKnP8JEw5whH3tNmaFVvvdJVQFzffgAy
         S+sdEl516mlfC+AuHjLaLCyydIvrLCtfVHPCFJk6fo3xQKjc8qCrS4Q9sgElXnkLqNLK
         5zyLAfdsQ2BL6N42U+l3l0yKY+wqXutwNQA/tMnYoNEYHN0YFCMTNV6h2gGtSfkcFqZc
         Co2IfHKs8+5TFyaTPVIZfqRJYn5PkoY9P++gYNh0K0Zw88Q5kXkySPTTRyCr/APXlGDy
         W0W67PZT8mWLg3gBg698V+M9OE8gZiVCdhGOQSIYCCS8zk74Ygo08LLYelvmihtbraJw
         Cp0g==
X-Gm-Message-State: APjAAAVcxaw9jUzqf0LSf5AhRnclwzC9iRj+DZGQYD7Ab98dlzNjFO3Z
        gUeshtAbRs7GTOG+GObv/WASYmVBccKNpEXCCxrm4/C2
X-Google-Smtp-Source: APXvYqyTaE9WVlWERZ1Ol7Tc48FXmH1drf8MsiiixaVqbJLjY2EMcEbkWex4D9fSBB0o3GxvTa3uxqFa6jV7wW8jWqE=
X-Received: by 2002:a24:1c11:: with SMTP id c17mr7105976itc.3.1554975486221;
 Thu, 11 Apr 2019 02:38:06 -0700 (PDT)
MIME-Version: 1.0
References: <CABxFBzGv9vJsw_f9FJmJvQ2GZaz1NnVkK9a6y6CT58bv3mZj2A@mail.gmail.com>
In-Reply-To: <CABxFBzGv9vJsw_f9FJmJvQ2GZaz1NnVkK9a6y6CT58bv3mZj2A@mail.gmail.com>
From:   Andrea Lo Pumo <alopumo@movia.biz>
Date:   Thu, 11 Apr 2019 11:37:55 +0200
Message-ID: <CABxFBzE-kOtf3hO26RH1S7CmM+AeB6qso8OQBDOysH1L9rmjnQ@mail.gmail.com>
Subject: Run mkfs.ext4 on an already existing ext4 filesystem. Seeking
 professional help or programming hints for the recovery.
To:     linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Sorry for writing on this development mailing list, we are seeking an
expert in ext4, we are also willing to offer a professional contract
to solve this issue.

On /dev/sda1(*) there was an ext4 file system with a lot of large
files. Now, by mistake, mkfs.ext4 has been run on /dev/sda1. The
result is that now /dev/sda1 is "empty": mounting it shows no files.

Note *: actually, it is /dev/mapper/secure_storage, an encrypted
volume opened with LUKS: cryptsetup luksOpen /dev/sda1 secure_storage

Note 2: Ubuntu 18.04

This is my current understanding:

- Originally, /dev/sda1 was created with "mkfs.ext4 /dev/sda1"
- Now, the second "mkfs.ext4 /dev/sda1" has overwritten the
superblock, and all backups of the superblock (because it has created
the backups of the NEW superblock at the exact same locations of the
previous superblock backups).
- The inode map has been overwritten too.
- However, the data is still there in the disk, and also the related
inode structures. (Just the inode map is missing right?). So, if one
is able to locate these inode structures, the relative files could be
recovered. We know the name of important directories and files to be
recovered. Could this help?

We are willing to discuss a professional contract tailored to solve
this issue. So if you have the right knowledge, or you know someone,
please let us know.

I could also invest some programming efforts to solve this issue, by
hacking some available tools, if this could help and is not too
complex. In this regard, I have this question: given that I know the
name of some important directories and files to be recovered,
theoretically I could write a program that "greps" the name of the
file in /dev/sda1 and, around that point, I should locate the inode
structure, and with the inode recover the whole file? Any hint toward
this direction? I don't have experience with ext programming, but I am
willing to hack.

Final question: are there tools to handle this situation? testdisk and
ext4magic do not seem to give good results. Photorec is useless to
recover large .tar.gz and .ogg files, and more importantly the name of
the file, which we also need.

Thank you.

Best regards.
