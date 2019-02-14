Return-Path: <SRS0=5TFS=QV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7395FC10F04
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 22:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EC6621B1C
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 22:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391475AbfBNWGm (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Feb 2019 17:06:42 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:31538 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388020AbfBNWGm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 14 Feb 2019 17:06:42 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail06.adl6.internode.on.net with ESMTP; 15 Feb 2019 08:36:28 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1guP9G-0006jR-HC; Fri, 15 Feb 2019 09:06:26 +1100
Date:   Fri, 15 Feb 2019 09:06:26 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        kernel-team@fb.com, linux-api@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Message-ID: <20190214220626.GV14116@dastard>
References: <cover.1550136164.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1550136164.git.osandov@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Feb 14, 2019 at 02:00:07AM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Hi,
> 
> Since statx was added in 4.11, userspace has had an interface for
> reading btime (file creation time), but no way to set it. This RFC patch
> series adds support for changing btime with utimensat(). Patch 1 adds
> the VFS infrastructure, patch 2 adds the support to utimensat() with a
> new flag, and the rest of the patches add filesystem support; I excluded
> CIFS for now because I don't have a CIFS setup to test it on.
> 
> Updating btime is useful for at least a couple of use cases:
> 
> - Backup/restore programs (my motivation for this feature is btrfs send)
> - File servers which interoperate with operating systems that allow
>   updating file creation time, including Mac OS [1] and Windows [2]

So you're adding an interface that allows users to change the create
time of files without needing any privileges?

Inode create time is forensic metadata in XFS  - information we use
for sequence of event and inode lifetime analysis during examination
of broken filesystem images and systems that have been broken into.
Just because it's exposed to userspace via statx(), it doesn't mean
that it is information that users should be allowed to change. i.e.
allowing users to be able to change the create time on files makes
it completely useless for the purpose it was added to XFS for...

And allowing root to change the create time doesn't really help,
because once you've broken into a system, this makes it really easy
to cover tracks (e.g. we can't find files that were created and
unlinked during the break in window anymore) and lay false
trails....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
