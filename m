Return-Path: <SRS0=87aU=RG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651DEC43381
	for <linux-ext4@archiver.kernel.org>; Sun,  3 Mar 2019 21:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C76E20842
	for <linux-ext4@archiver.kernel.org>; Sun,  3 Mar 2019 21:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbfCCVLN (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 3 Mar 2019 16:11:13 -0500
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:45204 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726626AbfCCVLN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Mar 2019 16:11:13 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail01.adl6.internode.on.net with ESMTP; 04 Mar 2019 07:41:03 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1h0YNy-0005SF-Lt; Mon, 04 Mar 2019 08:11:02 +1100
Date:   Mon, 4 Mar 2019 08:11:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Wang Shilong <wangshilong1991@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>
Subject: Re: [PATCH 0/8] add generic interface to set/get project
Message-ID: <20190303211102.GP23020@dastard>
References: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 01, 2019 at 11:05:33PM +0900, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> Currently, Filesystem use FS_IOC_FS_SETXATTR ioctl
> to change project ID of file. However we don't
> support ioctl on symlink files, and it is desirable
> to change symlink files' project ID just like uid/gid.
> 
> This patch try to reuse existed interface fchownat(),
> use group id to set project ID if flag AT_FCHOWN_PROJID
> passed in.
> 
> Also extend statx() calles to get symlink files' project
> ID and inherit attribute.

I'll mention the generic book-keeping stuff here:

- Series needs to be cc'd to linux-api@vger.kernel.org
- commit messages should be formatted similar to email. i.e. line
  wrap at 68-72 columns, not 50
- all of the patches have duplicate "From:" lines in the commit
  message.
- most of the patches are missing commit messages.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
