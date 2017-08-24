From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: cleanup goto next group
Date: Thu, 24 Aug 2017 11:59:27 -0400
Message-ID: <20170824155926.3g2gdy4bzp2ji2qr@thunk.org>
References: <20170820115325.57015-1-wshilong@ddn.com>
 <20170821075831.GA20202@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wang Shilong <wangshilong1991@gmail.com>,
        linux-ext4@vger.kernel.org, sihara@ddn.com, lixi@ddn.com,
        wshilong@ddn.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50584 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751168AbdHXP7a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Aug 2017 11:59:30 -0400
Content-Disposition: inline
In-Reply-To: <20170821075831.GA20202@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 21, 2017 at 09:58:31AM +0200, Jan Kara wrote:
> On Sun 20-08-17 19:53:25, Wang Shilong wrote:
> > From: Wang Shilong <wshilong@ddn.com>
> > 
> > avoid duplicated codes, also we need goto
> > next group in case we found reserved inode.
> > 
> > Signed-off-by: Wang Shilong <wshilong@ddn.com>
> 
> Looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
