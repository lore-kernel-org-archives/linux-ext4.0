Return-Path: <SRS0=V5lK=QY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D87C10F06
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Feb 2019 21:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43500218A6
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Feb 2019 21:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfBQVJx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 17 Feb 2019 16:09:53 -0500
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:25487 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726228AbfBQVJw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 17 Feb 2019 16:09:52 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail01.adl2.internode.on.net with ESMTP; 18 Feb 2019 07:39:48 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gvTh6-0002Vi-8J; Mon, 18 Feb 2019 08:09:48 +1100
Date:   Mon, 18 Feb 2019 08:09:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Ric Wheeler <ricwheeler@gmail.com>
Cc:     lsf-pc@lists.linux-foundation.org,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-block@vger.kernel.org
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async
 discard?
Message-ID: <20190217210948.GB14116@dastard>
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Feb 17, 2019 at 03:36:10PM -0500, Ric Wheeler wrote:
> One proposal for btrfs was that we should look at getting discard
> out of the synchronous path in order to minimize the slowdown
> associated with enabling discard at mount time. Seems like an
> obvious win for "hint" like operations like discard.

We already have support for that. blkdev_issue_discard() is
synchornous, yes, but __blkdev_issue_discard() will only build the
discard bio chain - it is up to the caller to submit and wait for it.

Some callers (XFS, dm-thinp, nvmet, etc) use a bio completion to
handle the discard IO completion, hence allowing async dispatch and
processing of the discard chain without blocking the caller. Others
(like ext4) simply call submit_bio_wait() to do wait synchronously
on completion of the discard bio chain.

> I do wonder where we stand now with the cost of the various discard
> commands - how painful is it for modern SSD's?

AIUI, it still depends on the SSD implementation, unfortunately.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
