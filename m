Return-Path: <SRS0=gd00=QI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B024FC282D8
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 09:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6757820870
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 09:44:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="fh+3d6oZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfBAJoa (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Feb 2019 04:44:30 -0500
Received: from mail-io1-f49.google.com ([209.85.166.49]:39413 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbfBAJo3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Feb 2019 04:44:29 -0500
Received: by mail-io1-f49.google.com with SMTP id k7so5165615iob.6
        for <linux-ext4@vger.kernel.org>; Fri, 01 Feb 2019 01:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=7OzEOr3RpuwavNCx5jUweztqskIlHtGVgehTJW9ywYU=;
        b=fh+3d6oZsrJ8KHZis6XDpHDVBJy815iOj8G9D+R2XXKfK+jOJJ413V4/+IRF2Yel7Z
         FoALxhuSYyIDl5skkwbvKKyheP45C09u4tQTVbNgS6rvPYFhBX5qLe3cDSuepVmKsV+K
         nZzG4GPkeZvAoIY3/w38z1hd+u8GZe0nXLYTTme+sYXORB5eR/WbX+PAtb1Rh9RaQG/0
         0xhavaZo0RSCRWL0Np0NcyB6gR4mU13x4qi/ObwmtbS+5s96vjzb+n1fp8tUG5pXe+aD
         ueP/mSoSz5lt3n5gWxBS4qteSQNypK2PpNY2tum1SvRNjriJc1ZEnoauclgdYgZK3zzs
         DIUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=7OzEOr3RpuwavNCx5jUweztqskIlHtGVgehTJW9ywYU=;
        b=GJAyc/DQPOmnUtTtV3yyhDzuw3I3cDd66Ka5r+16Jj/lbUFYMXJIjRxDPQB9qVfZEq
         uglPpo+r3prscQT65j9aFxg/6M+N0HIiLIyCRZSuaUcFZ3vDMfTm7HRuREs3zLG08VQI
         kYh55V0PiWl13on0e0Joio7y3dL730GB5fuXj7BKQ8ixnKeKUPntmeukeWUJtH/brG0d
         VfE5J4XrlPkrGOT78xiGE4tBbpq/I+b+zr5x8Tf739w6YJB1ADeMn3IN2SczAvEmnmc4
         WQPgp2SDGrmJ5AMKhIHmCOpSr9beiL1lGe2qvAKKNoAw5mbgx6ksSG3a4VRuJbOL+vs4
         oK7w==
X-Gm-Message-State: AJcUukenT9/s9OUNQOksPGOXcjoZv+BOcBxm1rCiTx1s2RFty1xopxvg
        RTn/oo/uccLSjBUt6dG+93oi61m/YCeoggTTDrLjJDCmewA=
X-Google-Smtp-Source: AHgI3IYXTqIRPaGH3FaJUtvRHuKNB5kUFx8fks3/386EyRoX/2UioaRV39hjL6eSytqv1ujURcjXrbpUyGoe85JaRA8=
X-Received: by 2002:a6b:acc5:: with SMTP id v188mr21110504ioe.20.1549014269048;
 Fri, 01 Feb 2019 01:44:29 -0800 (PST)
MIME-Version: 1.0
References: <CAJTo0LYhwc978ywMkZ1v3xZHsW4DVwrszKnPoewvzvNixD_Pcg@mail.gmail.com>
In-Reply-To: <CAJTo0LYhwc978ywMkZ1v3xZHsW4DVwrszKnPoewvzvNixD_Pcg@mail.gmail.com>
From:   "Burton, Ross" <ross.burton@intel.com>
Date:   Fri, 1 Feb 2019 09:44:18 +0000
Message-ID: <CAJTo0LbADyD3oE8roCRtEMdV5FX2GCzGPOBeh=vTS2GEJ8KTTA@mail.gmail.com>
Subject: Re: Writing large files into a ext4 with mkfs is truncating files
To:     linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, 1 Feb 2019 at 00:14, Burton, Ross <ross.burton@intel.com> wrote:
> $ cmp fs/foo  /mnt/foo
> fs/foo /mnt/foo differ: byte 1073741825, line 4194938
>
> Okay that's not the 4GB boundary.

$ bc
obase=2
1073741825
1000000000000000000000000000001

That's 2^30.  I'm guessing a signed type is used somewhere?

Ross
