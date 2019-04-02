Return-Path: <SRS0=Vv4O=SE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E027EC10F00
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 20:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC7EA2084C
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 20:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbfDBUfN (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 2 Apr 2019 16:35:13 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:44492 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725812AbfDBUfN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Apr 2019 16:35:13 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail06.adl2.internode.on.net with ESMTP; 03 Apr 2019 07:05:09 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1hBQ7g-0006k1-88; Wed, 03 Apr 2019 07:35:08 +1100
Date:   Wed, 3 Apr 2019 07:35:08 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        axboe@fb.com, prakash.v@samsung.com, anshul@samsung.com,
        joshiiitr@gmail.com
Subject: Re: [PATCH v3 3/7] block: add write-hint to stream-id conversion
Message-ID: <20190402203508.GT26298@dastard>
References: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
 <CGME20190329075749epcas2p22b85cbdbb7ccb4f7f3ecf69b84f75dc9@epcas2p2.samsung.com>
 <1553846032-4451-4-git-send-email-joshi.k@samsung.com>
 <20190401050821.GQ23020@dastard>
 <20190402092044.GE12133@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402092044.GE12133@quack2.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 02, 2019 at 11:20:44AM +0200, Jan Kara wrote:
> On Mon 01-04-19 16:08:21, Dave Chinner wrote:
> > On Fri, Mar 29, 2019 at 01:23:48PM +0530, Kanchan Joshi wrote:
> > > +		if(streamid > nr_streams)
> > > +			streamid = 0;
> > 
> > So, basically, we'll compress all the kernel hints down to "no hint"
> > if there are more user streams than the device supports?
> > 
> > Surely we should be reserving a stream for the kernel hints separate
> > from the user and "none" streams when we have limited device streams
> > available...
> 
> The question is what to do in a situation when the device has exactly as
> many hints as we currently offer to userspace.

Then do what we do now for that case. For every other case, the
kernel should have reserved space and not get intermingled with
userspace hints.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
