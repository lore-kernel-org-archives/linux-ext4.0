Return-Path: <SRS0=HZ/b=RV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D526C43381
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 05:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 555CD20872
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 05:24:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RYllj6K0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfCRFY0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Mar 2019 01:24:26 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:39379 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbfCRFY0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Mar 2019 01:24:26 -0400
Received: by mail-wm1-f51.google.com with SMTP id t124so11268297wma.4
        for <linux-ext4@vger.kernel.org>; Sun, 17 Mar 2019 22:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C8sPhnZAJi9DhgCq1IDce1MVkCex4ynzq4GpgzH1Eig=;
        b=RYllj6K01aL7QlwyDeFZBbKJfHuWUg51WLr1o1MWD0ivuJoSIv7hm9jVhQiOrgD3lN
         jXqq3DmuGZUjw/eonJ5aiKJcSTVlx9ojyUMveubYx8DqzJzWfs8dE+nhDONJtNhRORe/
         6PU3u8ww6EW3NjEoxGs+KbG5twQtOI6/KD+2PLhD4a7G5+a0QJaFXSS2LxyCD4HcgFQx
         wBmjuvld6Dhd6PSpqgw3Sx8gZCPIFUUYQpbK3Hl8lac8cg8BrytU2Zc9Q6s6ktHb0fU0
         +rohMCDRzOHhdLBKXvnKIiPkG4k5ttyj5Bjvg+GzPWXeq7fzFz0RiPKpDv+dgIb/aPIP
         BAEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C8sPhnZAJi9DhgCq1IDce1MVkCex4ynzq4GpgzH1Eig=;
        b=idkJdFhuSF8XZ0S5V3x4uo6c1ESMbFt62UF26i416EUdq3/gNTVnU8ftiglGz0yJdF
         vzVsDHbM4MknFejvkx3cKhmAqA4yECjoFjYLJVmF0cKlBsbxuMzXFWkjOOhRL4Q6JeFT
         xTwc22UxQh13hF7KxjD10cMjASlyCsgL6mBWHMCKkCYWP6pFac+uoYE9CDdStnqUN7KD
         TrqOV19/lx+yNAIadffSWjmiwNq8WdDnOo5ZmvSDyKOkvjfVi1g0TyrTsv4U6Mn7dppD
         YkX0iUyqhDwC4mIslhimU0RFG/Ct2uvfv+H5DbQxel3pvxDNqJfyb2xFTNXNmegJcUrT
         wNUg==
X-Gm-Message-State: APjAAAWCAP7+uDy+3V8OQQ5cOLD95rUMK6pFSVAvyNnAEQ3Over67b6F
        IQHnKTv8bePUyKeOCgfS7YbCSCwITfGEa6ai6goQIVu4
X-Google-Smtp-Source: APXvYqzl5y16tfEkvi0/7v+6/+q45/DAbnSPLds3oYDbgZzaaTW+kK429ov+W7LniwT40bd8D9Hthfkww4eKKlydVf0=
X-Received: by 2002:a1c:4b03:: with SMTP id y3mr9970419wma.75.1552886664945;
 Sun, 17 Mar 2019 22:24:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAB5bDOiUNd_-5FTrCL0vEs_6UUqi=xKkQeH0hWL256i7p=0Kkg@mail.gmail.com>
 <48911DBD-B419-4C61-8F53-6CB41C304985@dilger.ca> <CAB5bDOiGPiOmupPepWjNnV7e1xL0wgaA4bY243rfkvSDCanAOA@mail.gmail.com>
 <CB5B81C1-C1C8-4A19-8062-89B2B50C4F65@dilger.ca> <20190317211922.GC23356@mit.edu>
In-Reply-To: <20190317211922.GC23356@mit.edu>
From:   Burke Harper <go88team@gmail.com>
Date:   Mon, 18 Mar 2019 01:24:16 -0400
Message-ID: <CAB5bDOgXRPK4Bw-XaPqpFUbAbU7dGk+x9jeXUD_cJqWQASqjdA@mail.gmail.com>
Subject: Re: Should Never Happen: Resize Inode Corrupt
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Correct.  The it was previously 36T.  A few weeks before that it was
28T.  The resize from 28T to 36T performed just fine.

I've upgraded to 1.44.5, cleared the resize_inode feature, and have
restarted e2fsck -f /dev/md0.

Thanks.  I'll check back periodically as this part seems to take a long while.


On Sun, Mar 17, 2019 at 5:19 PM Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Sat, Mar 16, 2019 at 12:57:57PM -0600, Andreas Dilger wrote:
> > You could kill e2fsck and disable the resize_inode feature?  There is a different resize mechanism available now (meta_bg) that doesn't need it.
>
> It looks like the file system was previously 36T and you were trying
> to resize it to 51T.  Is that right?  The resize_inode feature should
> not have been present at all; it's not valid for file systems > 32TiB.
>
> The resize2fs in 1.42 is more than a little bit buggy when dealing
> with large file systems > 32TiB, and it sounds like there were some
> problems dealing with the transition from file systems smaller than 32
> TiB (where the resize_inode still works), and file systems > 32 TiB
> (where we use a new style of on-line resizing, called meta_bg.
>
> Hopefully that's because you used an old 1.42 resize2fs when you
> resized it up to 36 TiB, but we should test to make sure it's
> currently working correctly.
>
> Similarly, e2fsck shouldn't be even trying to deal with the resize
> inode if the file system size > 32 TiB.  (Or to be more
> accurate/pedantic, when the max. block number no longer fits in a
> 32-bit integer; although if someone is using a 1k or 2k block file
> system on a file system that larger, they have other problems.  :-)
>
> So yeah, the first thing I would use debugfs to clear the resize_inode
> feature:
>
> debugfs -w /dev/md0
> debugfs: features ^resize_inode
> debugfs: clri <7>
> debugfs: quit
>
> And then run e2fsck -f /dev/md0.
>
>                                         - Ted
