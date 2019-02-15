Return-Path: <SRS0=7ymp=QW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D81C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Feb 2019 07:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A57D921A80
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Feb 2019 07:00:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="r3NE2gFo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388977AbfBOG7v (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 15 Feb 2019 01:59:51 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43207 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388932AbfBOG7u (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Feb 2019 01:59:50 -0500
Received: by mail-pg1-f193.google.com with SMTP id v28so4346552pgk.10
        for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2019 22:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YCcb5SSZHkzkW25PRljIaPdIpR3yhI4lgcdw45uixuE=;
        b=r3NE2gFo4qoo63Nal3xKxUVquYkALyyef5ru/nJIBT15L2G5peQZXob5sSMreL1uyB
         lPcdZJWyY0y2yqIcwpyOyBUracwwjn69ITiXLY+M0jrD0nr5nbaI+5J4UICC/D1wDl6+
         YtaeY0zZVSPtNVM6zRxbWxdc4jNukJe87ZmAIFgQUV8xX0mgiqFnrXj/BfA3vIYpFid2
         86htNjS//N/kVkqh7cmjAuHdpWeoTesxtgyLPlBwJ0cvm78Rf/3umnvkwTl1Honrf/2a
         PmVFD0YENi6y7huY+U6WZGQBjeRxuuMBnw7INv/yGxPqQbqn/ZDLUesTTzRwMB/NRGMh
         DE9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YCcb5SSZHkzkW25PRljIaPdIpR3yhI4lgcdw45uixuE=;
        b=Z5sSWnbOz1IeOXjhWT9EsjSb2UjqBTORORcpOy40hb/aoL9pI2gwJMwKjGquhrIYvw
         XcBKFD+2vuhln+g3xtzKYmzulrLOYNQ6M3bScDoY6+5qZVcXKTfJI+j/bqZyNpkEmXP/
         Gbqud8VD0BjZtvE+M09JMS0Y9Pvz+R5RsW2t12ULjTGbUZ1ppYwi+TlkuXjxSfyNtoF0
         9MColzsDwrE4fj0WVq5rDiNIbnbX576k/NRvrm42WrFh0iU7vSW81/mCJv0+jd3fJe95
         ifslT5+CCqqG3kF7hAAlMqns3wtmzTziVQUG+LvU62WVQ9TCrqJ8/gSCJhCUve6XVmEn
         6Q5Q==
X-Gm-Message-State: AHQUAuYbY12UOF8M1sOl2vD17RbqUuxWAyS7p4frdY/xzD+ZZ+HR7QHp
        t94Oqh2fJcVg/pTmFUyYU9/SEw==
X-Google-Smtp-Source: AHgI3IZx+Rhrq+n91Wk9u1fAYcO8Kvmwu041R8kJXCdLwF7F2C0L4q8ZJ7hK9beGuadg+sqO6s51dA==
X-Received: by 2002:a62:36c1:: with SMTP id d184mr8385541pfa.242.1550213989231;
        Thu, 14 Feb 2019 22:59:49 -0800 (PST)
Received: from vader ([2601:602:8b00:55d3:e6a7:a0ff:fe0b:c9a8])
        by smtp.gmail.com with ESMTPSA id r80sm6577769pfa.111.2019.02.14.22.59.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Feb 2019 22:59:48 -0800 (PST)
Date:   Thu, 14 Feb 2019 22:59:47 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        kernel-team@fb.com, linux-api@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Steve French <sfrench@samba.org>
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Message-ID: <20190215065947.GG9819@vader>
References: <cover.1550136164.git.osandov@fb.com>
 <20190214220626.GV14116@dastard>
 <20190214231429.GE9819@vader>
 <20190215001657.GY14116@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190215001657.GY14116@dastard>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Feb 15, 2019 at 11:16:57AM +1100, Dave Chinner wrote:
