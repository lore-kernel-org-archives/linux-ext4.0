Return-Path: <SRS0=L9HK=QH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F62C169C4
	for <linux-ext4@archiver.kernel.org>; Thu, 31 Jan 2019 03:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFA6520833
	for <linux-ext4@archiver.kernel.org>; Thu, 31 Jan 2019 03:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfAaDlK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 30 Jan 2019 22:41:10 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:51809 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbfAaDlK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 30 Jan 2019 22:41:10 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail06.adl2.internode.on.net with ESMTP; 31 Jan 2019 14:11:07 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gp3Du-000263-39; Thu, 31 Jan 2019 14:41:06 +1100
Date:   Thu, 31 Jan 2019 14:41:06 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Wang Shilong <wangshilong1991@gmail.com>
Cc:     linux-ext4@vger.kernel.org, linux-fs@vger.kernel.org,
        linux-xfs@vger.kernel.org, Wang Shilong <wshilong@ddn.com>,
        Andreas Dilger <adilger@dilger.ca>, Li Xi <lixi@ddn.com>
Subject: Re: [RFC PATCH] ext4: add link file support for {GET,SET}XATTR ioctl
Message-ID: <20190131034106.GJ4205@dastard>
References: <1548899232-30311-1-git-send-email-wshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1548899232-30311-1-git-send-email-wshilong1991@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jan 31, 2019 at 10:47:12AM +0900, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> Currently there is no way to change project ID of
> symlink file itself, this is important to implement
> Directory quota for an existed directory.

This seems like something open(O_PATH|O_NOFOLLOW) should allow.
from open(2):

	If pathname is a symbolic link and the O_NOFOLLOW flag is
	also specified, then the call returns a file  descriptor
	referring  to  the symbolic  link.  This  file  descriptor
	can  be used as the dirfd argument in calls to fchownat(2),
	fstatat(2), linkat(2), and read¿ linkat(2) with an empty
	pathname to have the calls operate on the symbolic link.

Changing the project id is the equivalent of fchownat().....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
