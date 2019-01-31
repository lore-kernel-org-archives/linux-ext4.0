Return-Path: <SRS0=L9HK=QH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B59C282D9
	for <linux-ext4@archiver.kernel.org>; Thu, 31 Jan 2019 20:43:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22BA920881
	for <linux-ext4@archiver.kernel.org>; Thu, 31 Jan 2019 20:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbfAaUnH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 31 Jan 2019 15:43:07 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:64394 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725915AbfAaUnG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 31 Jan 2019 15:43:06 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail06.adl6.internode.on.net with ESMTP; 01 Feb 2019 07:13:03 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gpJAr-0003Af-9Y; Fri, 01 Feb 2019 07:43:01 +1100
Date:   Fri, 1 Feb 2019 07:43:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Wang Shilong <wangshilong1991@gmail.com>,
        linux-ext4@vger.kernel.org, linux-fs@vger.kernel.org,
        linux-xfs@vger.kernel.org, Wang Shilong <wshilong@ddn.com>,
        Andreas Dilger <adilger@dilger.ca>, Li Xi <lixi@ddn.com>
Subject: Re: [RFC PATCH] ext4: add link file support for {GET,SET}XATTR ioctl
Message-ID: <20190131204301.GK4205@dastard>
References: <1548899232-30311-1-git-send-email-wshilong1991@gmail.com>
 <20190131034106.GJ4205@dastard>
 <20190131174059.GA10211@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190131174059.GA10211@magnolia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jan 31, 2019 at 09:40:59AM -0800, Darrick J. Wong wrote:
> On Thu, Jan 31, 2019 at 02:41:06PM +1100, Dave Chinner wrote:
> > On Thu, Jan 31, 2019 at 10:47:12AM +0900, Wang Shilong wrote:
> > > From: Wang Shilong <wshilong@ddn.com>
> > > 
> > > Currently there is no way to change project ID of
> > > symlink file itself, this is important to implement
> > > Directory quota for an existed directory.
> > 
> > This seems like something open(O_PATH|O_NOFOLLOW) should allow.
> > from open(2):
> 
> ...but I thought O_PATH|O_NOFOLLOW file descriptions didn't allow ioctl
> calls?

It doesn't, and that is the problem here.

> > 	If pathname is a symbolic link and the O_NOFOLLOW flag is
> > 	also specified, then the call returns a file  descriptor
> > 	referring  to  the symbolic  link.  This  file  descriptor
> > 	can  be used as the dirfd argument in calls to fchownat(2),
> > 	fstatat(2), linkat(2), and read¿ linkat(2) with an empty
> > 	pathname to have the calls operate on the symbolic link.
> > 
> > Changing the project id is the equivalent of fchownat().....
> 
> /me & others wonder (on the ext4 call) if maybe we should promote
> project id to a vfs level concept? 

It already is - see include/linux/kprojid.h.

That was done for user namespaces, despite my objections that
project IDs aren't something that user namespaces should swizzle
because they are filesystem controlled IDs and the init namespace
needs to use them to control container directory space usage,
therefore they are not available for use in user namespaces
contexts.....

> i.e. store project id in struct
> inode instead of the fs-specific inode structures.  Then we can use the
> existing setattr infrastructure to persist those changes.

Makes no difference to me where they are stored - settattr has to
call into the filesystem anyway to change them (transactions!) so it
doesn't need to be in the struct inode, just in the struct iattr
that is passed to the filesystems.

> As for fchownat, how about a new flag that means "use the value in the
> gid field to set the project id"?

Kinda what I was thinking, so we don't need a whole new syscall.
Just limit that flag usage to the init namespace and we're all good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
