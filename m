From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: fix forgetten xattr lock protection in
 ext4_expand_extra_isize
Date: Thu, 13 Jul 2017 12:47:00 -0400
Message-ID: <20170713164700.idfwntrzy2rvaagt@thunk.org>
References: <1499360993-17130-1-git-send-email-miaoxie@huawei.com>
 <e7301611-0fed-fbbf-3ab9-49f2287a14eb@huawei.com>
 <3ED34739A4E85E4F894367D57617CDEFE1DD2EEC@LAX-EX-MB2.datadirect.datadirectnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "miaoxie@huawei.com" <miaoxie@huawei.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Li Xi <lixi@ddn.com>,
        "yi.zhang@huawei.com" <yi.zhang@huawei.com>,
        "adilger@dilger.ca" <adilger@dilger.ca>,
        Shuichi Ihara <sihara@ddn.com>
To: Wang Shilong <wshilong@ddn.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46850 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750881AbdGMQrF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Jul 2017 12:47:05 -0400
Content-Disposition: inline
In-Reply-To: <3ED34739A4E85E4F894367D57617CDEFE1DD2EEC@LAX-EX-MB2.datadirect.datadirectnet.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 13, 2017 at 01:04:08PM +0000, Wang Shilong wrote:
>   I guess Maintainer will reply you when development cycle is ready for this.
> Please be patient Miao!, let's play Glory of the king.^^^_^^^

Sorry, this come in too late for it be included in the merge window,
since at that time I Was trying to do final regression testing before
sending a pull request to Linus.

I'm also currently on travel (attending Usenix ATC and visiting $WORK
in the Bay Area).  I will start accumulating fixes soon, probably
shortly after 4.13-rc1 comes out.  It *would* be helpful if other ext4
developers could review the patches while on travel (hint, hint).
Otherwise, I'll start reviewing patches in a week or two.

Cheers,

					- Ted
