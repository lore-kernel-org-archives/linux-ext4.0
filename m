Return-Path: <SRS0=Ozrj=P6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA62C37155
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Jan 2019 02:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EA7120870
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Jan 2019 02:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfAVCCJ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 21 Jan 2019 21:02:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57730 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726601AbfAVCCI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 21 Jan 2019 21:02:08 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D1A6BD2EE5;
        Tue, 22 Jan 2019 02:02:07 +0000 (UTC)
Received: from ming.t460p (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D6F65D736;
        Tue, 22 Jan 2019 02:01:37 +0000 (UTC)
Date:   Tue, 22 Jan 2019 10:01:30 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>,
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
Subject: Re: [PATCH V14 00/18] block: support multi-page bvec
Message-ID: <20190122020128.GB2490@ming.t460p>
References: <20190121081805.32727-1-ming.lei@redhat.com>
 <61dfaa1e-e7bf-75f1-410b-ed32f97d0782@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61dfaa1e-e7bf-75f1-410b-ed32f97d0782@grimberg.me>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 22 Jan 2019 02:02:08 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jan 21, 2019 at 01:43:21AM -0800, Sagi Grimberg wrote:
> 
> > V14:
> > 	- drop patch(patch 4 in V13) for renaming bvec helpers, as suggested by Jens
> > 	- use mp_bvec_* as multi-page bvec helper name
> > 	- fix one build issue, which is caused by missing one converion of
> > 	bio_for_each_segment_all in fs/gfs2
> > 	- fix one 32bit ARCH specific issue caused by segment boundary mask
> > 	overflow
> 
> Hey Ming,
> 
> So is nvme-tcp also affected here? The only point where I see nvme-tcp
> can be affected is when initializing a bvec iter using bio_segments() as
> everywhere else we use iters which should transparently work..
> 
> I see that loop was converted, does it mean that nvme-tcp needs to
> call something like?
> --
> 	bio_for_each_mp_bvec(bv, bio, iter)
> 		nr_bvecs++;

bio_for_each_segment()/bio_segments() still works, just not as efficient
as bio_for_each_mp_bvec() given each multi-page bvec(very similar with scatterlist)
is returned in each loop.

I don't look at nvme-tcp code yet. But if nvme-tcp supports this way,
it can benefit from bio_for_each_mp_bvec().

Thanks,
Ming
