Return-Path: <SRS0=8KOi=QA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D44AC282C3
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 08:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47E7E218A2
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 08:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfAXI3g (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jan 2019 03:29:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:60656 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725939AbfAXI3f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Jan 2019 03:29:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 41DCEAE98;
        Thu, 24 Jan 2019 08:29:34 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 321AB1E3FF5; Thu, 24 Jan 2019 09:29:33 +0100 (CET)
Date:   Thu, 24 Jan 2019 09:29:33 +0100
From:   Jan Kara <jack@suse.cz>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nvme@lists.infradead.org,
        jack@suse.com, david@fromorbit.com, tytso@mit.edu,
        prakash.v@samsung.com
Subject: Re: [PATCH v2 0/4] Write-hint for FS journal
Message-ID: <20190124082933.GA12184@quack2.suse.cz>
References: <CGME20190109153328epcas2p4643cbdc7a2182b47893a2bcaa0778e17@epcas2p4.samsung.com>
 <1547047861-7271-1-git-send-email-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547047861-7271-1-git-send-email-joshi.k@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello,

On Wed 09-01-19 21:00:57, Kanchan Joshi wrote:
> Towards supporing write-hints/streams for filesystem journal.                   
>                                                                                 
> Here is the v1 patch for background -                                           
> https://marc.info/?l=linux-fsdevel&m=154444637519020&w=2                        
>                                                                                 
> Changes since v1:                                                               
> - introduce four more hints for in-kernel use, as recommended by Dave chinner   
>   & Jens axboe. This isolates kernel-mode hints from user-mode ones.            
> - remove mount-option to specify write-hint, as recommended by Jan kara &       
>   Dave chinner. Rather, FS always sets write-hint for journal. This gets ignored
>   if device does not support stream.                                            
> - Removed code-redundancy for write_dirty_buffer (Jan kara's review comment)

I guess the series should also go to Jens since he was the original author
of write-hint support so he has the best idea about the architecture.

								Honza

> Kanchan Joshi (4):
>   block: Increase count of supported write-hints
>   fs: introduce four macros for in-kernel hints
>   fs: introduce APIs to enable sending write-hint with buffer-head
>   fs/ext4,jbd2: add support for passing write-hint with journal.
> 
>  fs/buffer.c                 | 18 ++++++++++++++++--
>  fs/ext4/super.c             |  2 ++
>  fs/jbd2/commit.c            | 11 +++++++----
>  fs/jbd2/journal.c           |  3 ++-
>  fs/jbd2/revoke.c            |  3 ++-
>  include/linux/blkdev.h      |  5 ++++-
>  include/linux/buffer_head.h |  3 +++
>  include/linux/fs.h          |  5 +++++
>  include/linux/jbd2.h        |  8 ++++++++
>  9 files changed, 49 insertions(+), 9 deletions(-)
> 
> -- 
> 2.7.4
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
