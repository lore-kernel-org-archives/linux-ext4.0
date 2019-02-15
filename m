Return-Path: <SRS0=7ymp=QW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 420CDC4360F
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Feb 2019 17:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19B922190C
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Feb 2019 17:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbfBOROT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 15 Feb 2019 12:14:19 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45438 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728814AbfBOROT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Feb 2019 12:14:19 -0500
Received: by mail-pf1-f193.google.com with SMTP id v21so2118070pfm.12;
        Fri, 15 Feb 2019 09:14:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V5tWVBuDkxTrLw/rJUGUbWNUGeClHnQKAfjUPFO5WHE=;
        b=W70s2Smoiv7hI9AhEickGH6xa/TkeOEB/bmYNrS5IBsfMmdMYgnZYoKQ5oc+sKyeT9
         9eWx1D7LFav+OvT7Up46ro38LM6xyC/nn5ecuRzOCIPqkdvRCjV+KmdKU4o9/5FRz3CW
         mTQfe58elpVgmgYAqrjT0yQaE08ro8q/qgzztj2trvxXSoFe3g4ABU/YORqeL7tl7nEj
         rxLz0G/nqodXz9/i6soHqCB2G0sRelwy5XOgtk0n2n+7/i41pzhWcC1sXliU0L8Cepzt
         FQsF8Vh/B6Cu2BPqJdWx4Hfot77D31w1pFExiOg6IZF/3Wyc/xn6/huhkwV3auP68yR9
         corg==
X-Gm-Message-State: AHQUAubuAYcUjC7ubuqV0W0jQjrUH8qLkBllNDki3LgrntV74kbY7+fY
        BInc5ea+TKWUq/y/veObytQ=
X-Google-Smtp-Source: AHgI3IakANE5EyG398yqtL0es6DsKhHFktstbAeHxhopwBULRdY+290B+ab/EnoU457BzmwQyumWvw==
X-Received: by 2002:aa7:8508:: with SMTP id v8mr10806465pfn.14.1550250857939;
        Fri, 15 Feb 2019 09:14:17 -0800 (PST)
Received: from ?IPv6:2620:15c:2cd:203:5cdc:422c:7b28:ebb5? ([2620:15c:2cd:203:5cdc:422c:7b28:ebb5])
        by smtp.gmail.com with ESMTPSA id e123sm14502265pgc.14.2019.02.15.09.14.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Feb 2019 09:14:16 -0800 (PST)
Message-ID: <1550250855.31902.102.camel@acm.org>
Subject: Re: [dm-devel] [PATCH V15 00/18] block: support multi-page bvec
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc:     Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
        dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Omar Sandoval <osandov@fb.com>, cluster-devel@redhat.com,
        linux-ext4@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Boaz Harrosh <ooo@electrozaur.com>,
        Gao Xiang <gaoxiang25@huawei.com>, Coly Li <colyli@suse.de>,
        linux-raid@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        linux-bcache@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <dchinner@redhat.com>,
        David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Date:   Fri, 15 Feb 2019 09:14:15 -0800
In-Reply-To: <c52b6a8b-d1d4-67ff-f81c-371d09cc6d5b@kernel.dk>
References: <20190215111324.30129-1-ming.lei@redhat.com>
         <c52b6a8b-d1d4-67ff-f81c-371d09cc6d5b@kernel.dk>
Content-Type: text/plain; charset="UTF-7"
X-Mailer: Evolution 3.26.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, 2019-02-15 at 08:49 -0700, Jens Axboe wrote:
+AD4 On 2/15/19 4:13 AM, Ming Lei wrote:
+AD4 +AD4 This patchset brings multi-page bvec into block layer:
+AD4 
+AD4 Applied, thanks Ming. Let's hope it sticks+ACE

Hi Jens and Ming,

Test nvmeof-mp/002 fails with Jens' for-next branch from this morning.
I have not yet tried to figure out which patch introduced the failure.
Anyway, this is what I see in the kernel log for test nvmeof-mp/002:

+AFs  475.611363+AF0 BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
+AFs  475.621188+AF0 +ACM-PF error: +AFs-normal kernel read fault+AF0
+AFs  475.623148+AF0 PGD 0 P4D 0  
+AFs  475.624737+AF0 Oops: 0000 +AFsAIw-1+AF0 PREEMPT SMP KASAN
+AFs  475.626628+AF0 CPU: 1 PID: 277 Comm: kworker/1:1H Tainted: G    B             5.0.0-rc6-dbg+- +ACM-1
+AFs  475.630232+AF0 Hardware name: QEMU Standard PC (i440FX +- PIIX, 1996), BIOS 1.10.2-1 04/01/2014
+AFs  475.633855+AF0 Workqueue: kblockd blk+AF8-mq+AF8-requeue+AF8-work
+AFs  475.635777+AF0 RIP: 0010:+AF8AXw-blk+AF8-recalc+AF8-rq+AF8-segments+-0xbe/0x590
+AFs  475.670948+AF0 Call Trace:
+AFs  475.693515+AF0  blk+AF8-recalc+AF8-rq+AF8-segments+-0x2f/0x50
+AFs  475.695081+AF0  blk+AF8-insert+AF8-cloned+AF8-request+-0xbb/0x1c0
+AFs  475.701142+AF0  dm+AF8-mq+AF8-queue+AF8-rq+-0x3d1/0x770
+AFs  475.707225+AF0  blk+AF8-mq+AF8-dispatch+AF8-rq+AF8-list+-0x5fc/0xb10
+AFs  475.717137+AF0  blk+AF8-mq+AF8-sched+AF8-dispatch+AF8-requests+-0x256/0x300
+AFs  475.721767+AF0  +AF8AXw-blk+AF8-mq+AF8-run+AF8-hw+AF8-queue+-0xd6/0x180
+AFs  475.725920+AF0  +AF8AXw-blk+AF8-mq+AF8-delay+AF8-run+AF8-hw+AF8-queue+-0x25c/0x290
+AFs  475.727480+AF0  blk+AF8-mq+AF8-run+AF8-hw+AF8-queue+-0x119/0x1b0
+AFs  475.732019+AF0  blk+AF8-mq+AF8-run+AF8-hw+AF8-queues+-0x7b/0xa0
+AFs  475.733468+AF0  blk+AF8-mq+AF8-requeue+AF8-work+-0x2cb/0x300
+AFs  475.736473+AF0  process+AF8-one+AF8-work+-0x4f1/0xa40
+AFs  475.739424+AF0  worker+AF8-thread+-0x67/0x5b0
+AFs  475.741751+AF0  kthread+-0x1cf/0x1f0
+AFs  475.746034+AF0  ret+AF8-from+AF8-fork+-0x24/0x30

(gdb) list +ACo(+AF8AXw-blk+AF8-recalc+AF8-rq+AF8-segments+-0xbe)
0xffffffff816a152e is in +AF8AXw-blk+AF8-recalc+AF8-rq+AF8-segments (block/blk-merge.c:366).
361                                                  struct bio +ACo-bio)
362     +AHs
363             struct bio+AF8-vec bv, bvprv +AD0 +AHs NULL +AH0AOw
364             int prev +AD0 0+ADs
365             unsigned int seg+AF8-size, nr+AF8-phys+AF8-segs+ADs
366             unsigned front+AF8-seg+AF8-size +AD0 bio-+AD4-bi+AF8-seg+AF8-front+AF8-size+ADs
367             struct bio +ACo-fbio, +ACo-bbio+ADs
368             struct bvec+AF8-iter iter+ADs
369
370             if (+ACE-bio)

Bart.
