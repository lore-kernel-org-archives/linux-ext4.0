Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE3BC43334
	for <linux-ext4@archiver.kernel.org>; Sun,  3 Jul 2022 08:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbiGCICY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 3 Jul 2022 04:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiGCICX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Jul 2022 04:02:23 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E9FB1D6
        for <linux-ext4@vger.kernel.org>; Sun,  3 Jul 2022 01:02:21 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id n15so7441120ljg.8
        for <linux-ext4@vger.kernel.org>; Sun, 03 Jul 2022 01:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=de8gvD7eUuO3NHsCHN+a8+y4CL7WoJkH/to6IYtf5yk=;
        b=pW23QFb/2NPwyXKP4trptWpS9tVOuYN15c4SMNXjSE7DJdNG5M7im8pc1imfGfreQt
         Pub4VdIp6yfEIe5e0m2gfORV4M+h9MlSBmaO8vS3ByZf0bW3PGFwJoNT1NtEq0duMzUu
         dTULYwPH/1cOndMRB2s4IS6ymH8+Q/UQsMX4sXVimwI7dJrchj3miadX0gVHjQSearfx
         R/mQ53qvli7j5fYviqGLKRKPD8wp7cfi/sqhr7BGjL0Z6/XamvpEwom5agSDqmz0OiBF
         LWqQYVMqF2DQelFqI9dTAf49Y8jzU+gpvn3VrtpCdiO4yQ7QGw/Tg1dKdu05CmFr+p/1
         tz4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=de8gvD7eUuO3NHsCHN+a8+y4CL7WoJkH/to6IYtf5yk=;
        b=id0O7cS6AT7epk2NDZZ5yFq+4X+y4xfq4EL9yT28N6fDZI+5vO0XcWYj9IXAMHhAou
         VzsnRrZhWpJEk1CvuwHp4wsMe25hAChF5UVxuiif7j1/xDsvpdvNCe1B9rVsHuWUZ4kW
         O7ItxNx285r9XKgrMi2jP/rLelfVgHcx47li2Y3+edAAaFjCvD7JukPC2jd941sC9Zm/
         KJ+mig6ockdlSFGJV/Inq5WBTTQajNONXr6zixm1TQ03PSvCUP9lvCoQFBO/WMiES2OB
         rfAfq6JC1irQgP/8zxwKcFU5eHUgUgXJ3vTvfFMgwz42k/TNfIc0vzgsPo2fDb6Ep6uD
         AE6A==
X-Gm-Message-State: AJIora8hCy+pUCFFkPhWIJRHzwdFEvmZam/EI4f7pFpmXwYD9LzC6rz5
        vvexTb3clGYAo+CGg2v2Iwq1+gMjKy2yltXsuxQ=
X-Google-Smtp-Source: AGRyM1vtrGApbUQxljAxigQcIB2dnijlQU8fk+WgkbzFL8goYgUaLadYFdkSnRI+yyi2vn+GMks+i05vYb5KM+SSusI=
X-Received: by 2002:a2e:2c0e:0:b0:25a:6b43:eff8 with SMTP id
 s14-20020a2e2c0e000000b0025a6b43eff8mr13402086ljs.299.1656835340220; Sun, 03
 Jul 2022 01:02:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220630090100.2769490-1-yi.zhang@huawei.com> <b1f7a565-1128-f6f3-1775-8aac079b833b@huawei.com>
In-Reply-To: <b1f7a565-1128-f6f3-1775-8aac079b833b@huawei.com>
From:   Torge Matthies <openglfreak@googlemail.com>
Date:   Sun, 3 Jul 2022 10:02:08 +0200
Message-ID: <CAKtYR9OU5=PVdp9DA5bw8Wj8dOipeQ5gOz8e+eisPN=txBqfRA@mail.gmail.com>
Subject: Re: [PATCH] ext4: fix reading leftover inlined symlinks
To:     Zhang Yi <yi.zhang@huawei.com>
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
        yukuai3@huawei.com, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, 30 Jun 2022 at 10:51, Zhang Yi <yi.zhang@huawei.com> wrote:
>
> Hi, Torge.
>
> Please take a look at this patch and check could it solve your problem or not.
>
> Thanks,
> Yi.

Hello Yi,

Thank you for that patch, it does solve the problem on my system, and
has been stable for a few days.
So you can put my tested-by on the patch if you want:

Tested-by: Torge Matthies <openglfreak@googlemail.com>

-Torge
