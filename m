Return-Path: <SRS0=k8Ev=N4=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-it1-f193.google.com ([209.85.166.193]:53878 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbeKQRpK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Nov 2018 12:45:10 -0500
Received: by mail-it1-f193.google.com with SMTP id r12-v6so1248621ita.3
        for <linux-ext4@vger.kernel.org>; Fri, 16 Nov 2018 23:29:24 -0800 (PST)
MIME-Version: 1.0
References: <20181116083737.10596-1-devel@etsukata.com> <20181116154424.da6uz56vatmvz7bo@two.firstfloor.org>
In-Reply-To: <20181116154424.da6uz56vatmvz7bo@two.firstfloor.org>
From: Eiichi Tsukata <devel@etsukata.com>
Date: Sat, 17 Nov 2018 16:29:12 +0900
Message-ID: <CANhTXPT81K5xbGeXbcMZ8YL1Td7JDqD+CQbnowK_-67acikyqQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] fs: fix race between llseek SEEK_END and write
To: andi@firstfloor.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> >
> > Q2. If it is a bug, how should we fix it?
> >
> > Currently I'm planning to re-introduce generic_file_llseek_unlocked()
> > and inode lock in generic_file_llseek() for SEEK_END. Then replace
> > generic_file_llseek() with generic_file_llseek_unlocked() if it called
> > with inode lock in individual file systems. Please let me know if the
> > way is not appropreate or any other better way to fix it.
>
> Sounds reasonable.
>
> -Andi

Thanks for comments. I'll make a patch.

Eiichi
