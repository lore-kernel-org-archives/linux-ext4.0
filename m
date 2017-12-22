From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] misc: add e2mmpstatus utility
Date: Fri, 22 Dec 2017 12:17:16 -0500
Message-ID: <20171222171716.GB29153@thunk.org>
References: <1513934564-89598-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Shuichi Ihara <sihara@ddn.com>,
        Li Xi <lixi@ddn.com>, Wang Shilong <wshilong@ddn.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50764 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755826AbdLVRRU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 22 Dec 2017 12:17:20 -0500
Content-Disposition: inline
In-Reply-To: <1513934564-89598-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 22, 2017 at 02:22:44AM -0700, Andreas Dilger wrote:
> From: Shuichi Ihara <sihara@ddn.com>
> 
> e2mmpstatus is an MMP helper utility to read status from an MMP block.
> It outputs the latest MMP updated nodename and time for the device.

Why not include this into dumpe2fs?  Maybe dumpe2fs -m to just print
the MMP information and include the MMP nodetime and time for either
the full dumpe2fs or dumpe2fs -h output?

						- Ted
