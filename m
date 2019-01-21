Return-Path: <SRS0=MuWy=P5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FFF2C282F6
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Jan 2019 08:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 609CA20861
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Jan 2019 08:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbfAUIkr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 21 Jan 2019 03:40:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46214 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728085AbfAUIkr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 21 Jan 2019 03:40:47 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 888A083F42;
        Mon, 21 Jan 2019 08:40:46 +0000 (UTC)
Received: from ming.t460p (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 83CA110027CE;
        Mon, 21 Jan 2019 08:40:24 +0000 (UTC)
Date:   Mon, 21 Jan 2019 16:40:19 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH V14 00/18] block: support multi-page bvec
Message-ID: <20190121084018.GB29495@ming.t460p>
References: <20190121081805.32727-1-ming.lei@redhat.com>
 <20190121082246.GA18305@lst.de>
 <20190121083711.GA29495@ming.t460p>
 <20190121083810.GA18648@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190121083810.GA18648@lst.de>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Mon, 21 Jan 2019 08:40:47 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jan 21, 2019 at 09:38:10AM +0100, Christoph Hellwig wrote:
> On Mon, Jan 21, 2019 at 04:37:12PM +0800, Ming Lei wrote:
> > On Mon, Jan 21, 2019 at 09:22:46AM +0100, Christoph Hellwig wrote:
> > > On Mon, Jan 21, 2019 at 04:17:47PM +0800, Ming Lei wrote:
> > > > V14:
> > > > 	- drop patch(patch 4 in V13) for renaming bvec helpers, as suggested by Jens
> > > > 	- use mp_bvec_* as multi-page bvec helper name
> > > 
> > > WTF?  Where is this coming from?  mp is just a nightmare of a name,
> > > and I also didn't see any comments like that.
> > 
> > You should see the recent discussion in which Jens doesn't agree on
> > renaming bvec helper name, so the previous patch of 'block: rename bvec helpers'
> 
> Where is that discussion?

https://marc.info/?l=linux-next&m=154777954232109&w=2


Thanks,
Ming
