Return-Path: <SRS0=5TFS=QV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 934CEC10F04
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 23:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FB2C2229F
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 23:14:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="QLdY6BBZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbfBNXOc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Feb 2019 18:14:32 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41467 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728833AbfBNXOc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Feb 2019 18:14:32 -0500
Received: by mail-pl1-f195.google.com with SMTP id k15so3938584pls.8
        for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2019 15:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7SfU72gcrRF72F+nJVlw7gVASMLfI2u9di4u4DkjDbA=;
        b=QLdY6BBZfaP+F21V56Zn90mKpvF6cT5rRLW33plh5EGmvt11YFMgltN31pjI4tn/IV
         koMVBoFNGN8ZtfJr2hCO9uEuS3NrODro7CANqAPQoOMAep8B0V+LYj37CvDHkNzeL6ct
         62CXd+8R7MWMXrOhkGKlb274XkWHiTUqYPbjJi/jSzJBuiYKCuTr+won8V77+aPKQBPA
         aAU9iESm1QBRXnbEalmHzFp+95aR7OMWBD4PHadxlYnn/XQm727kSyMTva5Ndk90yCsb
         YHsL7mvSWmK262kWdfAzMRYzeLafPrsd7xUmWWCcnqRJQ69wuRmSUJ8U72J/fYFleWXx
         fIkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7SfU72gcrRF72F+nJVlw7gVASMLfI2u9di4u4DkjDbA=;
        b=QBt6OMnJUmwH7a4OjLPUEZk+kUJNk1FBqE7Z80dSZF81DXzt76ypV/fdTI+Z0L8tNI
         sxi5l2mHTipITmmCGd7onfR/trUvQfNaNBnEJPE+BlHFU1nECjjNePrRssYT/0JnBQLv
         oVOiofPi2VAF2twvcFnwgIKmTPfYYZV5Ctb7ps1QUB8/ns32SKXdN27wXGJuvMc+lTBO
         WTEoyAFfF3JQmlZFGiTY+MyTtkg/WraX71v56qoqSVS8pRbv6DHewblbYGu5raCzbcKg
         gMWmvHc37KbsWSht1Dv6mi7xdqekO+QY2yTvmoz9GXnOKgclSHOIxgAm11QvJVvmT61w
         DSUw==
X-Gm-Message-State: AHQUAuZGhHhh41i7nebFaPVLL2bloC8EoxwzE0Wzl1EY7B12QT+U9TKU
        q5NgR6qIT0dFtWg5a9667/b7lA==
X-Google-Smtp-Source: AHgI3IbTtlBSlHAys78Mv2bx20xiDs5m2FD2kweZaR4rRH4T8BD/OPaEbwgfHpdGjN6D6fXbcGVGqg==
X-Received: by 2002:a17:902:780c:: with SMTP id p12mr6702678pll.197.1550186071269;
        Thu, 14 Feb 2019 15:14:31 -0800 (PST)
Received: from vader ([2620:10d:c090:200::7:c363])
        by smtp.gmail.com with ESMTPSA id s79sm4468836pgs.50.2019.02.14.15.14.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Feb 2019 15:14:30 -0800 (PST)
Date:   Thu, 14 Feb 2019 15:14:29 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        kernel-team@fb.com, linux-api@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Message-ID: <20190214231429.GE9819@vader>
References: <cover.1550136164.git.osandov@fb.com>
 <20190214220626.GV14116@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190214220626.GV14116@dastard>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Feb 15, 2019 at 09:06:26AM +1100, Dave Chinner wrote:
> On Thu, Feb 14, 2019 at 02:00:07AM -0800, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > Hi,
> > 
> > Since statx was added in 4.11, userspace has had an interface for
> > reading btime (file creation time), but no way to set it. This RFC patch
> > series adds support for changing btime with utimensat(). Patch 1 adds
> > the VFS infrastructure, patch 2 adds the support to utimensat() with a
> > new flag, and the rest of the patches add filesystem support; I excluded
> > CIFS for now because I don't have a CIFS setup to test it on.
> > 
> > Updating btime is useful for at least a couple of use cases:
> > 
> > - Backup/restore programs (my motivation for this feature is btrfs send)
> > - File servers which interoperate with operating systems that allow
> >   updating file creation time, including Mac OS [1] and Windows [2]
> 
> So you're adding an interface that allows users to change the create
> time of files without needing any privileges?

I think it'd be reasonable to make this a privileged operation. I didn't
for this initial submission for a couple of reasons:

1. The precedent on Mac OS and Windows is that this isn't a privileged
   operation.
2. I knew there would be different opinions on this either way I went.

> Inode create time is forensic metadata in XFS  - information we use
> for sequence of event and inode lifetime analysis during examination
> of broken filesystem images and systems that have been broken into.
> Just because it's exposed to userspace via statx(), it doesn't mean
> that it is information that users should be allowed to change. i.e.
> allowing users to be able to change the create time on files makes
> it completely useless for the purpose it was added to XFS for...
> 
> And allowing root to change the create time doesn't really help,
> because once you've broken into a system, this makes it really easy
> to cover tracks

If the threat model is that the attacker has root, then they can
overwrite the timestamp on disk anyways, no?

> (e.g. we can't find files that were created and
> unlinked during the break in window anymore) and lay false
> trails....

Fair point, although there's still ctime during the break-in window,
which I assume you'd be looking for anyways since files modified during
the break-in window are also of interest.

I see a few options, none of which are particularly nice:

1. Filesystems like XFS could choose not to support setting btime even
   if they support reading it.
2. XFS could add a second, writeable btime which is used for
   statx/utimes when available (it would fit in di_pad2...).
3. We could add a btime_writable sysctl/mount option/mkfs option.

Thanks!
