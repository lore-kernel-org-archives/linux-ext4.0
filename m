Return-Path: <SRS0=MuWy=P5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E00FC282F6
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Jan 2019 09:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 285102085A
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Jan 2019 09:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbfAUJn1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 21 Jan 2019 04:43:27 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36464 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbfAUJnZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jan 2019 04:43:25 -0500
Received: by mail-pf1-f195.google.com with SMTP id b85so9885740pfc.3;
        Mon, 21 Jan 2019 01:43:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ctU1IKwGbIHB/qxu9fzPzOndQlgD5hRgjY4uIUshvTY=;
        b=ZK+UNms6mWgpgYjstaV6ModqemMUmQxaMqmV75D1o0PWBNhJ1ERHGGBTg05ZaCgJ1z
         PPWFV/dVoSiGzmWP0syRm0T+UT00+K66DhbfI80VhqDokvLpAMT+40s8LHYAeKj5Dlwb
         RR2xmxUmnl45nZVuH0dvvPyLQ6nTUpjetwyNH8w6rTniN+bD8dGM1Mkf30t6d1UCXdcG
         b/2Vsx/XL7yP7IOPi6/a0qBSb9tEVLGXQGxFdRVRrs23Hyg8ZpjLX7zC0blpxqTvgD53
         5W60hYH3cqML5PuhrQrJr0l/5hpiPDhNescn+1qH+xweircgonV5DhJbmpdLNiVaMlyQ
         FEZg==
X-Gm-Message-State: AJcUukdE5XGmtUfansUIM42/82WAyX9/ByrDfNORjQyGxuP5EJ4Bwv/E
        IEbW5diaW8azqW4naizolXs=
X-Google-Smtp-Source: ALg8bN6P7/Ncr76xD/uxTtsl2LRvnNdrOYt8IlcTvDVHidHRO2no14YHVCiCcwzatwkiVv+sBDrECA==
X-Received: by 2002:a62:5b83:: with SMTP id p125mr29320606pfb.116.1548063803783;
        Mon, 21 Jan 2019 01:43:23 -0800 (PST)
Received: from ?IPv6:2601:647:4800:973f:749d:e9f0:491e:d7d5? ([2601:647:4800:973f:749d:e9f0:491e:d7d5])
        by smtp.gmail.com with ESMTPSA id m198sm21820819pga.10.2019.01.21.01.43.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 01:43:23 -0800 (PST)
Subject: Re: [PATCH V14 00/18] block: support multi-page bvec
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>,
        Omar Sandoval <osandov@fb.com>,
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
References: <20190121081805.32727-1-ming.lei@redhat.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <61dfaa1e-e7bf-75f1-410b-ed32f97d0782@grimberg.me>
Date:   Mon, 21 Jan 2019 01:43:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190121081805.32727-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


> V14:
> 	- drop patch(patch 4 in V13) for renaming bvec helpers, as suggested by Jens
> 	- use mp_bvec_* as multi-page bvec helper name
> 	- fix one build issue, which is caused by missing one converion of
> 	bio_for_each_segment_all in fs/gfs2
> 	- fix one 32bit ARCH specific issue caused by segment boundary mask
> 	overflow

Hey Ming,

So is nvme-tcp also affected here? The only point where I see nvme-tcp
can be affected is when initializing a bvec iter using bio_segments() as
everywhere else we use iters which should transparently work..

I see that loop was converted, does it mean that nvme-tcp needs to
call something like?
--
	bio_for_each_mp_bvec(bv, bio, iter)
		nr_bvecs++;
--
