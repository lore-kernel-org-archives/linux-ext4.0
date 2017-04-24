From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] tune2fs: fix BUGs of tuning project quota
Date: Mon, 24 Apr 2017 11:15:32 -0400
Message-ID: <20170424151532.z464fzoynm5skzy5@thunk.org>
References: <20170414133449.45607-1-wshilong@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, wshilong@ddn.com,
        andreas.dilger@intel.com, lixi@ddn.com, sihara@ddn.com
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41906 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934531AbdDXPPh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 24 Apr 2017 11:15:37 -0400
Content-Disposition: inline
In-Reply-To: <20170414133449.45607-1-wshilong@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 14, 2017 at 09:34:49PM +0800, Wang Shilong wrote:
> Somehow project quota did not work well for enable/disable,
> Add some tests to address it.
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>

The patch summary says "fix BUGs of tuning project quota".  As near as
I can tell all this patch does is enable disabling project quota and
removes a warning message.  "BUGs" implies a kernel bug?

If you could make the patch description more descriptive, that would
be helpful.

						- Ted
