From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] e2fsprogs: Make -U option consistent between tune2fs
 and mke2fs
Date: Mon, 29 May 2017 19:10:39 -0400
Message-ID: <20170529231039.wucznxrk6k533m43@thunk.org>
References: <3501FCFF-B686-47DF-B530-802CB3A79FAB@dilger.ca>
 <20170413235628.GA133121@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Drew Davenport <ddavenport@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49456 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750994AbdE2XKl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 29 May 2017 19:10:41 -0400
Content-Disposition: inline
In-Reply-To: <20170413235628.GA133121@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 13, 2017 at 04:56:28PM -0700, Drew Davenport wrote:
> Allow "null", "clear", "random", or "time" for the -U option for
> mke2fs, which are already allowed options for tune2fs.
> 
> Signed-off-by: Drew Davenport <ddavenport@google.com>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
