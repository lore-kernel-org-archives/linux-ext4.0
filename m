Return-Path: <SRS0=7ymp=QW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20CC6C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Feb 2019 15:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E07CD2192D
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Feb 2019 15:49:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="h9OUIip/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387795AbfBOPtg (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 15 Feb 2019 10:49:36 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:55169 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731704AbfBOPtg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Feb 2019 10:49:36 -0500
Received: by mail-it1-f194.google.com with SMTP id f10so1579910ita.4
        for <linux-ext4@vger.kernel.org>; Fri, 15 Feb 2019 07:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gxvfq5TL/2HmGfmAumLfCM1Ftb4XqCEsXRfcSZF+1T0=;
        b=h9OUIip/xw+IU3EFOgAuJ2mEtH+VQuLeB4N2O2e5L27iYvYrtP6ekFwJsYUVSR8Bs1
         V392XnrQeNAUy7rzEK5X9RjrKX8vmLHjqRiG5HONgjRm2+fOgE6f7wJuvX6QtuzsWOdF
         MfkNy1spvU8KVAOhzx2gB7lsHkND6yni833wB9wMTVzynMNMNsVhVjpfEHZ2/3qGsz9D
         rXvPlMf1e6MpwVMTBVf+gHJWXTWyumwVlENzGzRya5qqopY95rsZqVKBmvI+tskX1FeI
         khsRD7p9S2INbR0YIRanHv6C+VCXUUdEVjlIFSQ4S3sSSa7xj2Un1EU661Qgk61bbUHy
         K1+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gxvfq5TL/2HmGfmAumLfCM1Ftb4XqCEsXRfcSZF+1T0=;
        b=E5fO+HyG+chNwrK424qMd3wiveK7G5lWb1hgd1S4toJKYvALqTQ9f09VLEPY8tuqz5
         jBaSgC/DVtyVKJ7EKLTFA6Fl23DSn125DbarbU+OREDMvnMzkdRMdysjLthQAy4m5/52
         GdfN4FrqjPSWiWusOlcjuZ4/7nbuCoP3ikWS8LVYg8iSv0kZCAWO9vuycj2G7Sx/ww7v
         7shW2n4J2Q01oKz/d23TpP3nz+M6tkugcDJ03PsNF6o+l3nZNYiYu3T7CVoo7rBVy1h1
         7jVTuW93YSVF5YnsI344L+NBL3JWOEvfb+vog8EnPIJvmwfelu2uPynMN6VpbzddPFvu
         PjmA==
X-Gm-Message-State: AHQUAuYfQm7y7jJv6DAa3YC0POqDzSDqtmyhfOlOFLbBlvhrksqzetWk
        ScSeu4pM5ttoMi+6cyvfArALpQ==
X-Google-Smtp-Source: AHgI3IaV0Q9G5s5V1+OIQRz7sTqwSOWc1UGhJpRZNN56AkN2+6GPnd9+jvWg/bVCGoDtKm+mPdu3Pg==
X-Received: by 2002:a02:984d:: with SMTP id x13mr4966711jaj.140.1550245774598;
        Fri, 15 Feb 2019 07:49:34 -0800 (PST)
Received: from [192.168.1.158] ([216.160.245.98])
        by smtp.gmail.com with ESMTPSA id w186sm2639569itb.15.2019.02.15.07.49.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Feb 2019 07:49:33 -0800 (PST)
Subject: Re: [PATCH V15 00/18] block: support multi-page bvec
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>,
        Omar Sandoval <osandov@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
References: <20190215111324.30129-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c52b6a8b-d1d4-67ff-f81c-371d09cc6d5b@kernel.dk>
Date:   Fri, 15 Feb 2019 08:49:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190215111324.30129-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 2/15/19 4:13 AM, Ming Lei wrote:
> Hi,
> 
> This patchset brings multi-page bvec into block layer:
> 
> 1) what is multi-page bvec?
> 
> Multipage bvecs means that one 'struct bio_bvec' can hold multiple pages
> which are physically contiguous instead of one single page used in linux
> kernel for long time.
> 
> 2) why is multi-page bvec introduced?
> 
> Kent proposed the idea[1] first. 
> 
> As system's RAM becomes much bigger than before, and huge page, transparent
> huge page and memory compaction are widely used, it is a bit easy now
> to see physically contiguous pages from fs in I/O. On the other hand, from
> block layer's view, it isn't necessary to store intermediate pages into bvec,
> and it is enough to just store the physicallly contiguous 'segment' in each
> io vector.
> 
> Also huge pages are being brought to filesystem and swap [2][6], we can
> do IO on a hugepage each time[3], which requires that one bio can transfer
> at least one huge page one time. Turns out it isn't flexiable to change
> BIO_MAX_PAGES simply[3][5]. Multipage bvec can fit in this case very well.
> As we saw, if CONFIG_THP_SWAP is enabled, BIO_MAX_PAGES can be configured
> as much bigger, such as 512, which requires at least two 4K pages for holding
> the bvec table.
> 
> With multi-page bvec:
> 
> - Inside block layer, both bio splitting and sg map can become more
> efficient than before by just traversing the physically contiguous
> 'segment' instead of each page.
> 
> - segment handling in block layer can be improved much in future since it
> should be quite easy to convert multipage bvec into segment easily. For
> example, we might just store segment in each bvec directly in future.
> 
> - bio size can be increased and it should improve some high-bandwidth IO
> case in theory[4].
> 
> - there is opportunity in future to improve memory footprint of bvecs. 
> 
> 3) how is multi-page bvec implemented in this patchset?
> 
> Patch 1 ~ 3 parpares for supporting multi-page bvec. 
> 
> Patches 4 ~ 14 implement multipage bvec in block layer:
> 
> 	- put all tricks into bvec/bio/rq iterators, and as far as
> 	drivers and fs use these standard iterators, they are happy
> 	with multipage bvec
> 
> 	- introduce bio_for_each_bvec() to iterate over multipage bvec for splitting
> 	bio and mapping sg
> 
> 	- keep current bio_for_each_segment*() to itereate over singlepage bvec and
> 	make sure current users won't be broken; especailly, convert to this
> 	new helper prototype in single patch 21 given it is bascially a mechanism
> 	conversion
> 
> 	- deal with iomap & xfs's sub-pagesize io vec in patch 13
> 
> 	- enalbe multipage bvec in patch 14 
> 
> Patch 15 redefines BIO_MAX_PAGES as 256.
> 
> Patch 16 documents usages of bio iterator helpers.
> 
> Patch 17~18 kills NO_SG_MERGE.
> 
> These patches can be found in the following git tree:
> 
> 	git:  https://github.com/ming1/linux.git  v5.0-blk_mp_bvec_v14
                                                                   ^^^

v15?

> Lots of test(blktest, xfstests, ltp io, ...) have been run with this patchset,
> and not see regression.
> 
> Thanks Christoph for reviewing the early version and providing very good
> suggestions, such as: introduce bio_init_with_vec_table(), remove another
> unnecessary helpers for cleanup and so on.
> 
> Thanks Chritoph and Omar for reviewing V10/V11/V12, and provides lots of
> helpful comments.

Applied, thanks Ming. Let's hope it sticks!

-- 
Jens Axboe

