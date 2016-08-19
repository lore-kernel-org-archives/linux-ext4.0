From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/6] fix build typos
Date: Fri, 19 Aug 2016 09:35:32 -0400
Message-ID: <20160819133532.GF10888@thunk.org>
References: <1471553651-9547-1-git-send-email-dmonakhov@openvz.org>
 <1471553651-9547-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45526 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751599AbcHSNfe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 19 Aug 2016 09:35:34 -0400
Content-Disposition: inline
In-Reply-To: <1471553651-9547-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 19, 2016 at 12:54:07AM +0400, Dmitry Monakhov wrote:
> build-all: --xfsprogs-only => SKIP_XFSPROGS, not SKIP_XFSTESTS
> get-all: fix typo in case of explicit xfsprogs_commit
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Applied, thanks.

					- Ted
