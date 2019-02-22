Return-Path: <SRS0=rve6=Q5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A008FC43381
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Feb 2019 19:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C61420700
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Feb 2019 19:00:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="KpqTWxgo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfBVTAw (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 22 Feb 2019 14:00:52 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35386 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfBVTAw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Feb 2019 14:00:52 -0500
Received: by mail-pg1-f193.google.com with SMTP id s198so1538047pgs.2
        for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2019 11:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ymJzJ7z+dV3+GgEQWC93qEBh40t7leQbFirGbQdE5CI=;
        b=KpqTWxgoSFD95CnCI1CWK4bg2BMxxjXO/GDwfXS8WZ3JqEfNidvUCQBSUrh+AskBiI
         j2FnkYon1I6q2zdRLDHFo94pnbkNv7aJyTIhEcFDyA/hjVBQpi/pnxoRJfrPKdE974Y0
         LfRHt+2e8oDfkMAd2dtcFDM+pbtZqMUDjTUqBnSyS6mlEcpMIg8yeQbso0dDe3lknubn
         PhL3UIegW0qQz5eV1dr45JquVbvRchyvZm4BrzcCB7xjnAlkgGPXCwFulpTkB06WNXny
         MEnZZMPZdI4/Zbt/bIURvNZqm0HHZIabq1+LrDzmkE66tE9rm+1Dl12F2g1JpSwRjggL
         G5Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ymJzJ7z+dV3+GgEQWC93qEBh40t7leQbFirGbQdE5CI=;
        b=S/HUtqKxrIF/kZOjjU06L2xk7x349cGQBfB35mpbIK/CSJte+VdRIlYZcu4cp9AYSv
         Putwff+fRLCY9ZDrOeWEPMcGv6cAMghPBSUhrnvVLmuKQ1Y2QEx/WA5xlbNGiFlIRiFB
         B2S1eeyI5hEefmR7HAiH8Ut5dBLZ0c//Qb9ld8fO/h+Y1o8IVAQ7Yw/gn18Oyf3FlmDP
         9xepHt56JdPes0U/pbzUlhmvBwPxtQ1FezmlRZi68KvqcSchL8iTMy5AOUzX8494fd2K
         zmlGjile0fwj3YQDEi9+7uSAUFHUMDNBN/L3pkU5gtWLR4Ni6TeXbscgyFS7gWwqAH3k
         O3ZQ==
X-Gm-Message-State: AHQUAubO+zy7/fdVKlRx8vbP0v6MeW7jKSc1v4UltNgK8XRz1II/OVEr
        IGUez3Xf0drtmQZQIEbin3sqcQ==
X-Google-Smtp-Source: AHgI3IaJJqUBAidGC37KsWht+KBqa6uQf19rMD0pFzEsmSpGcquD/vggikA2rNP+aTlKRw87BELkmw==
X-Received: by 2002:a63:8441:: with SMTP id k62mr5058254pgd.219.1550862050988;
        Fri, 22 Feb 2019 11:00:50 -0800 (PST)
Received: from vader ([2620:10d:c090:200::4:eee8])
        by smtp.gmail.com with ESMTPSA id n11sm2959392pff.32.2019.02.22.11.00.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Feb 2019 11:00:50 -0800 (PST)
Date:   Fri, 22 Feb 2019 11:00:48 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Andreas Dilger <adilger@dilger.ca>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, kernel-team@fb.com,
        Linux API <linux-api@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-xfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Steve French <sfrench@samba.org>
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Message-ID: <20190222190048.GA29624@vader>
References: <cover.1550136164.git.osandov@fb.com>
 <20190214220626.GV14116@dastard>
 <20190214231429.GE9819@vader>
 <20190215001657.GY14116@dastard>
 <20190215065947.GG9819@vader>
 <72A04438-5991-4A60-8AAB-021A41DE6711@dilger.ca>
 <20190218221820.GF14116@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218221820.GF14116@dastard>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Feb 19, 2019 at 09:18:20AM +1100, Dave Chinner wrote:
> On Sat, Feb 16, 2019 at 06:57:45PM -0700, Andreas Dilger wrote:
> > While it may be a bit of a stretch to call this "forensic evidence", making
> 
> We do forensic analysis of corrupt filesystems looking for evidence
> of what went wrong, not just looking for evidence of what happened
> on systems that have been broken into.
> 
> > it hard to change from except via total root compromise by a skilled hacker
> > is very useful.
> 
> *nod*.
> 
> > If this were to go in (which I'm not in favour of), then there would need to
> > be a CONFIG and/or runtime knob to turn it off (or better to only turn it on),
> > similar to how FIPS and other security options can only go in one direction.
> 
> The problem here is that "inode birth time" is being conflated with
> "user document creation time". These two things are very different.
> 
> i.e. One is filesystem internal information and is not related to
> when the original copy of the data in the file was created, the
> other is user specified metadata that is related to the file data
> contents and needs to travel with the data, not the filesystem.
> 
> IMO, trying to make one on-disk field hold two different types of
> information defeats one or the other purpose, and nobody knows which
> one the field stores for any given file.
> 
> I'd suggest that "authored date" should be a generic system xattr so
> most filesystems support it, not just those that have a birth time
> field on disk. Sure, modify it through utimesat() and expose it
> through statx() (as authored time, not birth time), but store it a
> system xattr rather than an internal filesystem metadata field that
> requires was never intended to be user modifiable.

It seems that this is the general consensus, so I'll look into
implementing this functionality as an xattr.