> On Thu, Feb 14, 2019 at 03:14:29PM -0800, Omar Sandoval wrote:
> > On Fri, Feb 15, 2019 at 09:06:26AM +1100, Dave Chinner wrote:
> > > On Thu, Feb 14, 2019 at 02:00:07AM -0800, Omar Sandoval wrote:
> > > > From: Omar Sandoval <osandov@fb.com>
> > > > 
> > > > Hi,
> > > > 
> > > > Since statx was added in 4.11, userspace has had an interface for
> > > > reading btime (file creation time), but no way to set it. This RFC patch
> > > > series adds support for changing btime with utimensat(). Patch 1 adds
> > > > the VFS infrastructure, patch 2 adds the support to utimensat() with a
> > > > new flag, and the rest of the patches add filesystem support; I excluded
> > > > CIFS for now because I don't have a CIFS setup to test it on.
> > > > 
> > > > Updating btime is useful for at least a couple of use cases:
> > > > 
> > > > - Backup/restore programs (my motivation for this feature is btrfs send)
> > > > - File servers which interoperate with operating systems that allow
> > > >   updating file creation time, including Mac OS [1] and Windows [2]
> > > 
> > > So you're adding an interface that allows users to change the create
> > > time of files without needing any privileges?
> > 
> > I think it'd be reasonable to make this a privileged operation. I didn't
> > for this initial submission for a couple of reasons:
> > 
> > 1. The precedent on Mac OS and Windows is that this isn't a privileged
> >    operation.
> 
> Don't really care about them. Interop file servers that support these
> operations on other OSs will need to be storing this info in xattrs
> because they have to work on filesystems that don't support btime.
> 
> > 2. I knew there would be different opinions on this either way I went.
> 
> Yup.
> 
> > > Inode create time is forensic metadata in XFS  - information we use
> > > for sequence of event and inode lifetime analysis during examination
> > > of broken filesystem images and systems that have been broken into.
> > > Just because it's exposed to userspace via statx(), it doesn't mean
> > > that it is information that users should be allowed to change. i.e.
> > > allowing users to be able to change the create time on files makes
> > > it completely useless for the purpose it was added to XFS for...
> > > 
> > > And allowing root to change the create time doesn't really help,
> > > because once you've broken into a system, this makes it really easy
> > > to cover tracks
> > 
> > If the threat model is that the attacker has root, then they can
> > overwrite the timestamp on disk anyways, no?
> 
> Modifying the block devicee under an active filesystem is fraught
> with danger, and there's no guarantee it will work if the metadata
> being modified is still active in memory. Corrupting the filesystem
> is a sure way to get noticed....
> 
> > > (e.g. we can't find files that were created and
> > > unlinked during the break in window anymore) and lay false
> > > trails....
> > 
> > Fair point, although there's still ctime during the break-in window,
> 
> Unless you're smart enough to know how to trigger S_NOCMTIME or
> FMODE_NOCMTIME....
> 
> > which I assume you'd be looking for anyways since files modified during
> > the break-in window are also of interest.
> 
> ... and then that also can't be guaranteed. :/
> 
> > I see a few options, none of which are particularly nice:
> > 
> > 1. Filesystems like XFS could choose not to support setting btime even
> >    if they support reading it.
> > 2. XFS could add a second, writeable btime which is used for
> >    statx/utimes when available (it would fit in di_pad2...).
> > 3. We could add a btime_writable sysctl/mount option/mkfs option.
> 
> 4. create time remains a read-only field, and btrfs grows its own
> special interface to twiddle it in btrfs-recv if it really is
> necessary.

I'm curious to hear what the ext4/f2fs/CIFS developers think. If no one
else wants btime to be mutable, then I might as well make it
Btrfs-specific. That is, assuming we reach consensus on the Btrfs side
that btrfs receive should set btime.

> I'm still not convinced that even backup/restore should be doing this,
> because there's so much other metadata that is unique even on
> restored files that it doesn't really make any sense to me to lie
> about it being created in the past....

I suppose it depends on how you interpret btime: if it's strictly
filesystem metadata, then it makes sense that it should be immutable; if
it's metadata for the user's own purposes, then we should allow setting
it.
