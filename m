Return-Path: <SRS0=fczw=RS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E61FBC43381
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 03:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C120321873
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 03:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfCODRc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Mar 2019 23:17:32 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56727 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727073AbfCODRc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Mar 2019 23:17:32 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2F3HNJL019382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Mar 2019 23:17:24 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 33DE8420AA8; Thu, 14 Mar 2019 23:17:23 -0400 (EDT)
Date:   Thu, 14 Mar 2019 23:17:23 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc:     linux-ext4@vger.kernel.org, joseph.qi@linux.alibaba.com
Subject: Re: [PATCH] ext4: fix NULL pointer dereference while journal is
 aborted
Message-ID: <20190315031723.GB11334@mit.edu>
References: <20190311063528.112996-1-jiufei.xue@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190311063528.112996-1-jiufei.xue@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Mar 11, 2019 at 02:35:28PM +0800, Jiufei Xue wrote:
> We see the following NULL pointer dereference while running xfstests
> generic/475:
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> PGD 8000000c84bad067 P4D 8000000c84bad067 PUD c84e62067 PMD 0
> Oops: 0000 [#1] SMP PTI
> CPU: 7 PID: 9886 Comm: fsstress Kdump: loaded Not tainted 5.0.0-rc8 #10
> RIP: 0010:ext4_do_update_inode+0x4ec/0x760
> ...
> Call Trace:
> ? jbd2_journal_get_write_access+0x42/0x50
> ? __ext4_journal_get_write_access+0x2c/0x70
> ? ext4_truncate+0x186/0x3f0
> ext4_mark_iloc_dirty+0x61/0x80
> ext4_mark_inode_dirty+0x62/0x1b0
> ext4_truncate+0x186/0x3f0
> ? unmap_mapping_pages+0x56/0x100
> ext4_setattr+0x817/0x8b0
> notify_change+0x1df/0x430
> do_truncate+0x5e/0x90
> ? generic_permission+0x12b/0x1a0
> 
> This is triggered because the NULL pointer handle->h_transaction was
> dereferenced in function ext4_update_inode_fsync_trans().
> I found that the h_transaction was set to NULL in jbd2__journal_restart
> but failed to attached to a new transaction while the journal is aborted.
> 
> Fix this by checking the handle before updating the inode.
> 
> Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>

Thanks, applied.

					- Ted
