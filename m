Return-Path: <SRS0=rAxa=3N=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE75C2D0CE
	for <linux-ext4@archiver.kernel.org>; Fri, 24 Jan 2020 04:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2835D2071A
	for <linux-ext4@archiver.kernel.org>; Fri, 24 Jan 2020 04:31:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KDHO7h9B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730597AbgAXEbD (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 23 Jan 2020 23:31:03 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46474 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729900AbgAXEbC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jan 2020 23:31:02 -0500
Received: by mail-lj1-f193.google.com with SMTP id m26so862904ljc.13
        for <linux-ext4@vger.kernel.org>; Thu, 23 Jan 2020 20:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YARMc3ae9hSUEoLGMas34bGpYXx9jRcQkvor0pcL47o=;
        b=KDHO7h9B/b3mjy26Oj4EeSJIUNyQLYKaSj3d1nBNy4K7dVvqvhrzQt3G+uksHtglCC
         GEn7l0fqTV7YiLooSM8wJDBDZ3zMa1NiXyT+I4cRb1BWaZgPHz2JpFTvojB+HO94ozad
         MFaWKBQ9Zo4BEUhjLXI4paXN7kyNHtoN96Dwri5CF7MjQQUEfySc0AQBNxyC2R8iJZCg
         guQxm94eI0DXd65SS/rnuHoJaoHhIN0BgEW5d7+6uC/9ey1p7B8TnBe/F7DCn8v2dGTO
         IOVEJ7yvZF/HCRcAWrK9qPC6Itzo8kSjahJNwMYca4x2RJsn6vyrLjbauzKhHQ8haKAe
         U9uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YARMc3ae9hSUEoLGMas34bGpYXx9jRcQkvor0pcL47o=;
        b=Gm4qgQKHc6wTsA86T/z5Dnd8LMGZT0SkEDo02G+Rv8FAk8U6AVGqL0yK3NF6ycVtQM
         jkIOnUJzkLwLTjU2F09rGUYGeXTHueUWi6DIYnMBhvYmfLomkceJiGf907V7/oDlKSXh
         I8MJvDLiby8PfoCDeyTi1yGTNFgRbJDAuaxLHh8AKwN9nxXtXPJTmRHgQMe4gTpoaIHM
         GC7zdxz28kjNUXATQ+qndM8drP2SeLQKGD5yN+c+R7NDjpkL2ux6+dtcIXGCMNkMb82g
         DZvy4JOqqRqqjaywk982roSpws2bU6BANk9HQQXYUqpH4aIg2kurvQG7gtxEtwl6XHnT
         y5OA==
X-Gm-Message-State: APjAAAW3RU+uw5q2d20bhWdDwS5Q9Dxt3Fi53iPhL966iQ+jyR3Bvh89
        BqammNHLknJK60Y4OSy3tKAg+Gf3eqMRUVZBlN76Mw==
X-Google-Smtp-Source: APXvYqxDuXJqv/c/SqXLq4l0cAQvIWw6dIaAJm1RLNe4FSj10K4FMOIdAwv3/v/qIrOL5GnNI2cG/1NfCFFst9nvTGM=
X-Received: by 2002:a2e:7816:: with SMTP id t22mr1024528ljc.161.1579840260417;
 Thu, 23 Jan 2020 20:31:00 -0800 (PST)
MIME-Version: 1.0
References: <20200117214246.235591-1-drosen@google.com> <20200117214246.235591-6-drosen@google.com>
 <20200120013528.GY8904@ZenIV.linux.org.uk>
In-Reply-To: <20200120013528.GY8904@ZenIV.linux.org.uk>
From:   Daniel Rosenberg <drosen@google.com>
Date:   Thu, 23 Jan 2020 20:30:49 -0800
Message-ID: <CA+PiJmQPFG7OehStFfNQE_7MGwgozhaa0TxZd+aHL2cFLMFbsA@mail.gmail.com>
Subject: Re: [PATCH v3 5/9] vfs: Fold casefolding into vfs
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

> ... buggering the filesystems (and boxen) that never planned to use
> that garbage.
>
I'm planning to rework this as dentry ops again. Your other comments
point out some issues that also exist in the old dentry_operations, so
that's a good opportunity to fix those up. How do you feel about just
having the two entries in struct super_block? With them there, I can
add the dentry_operations to fs/unicode where they won't bother anyone
else, while not making every filesystem that uses it have to carry
near identical code.

>
> Are you serious?
>         1) who said that ->d_inode is stable here?  If we are in RCU mode,
> it won't be.
>         2) page-sized kmalloc/kfree *ON* *COMPONENT* *AFTER* *COMPONENT*?
>

#2 is the part that made me the saddest in the patch. I'm planning to
move this to the unicode subsystem so it can just walk through the
name as it computes the hash without needing any allocation.

>
> ... and again, you are pulling in a lot of cachelines.
>

I probably should've just given it a DCACHE flag, like what fscrypt is
using. A simple flag there would've done everything that I'm doing
without making the cache super sad and making any attempts at making
it actually work with RCU much simpler.

> <understatement> IMO the whole thing is not a good idea. </understatement>
