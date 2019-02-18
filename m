Return-Path: <SRS0=geXL=QZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBCCAC00319
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Feb 2019 22:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1562217D9
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Feb 2019 22:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731602AbfBRWSZ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Feb 2019 17:18:25 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:46747 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731463AbfBRWSY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 18 Feb 2019 17:18:24 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail06.adl2.internode.on.net with ESMTP; 19 Feb 2019 08:48:21 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gvrEy-000441-9x; Tue, 19 Feb 2019 09:18:20 +1100
Date:   Tue, 19 Feb 2019 09:18:20 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Omar Sandoval <osandov@osandov.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, kernel-team@fb.com,
        Linux API <linux-api@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-xfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Steve French <sfrench@samba.org>
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Message-ID: <20190218221820.GF14116@dastard>
References: <cover.1550136164.git.osandov@fb.com>
 <20190214220626.GV14116@dastard>
 <20190214231429.GE9819@vader>
 <20190215001657.GY14116@dastard>
 <20190215065947.GG9819@vader>
 <72A04438-5991-4A60-8AAB-021A41DE6711@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72A04438-5991-4A60-8AAB-021A41DE6711@dilger.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Feb 16, 2019 at 06:57:45PM -0700, Andreas Dilger wrote:
> While it may be a bit of a stretch to call this "forensic evidence", making

We do forensic analysis of corrupt filesystems looking for evidence
of what went wrong, not just looking for evidence of what happened
on systems that have been broken into.

> it hard to change from except via total root compromise by a skilled hacker
> is very useful.

*nod*.

> If this were to go in (which I'm not in favour of), then there would need to
> be a CONFIG and/or runtime knob to turn it off (or better to only turn it on),
> similar to how FIPS and other security options can only go in one direction.

The problem here is that "inode birth time" is being conflated with
"user document creation time". These two things are very different.

i.e. One is filesystem internal information and is not related to
when the original copy of the data in the file was created, the
other is user specified metadata that is related to the file data
contents and needs to travel with the data, not the filesystem.

IMO, trying to make one on-disk field hold two different types of
information defeats one or the other purpose, and nobody knows which
one the field stores for any given file.

I'd suggest that "authored date" should be a generic system xattr so
most filesystems support it, not just those that have a birth time
field on disk. Sure, modify it through utimesat() and expose it
through statx() (as authored time, not birth time), but store it a
system xattr rather than an internal filesystem metadata field that
requires was never intended to be user modifiable.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
