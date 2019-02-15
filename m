Return-Path: <SRS0=7ymp=QW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C70F6C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Feb 2019 05:39:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99C3A21B1C
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Feb 2019 05:39:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="f52brf+h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731534AbfBOFjw (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 15 Feb 2019 00:39:52 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46433 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731511AbfBOFjw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Feb 2019 00:39:52 -0500
Received: by mail-pg1-f195.google.com with SMTP id w7so4243631pgp.13
        for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2019 21:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HaZj6WZq8bt12xjoYpuzuAGCzO6878f/AB6sJH+QDSQ=;
        b=f52brf+hmO17QSieL0bvnJyW4YwJrzb4BPFwsuNawt+4oW+vq5rVv0gnHmAbQMNQ+c
         mQ8pkd9zZYQz6JV6yJy/2YPhP3RTmH/VZii1Qtuy2GRqWVFJtsCdCqYDlEmeaDmurU6Z
         AS8fnWjRurg9KNFoV+UDUBHjDp2R9Tyo1Jp4fnJcdyj+dw8gjSc+aMFlgVtd10mBSDuk
         3eHS0SO+7gxV/OQTP7Jbti1Qd7hsAOn1/g/Csj4UYmoH1lUtL83IkMOT84j6N6lowITG
         PkbBtSO0hjQalVT2lCh8+HLnhhFda4VsG1e43w2HB7q7jHwxIGSVNJbtYW5bxEVEdzBc
         OEVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HaZj6WZq8bt12xjoYpuzuAGCzO6878f/AB6sJH+QDSQ=;
        b=kRdfCQPWPQODD9+2Nrr/AJ6FRRuzYEsZYCNrKb4eho73HcRCpGjxnJq8O4PVjkXAVO
         vVRXolWLnXuw7vdAqcnitY3JM8so+VAIBEK5AM+KvMUjPGRTgSr1ATog82c2v1+1luaV
         pIlzppt4P566eX9JxEFlH7VQgIL8SP+uHtd4iS8FVVh03jRL2CxL21ngjl+pBSdFiYo8
         W9UgKNnAeuxK8F50Po3gnjb8TVqNEuP491/cBF3XVE6rQXmHerbJ9xAsGtxh7LWegcOP
         KkXU1jzpVQRH+LM6fl1XK1h+VOx9YrpTxTO/c2cugIUNGQ3PGG59M+kjTCzIjUKeeyrT
         PO0g==
X-Gm-Message-State: AHQUAubpYF+ayCuDObPRgrI+F2IOV90dsEXpkBGFRTn/yCXshrdMW4Ov
        fIlMH9dXE0IQ7dE6501mGwbPvg==
X-Google-Smtp-Source: AHgI3IbNmamUmr6xpmYEJn3AZ2qn54+j3cwXoNnI/U09nStWsyTnbCHvdL7oeZ4owrS16Nk+FRndNQ==
X-Received: by 2002:a62:e519:: with SMTP id n25mr7987895pff.151.1550209191421;
        Thu, 14 Feb 2019 21:39:51 -0800 (PST)
Received: from vader ([2601:602:8b00:55d3:e6a7:a0ff:fe0b:c9a8])
        by smtp.gmail.com with ESMTPSA id o85sm8781046pfi.105.2019.02.14.21.39.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Feb 2019 21:39:50 -0800 (PST)
Date:   Thu, 14 Feb 2019 21:39:50 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
Cc:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Message-ID: <20190215053950.GF9819@vader>
References: <cover.1550136164.git.osandov@fb.com>
 <1190dcc0-7054-72b4-2a88-33d0b97e332c@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190dcc0-7054-72b4-2a88-33d0b97e332c@mendix.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Feb 15, 2019 at 01:57:39AM +0000, Hans van Kranenburg wrote:
> Hi,
> 
> On 2/14/19 11:00 AM, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
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
> 
> Can you give an example of such usefulness? What's the thing you run
> into that you can't do without having this?

That boils down to what's useful about having the file creation time,
and it's really just another tidbit of information which you may or may
not care about. Maybe you have a document that you've been editing for
awhile, and you want to know when you started working on it. Or, you
want to know when a user created some directory that they keep adding
files to.

If the file creation time is useful to you, then you likely want it
preserved if you have to restore from backups. If I had to restore from
backups yesterday and I'm trying to figure out when I started that
document, I don't care that I restored that file yesterday, I want the
real creation date.

If you've never wondered when a file was created, then I'm sure you
won't care whether btrfs send/receive preserves it :)
