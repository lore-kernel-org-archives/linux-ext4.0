Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F3E0C43217
	for <linux-ext4@archiver.kernel.org>; Thu,  3 Nov 2022 16:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbiKCQgO (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 3 Nov 2022 12:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbiKCQf7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Nov 2022 12:35:59 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0DF20362
        for <linux-ext4@vger.kernel.org>; Thu,  3 Nov 2022 09:33:35 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id a14-20020a6b660e000000b006bd37975cdfso1373347ioc.10
        for <linux-ext4@vger.kernel.org>; Thu, 03 Nov 2022 09:33:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UKNN3axs1y811QkhsVcYtMf113asLOYvCITq8yCsIOI=;
        b=GMQKcxdPhkC+SVQDqAwSaUnAU5ltAkpVrQ6Iw6HzUfhA7rV02KmigNkm9vkI+a7gLT
         C1sLwDK4kbaLMPigCzCzv+8dftdLBhOELVwAk+MCHIYAwoxEGXOXfjXHq5vMmfMm3xyI
         hDjSl9/ZbssZPJpTJPGMrHZlPpofikDbHWu6ES3TRueKfr256J81pYMTBH6cz+Ekl9Jh
         ZUAdGhboJ2v8MEbIkQcukAecAms/W/XiDMbYc5Tj4uL5Oe8nNg83+h0/5Drx580xItp+
         ER2b/l8EEulwprAU4F/TlIvP1xB1uMLkGUzj+KUs6xr9xu5//bA8vjeOlzHzaLpnAWsz
         oqww==
X-Gm-Message-State: ACrzQf3hjosAr4vIlqK/K685625GxqXRhDGnhvontIQAEMArdv6QMsY1
        SIXNzZ6+hIjotdhqYlJzbUFfLdMN07dTfAdW5qRcK3K7APxi
X-Google-Smtp-Source: AMsMyM7KSJB6PWib48eKCxQUGgM9eEZ44KGU/yZr/h+0TvMEyV3kVSaOd9iNcRMOcT+ns/pNcS3sdCIrBgqGzgxiYveDSCHWMtL0
MIME-Version: 1.0
X-Received: by 2002:a02:c850:0:b0:375:4602:f1ac with SMTP id
 r16-20020a02c850000000b003754602f1acmr18201927jao.45.1667493214829; Thu, 03
 Nov 2022 09:33:34 -0700 (PDT)
Date:   Thu, 03 Nov 2022 09:33:34 -0700
In-Reply-To: <0000000000006c411605e2f127e5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bc45cf05ec9384ab@google.com>
Subject: Re: kernel BUG in ext4_free_blocks (2)
From:   syzbot <syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com>
To:     adilger.kernel@dilger.ca, gregkh@linuxfoundation.org,
        lczerner@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        stable@vger.kernel.org, syzkaller-android-bugs@googlegroups.com,
        tadeusz.struk@linaro.org, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This bug is marked as fixed by commit:
ext4: block range must be validated before use in ext4_mb_clear_bb()
But I can't find it in any tested tree for more than 90 days.
Is it a correct commit? Please update it by replying:
#syz fix: exact-commit-title
Until then the bug is still considered open and
new crashes with the same signature are ignored.
