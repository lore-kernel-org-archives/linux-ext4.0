Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69787CE79AC
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Sep 2023 08:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233597AbjITIrb (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Sep 2023 04:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233535AbjITIra (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Sep 2023 04:47:30 -0400
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660E6C2
        for <linux-ext4@vger.kernel.org>; Wed, 20 Sep 2023 01:47:25 -0700 (PDT)
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-6bf001e729bso9108140a34.0
        for <linux-ext4@vger.kernel.org>; Wed, 20 Sep 2023 01:47:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695199644; x=1695804444;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DC68Fan9U1mDvvm9HS7/KL5cq/tCfXtYDl7pvERFoFo=;
        b=aTXLemGvSU/zZP8DtHWZOSKuIPe5VFWS+hIFH22QieGZKPg3SLvhn5xWS7gCgP4ktQ
         qcNzBKuUVgPhi2YnggGSFaPj3rpDINRaUr460Kvj+zYS54d34a7iMFasnGq5fLTuJDzx
         YrDBLz56pCEMre1BXIH87f/Op65Ooi2ACFL8uDuuOCKfegoY8fCr0ouvNhdJh+KppLVh
         U9HyrLzPoHf9VWu/hY68ROfcJnz5jTJJoGiZMM0q0MDGgx7HjY+H0D1mVGeh2UjQQbzL
         qxIUq2GGl8wUAjCz9U9/3N9xxhN2B5BZACh0LisuoHdZqwRqWRt1suotOdwasgei7KSM
         jdjw==
X-Gm-Message-State: AOJu0YzIipVbYZcHRjd7VeAQY7tYGWmaQB1V7d5ndJZk1Qjq0DJHXZN1
        dRlXX+hLwcEqcvLBgoC5UkUrwmknybp/sqAQgamB/3V+yRQb
X-Google-Smtp-Source: AGHT+IFYvU19CpGa7Sw8FeaKksspIk2gdk0wHVOg44SWeKSJgHOrmyuVpkSdrfe3P9Ukwk210+icYgW8ipwzEsG3vBbaHOIWDvS/
MIME-Version: 1.0
X-Received: by 2002:a05:6808:19a2:b0:3a7:75cd:df40 with SMTP id
 bj34-20020a05680819a200b003a775cddf40mr920966oib.7.1695199644793; Wed, 20 Sep
 2023 01:47:24 -0700 (PDT)
Date:   Wed, 20 Sep 2023 01:47:24 -0700
In-Reply-To: <000000000000dfd6a105f71001d7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a6cc1f0605c66c04@google.com>
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
