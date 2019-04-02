Return-Path: <SRS0=Vv4O=SE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3900DC10F00
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 09:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07A7920857
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 09:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbfDBJUr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 2 Apr 2019 05:20:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:47816 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728684AbfDBJUr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 2 Apr 2019 05:20:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C1DBDAB48;
        Tue,  2 Apr 2019 09:20:45 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id DF8721E42C7; Tue,  2 Apr 2019 11:20:44 +0200 (CEST)
Date:   Tue, 2 Apr 2019 11:20:44 +0200
From:   Jan Kara <jack@suse.cz>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        axboe@fb.com, prakash.v@samsung.com, anshul@samsung.com,
        joshiiitr@gmail.com
Subject: Re: [PATCH v3 3/7] block: add write-hint to stream-id conversion
Message-ID: <20190402092044.GE12133@quack2.suse.cz>
References: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
 <CGME20190329075749epcas2p22b85cbdbb7ccb4f7f3ecf69b84f75dc9@epcas2p2.samsung.com>
 <1553846032-4451-4-git-send-email-joshi.k@samsung.com>
 <20190401050821.GQ23020@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190401050821.GQ23020@dastard>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon 01-04-19 16:08:21, Dave Chinner wrote:
> On Fri, Mar 29, 2019 at 01:23:48PM +0530, Kanchan Joshi wrote:
> > +		if(streamid > nr_streams)
> > +			streamid = 0;
> 
> So, basically, we'll compress all the kernel hints down to "no hint"
> if there are more user streams than the device supports?
> 
> Surely we should be reserving a stream for the kernel hints separate
> from the user and "none" streams when we have limited device streams
> available...

The question is what to do in a situation when the device has exactly as
many hints as we currently offer to userspace. Because currently either the
device has enough hints for all userspace hint values or we disable the
feature altogether. If we always mandated some hints are available for the
kernel, we'd have to regress some fuctionality currently available to
userspace. So I think that the option that the kernel won't get any hints
is the least painful solution. Later when people would like to extend hints
available to userspace, we could make sure kernel's batch of hints has
priority over these "extended userspace hints". 

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
