Return-Path: <SRS0=+0zc=QQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D48C282C4
	for <linux-ext4@archiver.kernel.org>; Sat,  9 Feb 2019 20:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEA7F218D2
	for <linux-ext4@archiver.kernel.org>; Sat,  9 Feb 2019 20:38:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ezM04L+m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfBIUi0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 9 Feb 2019 15:38:26 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39429 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbfBIUiZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Feb 2019 15:38:25 -0500
Received: by mail-lj1-f194.google.com with SMTP id v12-v6so1078527ljc.6
        for <linux-ext4@vger.kernel.org>; Sat, 09 Feb 2019 12:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uk8nve6rdlZ4htVQGYkbvBvkVLExmVNQUPyiiW5cWec=;
        b=ezM04L+mhna1EvBHk6Rlb+bOEKP/tlfV+cFhb0aUTcuLBr7TVmXC9erCZLPlFK4xnp
         7zrEUXBKZZuK+LFgD5d9nG9N4P96TnUrjPVJU1ZUuU69G76zJ6CSujFoCVaCToBpap/Q
         DhutwWNPudtt9+2xlZ3hqLy0w1sa3NUU4WDIY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uk8nve6rdlZ4htVQGYkbvBvkVLExmVNQUPyiiW5cWec=;
        b=a4emoxUHXE4hwlkTuRF+oqC5Mjp+sjBKiJ2YCzLbuWu18joiwoEEQd9WgGU+wIWuzP
         4wzT5XNycA+vsL267opyMAu5lJGhzCdb5xVSb33vE1r0wDCgJEWHw3lhduejvsqmN6+Z
         a8URiLStKyxcUeraYCpF5hOHJp1RnH5kAupjTqiswHuP2Nr0J3VWjx8L4dcyjzjJrOj5
         bBoHJJH7FyI4Onuj5U2lm3zasGEqhlPotRlx9NrCfjRVJ0qMSgMC5Vn/8/fk7AUSwF4d
         LUhL+0WZmp0wRleQ7aqZCjMEPjgnqZhesPm5G0+mBVzc2U4PHzZDYJxwFkIBilwVnUXO
         eKbg==
X-Gm-Message-State: AHQUAuZvAzhmAJcCz1rSAO/Gb/sw1qSMXnWK0RPC+2xZsKP+ObPu2tDl
        7n+z6Fno9gN5S856zpDPiV203kkkwz0=
X-Google-Smtp-Source: AHgI3IYAMFJAy/pvR3EjN9qD2cC0r7occBPnjNMdN9Kcvgd0x/mope70+VI7Yt5k/ok/ocsD8mP6/g==
X-Received: by 2002:a2e:9001:: with SMTP id h1-v6mr13077973ljg.28.1549744703105;
        Sat, 09 Feb 2019 12:38:23 -0800 (PST)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id g15sm1263721lfb.1.2019.02.09.12.38.21
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Feb 2019 12:38:22 -0800 (PST)
Received: by mail-lj1-f176.google.com with SMTP id v12-v6so1078484ljc.6
        for <linux-ext4@vger.kernel.org>; Sat, 09 Feb 2019 12:38:21 -0800 (PST)
X-Received: by 2002:a2e:9944:: with SMTP id r4-v6mr17226404ljj.185.1549744701268;
 Sat, 09 Feb 2019 12:38:21 -0800 (PST)
MIME-Version: 1.0
References: <20190207031101.GA7387@mit.edu>
In-Reply-To: <20190207031101.GA7387@mit.edu>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 9 Feb 2019 12:38:05 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh2j+Yy28H_QxEdsP=k9xcHxjCG1PqKAF2Uv=ckK8oPug@mail.gmail.com>
Message-ID: <CAHk-=wh2j+Yy28H_QxEdsP=k9xcHxjCG1PqKAF2Uv=ckK8oPug@mail.gmail.com>
Subject: Re: Proposal: Yet another possible fs-verity interface
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Feb 7, 2019 at 8:10 AM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> After doing a lot of thinking and conferring with the other fs-verity
> developers, our current thinking is to simply move the Merkle tree
> creation into the kernel.  The upside of doing this is it completely
> bypasses all of the complaints about how to transfer the Merkle tree
> from userspace to the kernel.

This sounds very sane to me.

In particular, may I suggest that  the interface be made idempotent,
so that you can do the merkle tree operation several times with the
same offset/length arguments, and if the merkle tree has already been
calculated, you just return the resulting root hash directly.

Why? That allows you to "validate" images on filesystems that don't
actually have any long-term storage model for the merkle tree. IOW,
you could do the merkle tree calculation (and verification) every time
at bootup, and on a filesystem that supports the long-term storage of
said merkle data, it's a very cheap operation, but on a filesystem
that doesn't, it would still be *possible* to just calculate the hash
and mark it "finalized" for that boot (or that mount). IOW, it would
work for something like ramfs (but you could also make it work for any
random on-disk filesystem that doesn't support long-term storage).

At that point, the merkle tree thing ends up fairly equivalent to the
IMA "measurement" thing, with the exception that the filesystem *may*
optimize it to be long-term. Hmm?

Now, since I assume that only the merkle tree root hash would be
returned by the "enable merkle tree" operation (so that the code
enabling it can verify that the hash matches the expected value), you
do have to worry about the preimage attack, and make sure that you
can't fool the hashing by making the (bad) file contents themselves be
just the hashes of the (good) blocks. So each level of the merkle tree
needs to have a hash seeding thing or whatever.

              Linus
