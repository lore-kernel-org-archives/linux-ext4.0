Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF02EB8FAF
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Sep 2023 08:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235744AbjIFIrA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 6 Sep 2023 04:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235599AbjIFIq7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Sep 2023 04:46:59 -0400
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C920710C9
        for <linux-ext4@vger.kernel.org>; Wed,  6 Sep 2023 01:46:48 -0700 (PDT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-5703f4f8acdso3093858a12.0
        for <linux-ext4@vger.kernel.org>; Wed, 06 Sep 2023 01:46:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693990008; x=1694594808;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DC68Fan9U1mDvvm9HS7/KL5cq/tCfXtYDl7pvERFoFo=;
        b=BTgMH3oq7s7Q+uCN0l3hYPeDMxUg1Lar6agp6EiQrsGstGTweurMfHxqQYR6UWpxzE
         HxsSf+iO2lXkxk5gNlK1zbSuQqQfARJ/skW4VKCf8ASKYoaOkOm5JnbIiybo3pl5GtLK
         0Pbqd1/Mabih5jCbYugVe/8jVdaZC5OsPPJ8zH1j4xJVHNtq8uoZA3vK5PxXJ7BOOwq0
         v4gRB1XOI8uUsdIi8wW1vhfVzJI19vRTF7W008FEVeVuJ7PJULnGBgkVm9HRLpUDcsSi
         btqdZtk3L+kRFv0jHeOkxsdklEe9voGateYVKY5fSKwXrml4JfiyBh/EBcKOYOJGVmtY
         AuDw==
X-Gm-Message-State: AOJu0Yy0VALo6QQpN0g+m1Zv5wGSNxZ4j5MDXjw2WYFJk2gePKgA8sAF
        6DM3OpHWCr4JaidiLP28SpCiz63+FPduj3m4pJo+mbHA1kiP
X-Google-Smtp-Source: AGHT+IEFMOLh1T2xs1astZ5dXqyIxaln1m/XHAlDreu7OlpLkCxeBGfc94pxv+l04VMdB8jR916vxEYBQbJu8sSh8qDP5euhEKFm
MIME-Version: 1.0
X-Received: by 2002:a63:9306:0:b0:570:275c:7431 with SMTP id
 b6-20020a639306000000b00570275c7431mr3244671pge.11.1693990008181; Wed, 06 Sep
 2023 01:46:48 -0700 (PDT)
Date:   Wed, 06 Sep 2023 01:46:48 -0700
In-Reply-To: <000000000000dfd6a105f71001d7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b0daee0604acc811@google.com>
Subject: Re: [syzbot] kernel BUG in ext4_write_inline_data
From:   syzbot <syzbot+f4582777a19ec422b517@syzkaller.appspotmail.com>
To:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nogikh@google.com, syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This bug is marked as fixed by commit:
ext4: fix race condition between buffer write and page_mkwrite

But I can't find it in the tested trees[1] for more than 90 days.
Is it a correct commit? Please update it by replying:

#syz fix: exact-commit-title

Until then the bug is still considered open and new crashes with
the same signature are ignored.

Kernel: Linux
Dashboard link: https://syzkaller.appspot.com/bug?extid=f4582777a19ec422b517

---
[1] I expect the commit to be present in:

1. for-kernelci branch of
git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git

2. master branch of
git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

3. master branch of
git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

4. main branch of
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git

The full list of 9 trees can be found at
https://syzkaller.appspot.com/upstream/repos
