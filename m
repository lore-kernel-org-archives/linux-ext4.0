From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove old feature helpers
Date: Mon, 5 Sep 2016 23:13:38 -0400
Message-ID: <20160906031338.6xbh373j3fwuefod@thunk.org>
References: <20160805174037.8151-1-ngkaho1234@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, darrick.wong@oracle.com, linux-ext4@vger.kernel.org
To: Kaho Ng <ngkaho1234@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46660 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753565AbcIFDOs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 5 Sep 2016 23:14:48 -0400
Content-Disposition: inline
In-Reply-To: <20160805174037.8151-1-ngkaho1234@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 06, 2016 at 01:40:37AM +0800, Kaho Ng wrote:
> Use the ext4_{has,set,clear}_feature_* helpers to replace the old
> feature helpers.
> 
> Signed-off-by: Kaho Ng <ngkaho1234@gmail.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
