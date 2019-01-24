Return-Path: <SRS0=8KOi=QA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D343C282C3
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 21:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 665E6218D0
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 21:40:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FxqttcGn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfAXVkw (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jan 2019 16:40:52 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34950 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfAXVkv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2019 16:40:51 -0500
Received: by mail-lj1-f196.google.com with SMTP id x85-v6so6626031ljb.2
        for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2019 13:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DviOLDTB8yMdnnA6Ob0s3UVaoyQ1XPoAGIEra4N7CvI=;
        b=FxqttcGnNywD1lcZbvM1KLYdnS2UP4vXEaoeK39UO/LlqvqZr8vWDAZEY+J+e4to24
         s+20NuSsdVivvmcaVg2zOlrrp+TR4A/nzymZKM/hkvMyAF/1wp5DjEXZmQmxdAr4pBB0
         qJMOE7vJGDJ162CRytvjHKbfUYgcjt8HIDEJI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DviOLDTB8yMdnnA6Ob0s3UVaoyQ1XPoAGIEra4N7CvI=;
        b=R+j1/6agp+JcC5t16rb77WRcp32/3fUUTT0Nb3YsYb1VIbobdK44Qmz6LYW7kUBeVQ
         GgCtuEUxWDw2qBaK4keN+U+waMj1BbktPgGr9lTATti8GWvFHSDXltIumftBMniAzljP
         C1aQYP+ZPL018FTvrMekuDlQAo+MrjstF2/EdEpaG03CBdIL5OF0KyPSj8+LspvY/Dqr
         GmNwtnv8G2YMkpDEccfdSTehQWtM4ulGbH+L26Bm7nsJY8y7E/imW8BzPOGpWj1JD1RY
         lANy+m/vMlasavKap+jmjo5QcrLwgsq4euGuZUUI+LRwjslbYdW63BmLbBcuSN+KIpK9
         XG2g==
X-Gm-Message-State: AJcUukcStPA8Vv307x9chY04/J8fsGCyrg6NHobIn0POz/Q2YPMglD9v
        yODJK13UvVodxLPpUKEsYMScBxKUSdpStQ==
X-Google-Smtp-Source: ALg8bN5P2Y9FdTjow02EiNspRLWQAkOtpsaim68G7N76uTTOEl1avYF96BwY1GCaIfuSHccB0t1Zew==
X-Received: by 2002:a2e:8187:: with SMTP id e7-v6mr6760812ljg.67.1548366049513;
        Thu, 24 Jan 2019 13:40:49 -0800 (PST)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id a11sm1147454lff.68.2019.01.24.13.40.48
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 13:40:48 -0800 (PST)
Received: by mail-lf1-f42.google.com with SMTP id p6so5479805lfc.1
        for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2019 13:40:48 -0800 (PST)
X-Received: by 2002:a19:cbcc:: with SMTP id b195mr6481061lfg.117.1548366047503;
 Thu, 24 Jan 2019 13:40:47 -0800 (PST)
MIME-Version: 1.0
References: <20190110051500.GA32361@mit.edu> <20190114234101.GQ27534@dastard>
 <20190123051017.GA8785@mit.edu> <20190124212544.GS6173@dastard>
In-Reply-To: <20190124212544.GS6173@dastard>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 25 Jan 2019 10:40:31 +1300
X-Gmail-Original-Message-ID: <CAHk-=wh7jq6U3+ou_FDujB-ipg9JcJAGSjEQ_niCwLG313x6UA@mail.gmail.com>
Message-ID: <CAHk-=wh7jq6U3+ou_FDujB-ipg9JcJAGSjEQ_niCwLG313x6UA@mail.gmail.com>
Subject: Re: Proposal: A new fs-verity interface
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
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

On Fri, Jan 25, 2019 at 10:25 AM Dave Chinner <david@fromorbit.com> wrote:
>
> So it's still "file data" that the filesystem has to magically
> transform into hidden metadata in some manner. What writes the
> merkel tree into a file, and why can't it just write it direct to
> the filesystem rather than having to use an intermediate file?

This does frustrate me too.

I _assume_ (but it's exactly that - just an assumption) this whole
design decision comes from basically having a transport layer that is
entirely unaware of the merle data, so the data  is brought in some
entirely traditional way that can only transfer regular file contents
(ie tar/zip/ar kind of thing, but presumably actually just in the form
of an android APK). And then the new interface is just a way to
"convert" that into the actual final security model.

One thing that is also unclear to me is whether that "secure" model
needs to be stable on disk (ie is this considered an actual write that
*modifies* the underlying filesystem, and the merkle tree data ends up
being associated long-term and over reboots), or whether it would be
acceptable to just have it be a temporary "view" of the file where the
filesystem itself can be read-only, and all that happens is that now
the merkle tree is associated with that file as long as the filesystem
is mounted (or until it is disassociated).

Maybe this was answered in some of the earlier email threads that (at
least for me) were then somewhat overshadowed by the merge window work
and the holidays. So it's possible that I repeat myself. But I do have
to say that I think I'd *still* prefer this to be something more like
an xattr, and that maybe we'd be better off actually improving out
"write to xattr" interface or something.

I understand that you don't want to load the whole merkle tree into
memory, and that is the reason that you want to point to some "stable
on disk" area, but the hole punching does seem to be a particularly
nasty part of it. It would be much better to have the merkle data in
some place where it doesn't then need to be hidden again, no?

             Linus
