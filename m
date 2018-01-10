From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: no need flush workqueue before destroying it
Date: Tue, 9 Jan 2018 21:42:29 -0500
Message-ID: <20180110024228.GA5809@thunk.org>
References: <5A54B7A2.8050101@huawei.com>
 <20180109150712.i5tm3nywi3w4w4rk@quack2.suse.cz>
 <5A555B6F.7050406@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, adilger.kernel@dilger.ca, arnd@arndb.de,
        linux-ext4@vger.kernel.org
To: piaojun <piaojun@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57248 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933614AbeAJCmh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 Jan 2018 21:42:37 -0500
Content-Disposition: inline
In-Reply-To: <5A555B6F.7050406@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 10, 2018 at 08:16:47AM +0800, piaojun wrote:
> 
> On 2018/1/9 23:07, Jan Kara wrote:
> > On Tue 09-01-18 20:37:54, piaojun wrote:
> >> destroy_workqueue() will do flushing work for us.
> >>
> >> Signed-off-by: Jun Piao <piaojun@huawei.com>
> > 
> > Looks good. You can add:
> > 
> > Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.  (Note, you don't have resend the patch after it's
been reviewed; I can append the Reviewed-by line.)

     	       	     	    		    - Ted
