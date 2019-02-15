Return-Path: <SRS0=7ymp=QW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA13C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Feb 2019 09:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54CB02070D
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Feb 2019 09:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391584AbfBOJuL (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 15 Feb 2019 04:50:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42054 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390930AbfBOJuL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 15 Feb 2019 04:50:11 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 16F8FAAA9B;
        Fri, 15 Feb 2019 09:50:11 +0000 (UTC)
Received: from localhost.localdomain (ovpn-204-161.brq.redhat.com [10.40.204.161])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AED1600C1;
        Fri, 15 Feb 2019 09:50:09 +0000 (UTC)
Date:   Fri, 15 Feb 2019 10:50:07 +0100
From:   Lukas Czerner <lczerner@redhat.com>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] libext2fs: revert "try to always use PUNCH_HOLE for
 unix_discard"
Message-ID: <20190215095007.jx5ol3ss7uhegz3z@localhost.localdomain>
References: <20190114233708.GA20465@magnolia>
 <20190214210448.GE7387@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190214210448.GE7387@mit.edu>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 15 Feb 2019 09:50:11 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Feb 14, 2019 at 04:04:48PM -0500, Theodore Y. Ts'o wrote:
> On Mon, Jan 14, 2019 at 03:37:08PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Revert bcca9876a3428c10417c660b78933e6e70e8a5f5, because
> > fallocate(PUNCH_HOLE) on block devices was changed to use zeroout
> > instead of discard shortly after block device fallocate was merged.
> > zeroout isn't necessarily a "drop storage" operation like discard is,
> > so we prefer to use that on block devices.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Thanks, applied.
> 
> 					- Ted

I just noticed this patch, sorry. I think we can still use fallocate,
but we need to set the right flags to make sure it uses discard instead
of zeroout. See fs/block_dev.c

	switch (mode) {
	case FALLOC_FL_ZERO_RANGE:
	case FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE:
		error = blkdev_issue_zeroout(bdev, start >> 9, len >> 9,
					    GFP_KERNEL, BLKDEV_ZERO_NOUNMAP);
		break;
	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE:
		error = blkdev_issue_zeroout(bdev, start >> 9, len >> 9,
					     GFP_KERNEL, BLKDEV_ZERO_NOFALLBACK);
		break;
	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE | FALLOC_FL_NO_HIDE_STALE:
		error = blkdev_issue_discard(bdev, start >> 9, len >> 9,
					     GFP_KERNEL, 0);
		break;
	default:
		return -EOPNOTSUPP;
	}

So if we want a discard (meaning we want to unallocate the blocks
without necessarily making sure we can't read stale data from it) we
have to use FALLOC_FL_NO_HIDE_STALE.

So the flags would be FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE | FALLOC_FL_NO_HIDE_STALE

Ted, Darrick what do you think ? Can we keep the
bcca9876a3428c10417c660b78933e6e70e8a5f5 commit and just change the
flags ?

-Lukas
