Return-Path: <SRS0=rve6=Q5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2183C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Feb 2019 15:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83DC4206A3
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Feb 2019 15:01:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfBVPBL (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 22 Feb 2019 10:01:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:36636 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725887AbfBVPBL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 22 Feb 2019 10:01:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 85FEBAD78;
        Fri, 22 Feb 2019 15:01:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 14C7CDAA56; Fri, 22 Feb 2019 16:02:28 +0100 (CET)
Date:   Fri, 22 Feb 2019 16:02:27 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        kernel-team@fb.com, linux-api@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Message-ID: <20190222150227.GF9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        kernel-team@fb.com, linux-api@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
References: <cover.1550136164.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1550136164.git.osandov@fb.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Feb 14, 2019 at 02:00:07AM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
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

I don't have anything new to add to what has been said in the thread.
The creation time is property of the filesystem and if user wants to
track additional metadata, then as external attributes.
