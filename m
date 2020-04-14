Return-Path: <SRS0=nKcX=56=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C083C2BB1D
	for <linux-ext4@archiver.kernel.org>; Tue, 14 Apr 2020 06:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50D822072D
	for <linux-ext4@archiver.kernel.org>; Tue, 14 Apr 2020 06:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405959AbgDNGZf (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 14 Apr 2020 02:25:35 -0400
Received: from verein.lst.de ([213.95.11.211]:37625 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405926AbgDNGZc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 14 Apr 2020 02:25:32 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B6489227A81; Tue, 14 Apr 2020 08:25:30 +0200 (CEST)
Date:   Tue, 14 Apr 2020 08:25:30 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     ira.weiny@intel.com
Cc:     linux-kernel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Jeff Moyer <jmoyer@redhat.com>, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V7 4/9] fs/xfs: Make DAX mount option a tri-state
Message-ID: <20200414062530.GD23154@lst.de>
References: <20200413054046.1560106-1-ira.weiny@intel.com> <20200413054046.1560106-5-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413054046.1560106-5-ira.weiny@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Apr 12, 2020 at 10:40:41PM -0700, ira.weiny@intel.com wrote:
> +#define XFS_MOUNT_DAX		(1ULL << 62)
> +#define XFS_MOUNT_NODAX		(1ULL << 63)

Replace this with XFS_MOUNT_DAX_ALWAYS and XFS_MOUNT_DAX_NEVER?
