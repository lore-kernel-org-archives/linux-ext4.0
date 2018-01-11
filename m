From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: use 'sbi' instead of 'EXT4_SB(sb)'
Date: Thu, 11 Jan 2018 13:19:09 -0500
Message-ID: <20180111181909.GD19241@thunk.org>
References: <5A55FE96.1040002@huawei.com>
 <20180110143821.65cq3733fqvpvmsu@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: piaojun <piaojun@huawei.com>, adilger.kernel@dilger.ca,
        arnd@arndb.de, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37508 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934462AbeAKSTU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 11 Jan 2018 13:19:20 -0500
Content-Disposition: inline
In-Reply-To: <20180110143821.65cq3733fqvpvmsu@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 10, 2018 at 03:38:21PM +0100, Jan Kara wrote:
> On Wed 10-01-18 19:52:54, piaojun wrote:
> > We could use 'sbi' instead of 'EXT4_SB(sb)' to make code more elegant.
> > 
> > Signed-off-by: Jun Piao <piaojun@huawei.com>
> 
> Looks good to me. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
