Return-Path: <SRS0=geXL=QZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF98DC43381
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Feb 2019 18:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A09AF2085A
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Feb 2019 18:17:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="jYzVN+uB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391067AbfBRSRm (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Feb 2019 13:17:42 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35041 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388468AbfBRSRl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Feb 2019 13:17:41 -0500
Received: by mail-ot1-f65.google.com with SMTP id z19so29877687otm.2
        for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2019 10:17:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rYbDxDTwUu2yrm6JgBKdUU5YZs5vkL9CyT6m74b4Ti4=;
        b=jYzVN+uBVs18izFqV6joX1r8ruccLW+zeO4xjUPI6KR4zY3Lz3/hh6PGGWeR0vHKRa
         727qdgmLGJzJKOaW++ugjxK8ETqc5KtdTMB2NSFmdZKVD4cXLQMiOLna6sgE3YbPs0Um
         vRZjOrt80ktWBl2+wxVs0KB5zSvZSXuqXRfj3LElIe0GgRFK0Yb81qMuzoXzB82MgBqF
         V9WqIo6ilobACH2PGgNr0UI8FwWDoq0OcdNbOCyK9t62hSUIJ4aJ2JScr3UU6nfU7bGT
         wqFYNDc06CMIP6m3vbPDC46SHJzqS3PL8nCpRhdIvieQUuz9Gj66fZbJkJCXJ6MDhpv7
         IRjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rYbDxDTwUu2yrm6JgBKdUU5YZs5vkL9CyT6m74b4Ti4=;
        b=pzK/eepKux7CfUcYndq5TJb9lxsBQ9/8rRUufJM+rdKe/9WZ8uRV3rwD2Xn7QpgZFK
         Yp8jWwH9OhAn9ZogIflMX+5/9r/I7lSUh/h6oYgoFAQOJ+g0p/R8Bfk2wJoredv7diAh
         Rx0xKCkwizzOPQS+0drlc7CB3vVzs22GtzD9gbcCcQbnRrrR/Sxh6W0V884cKYLann1R
         wHFfPiSJh+B3mslOR58e1l6EIXDSCMkmJr3Q53V6CQG/KLPBkvkAKrC2vezdLtx0Db1q
         guoDpUbxCa4/N00g9s58rf+6Ka5hucaHQV2DCRcjOidiIpTKOQKdq12g949Pq63zwLgf
         gQ3g==
X-Gm-Message-State: AHQUAuYMKiMZLA2PfxZqj8SXMd5kjoEIxyNF3N2+5FGOJSHu8tMRIhUV
        IZRfVctC5MHzvWRwtFYL/wMoA6jlnJA7s1XotSzOrw==
X-Google-Smtp-Source: AHgI3IZ8qU+GpceKYETk5riXjoYKl9pS+E6Dxar/4+Wrm5LaPHCFe2w+P0TR8OtwYHBK6dR8BpB8QSNXS852dCM8H6Y=
X-Received: by 2002:a05:6830:1c1:: with SMTP id r1mr6242760ota.229.1550513861162;
 Mon, 18 Feb 2019 10:17:41 -0800 (PST)
MIME-Version: 1.0
References: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
 <3eb67ffa-76c9-aa66-d162-d4e209330f48@gmail.com>
In-Reply-To: <3eb67ffa-76c9-aa66-d162-d4e209330f48@gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 18 Feb 2019 10:17:30 -0800
Message-ID: <CAPcyv4grMnrviSDJrA5FQOFvxuAMUXoKvgNpdy9sF9zi+OHJNA@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] The end of the DAX experiment
To:     Ric Wheeler <ricwheeler@gmail.com>
Cc:     lsf-pc@lists.linux-foundation.org,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Feb 17, 2019 at 12:29 PM Ric Wheeler <ricwheeler@gmail.com> wrote:
>
> On 2/6/19 4:12 PM, Dan Williams wrote:
> > Before people get too excited this isn't a proposal to kill DAX. The
> > topic proposal is a discussion to resolve lingering open questions
> > that currently motivate ext4 and xfs to scream "EXPERIMENTAL" when the
> > current DAX facilities are enabled. The are 2 primary concerns to
> > resolve. Enumerate the remaining features/fixes, and identify a path
> > to implement it all without regressing any existing application use
> > cases.
> >
> > An enumeration of remaining projects follows, please expand this list
> > if I missed something:
> >
> > * "DAX" has no specific meaning by itself, users have 2 use cases for
> > "DAX" capabilities: userspace cache management via MAP_SYNC, and page
> > cache avoidance where the latter aspect of DAX has no current api to
> > discover / use it. The project is to supplement MAP_SYNC with a
> > MAP_DIRECT facility and MADV_SYNC / MADV_DIRECT to indicate the same
> > dynamically via madvise. Similar to O_DIRECT, MAP_DIRECT would be an
> > application hint to avoid / minimiize page cache usage, but no strict
> > guarantee like what MAP_SYNC provides.
>
>
> Sounds like a great topic to me. Having just gone through a new round of USENIX
> paper reviews, it is interesting to see how many academic systems are being
> pitched in this space (and most of them don't mention the kernel based xfs/ext4
> with dax).

Makes sense, the current fsdax facility is chasing feature
deficiencies relative to device-dax (longterm pin support) and nova
(dax techniques for fs-metadata).
