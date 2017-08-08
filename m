From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/2] ext4: ACL fixes for 4.12
Date: Tue, 8 Aug 2017 18:27:42 +0200
Message-ID: <20170808162742.GA23959@quack2.suse.cz>
References: <20170808124442.8963-1-jack@suse.cz>
 <20170808161159.GB20707@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, stable@vger.kernel.org,
        Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42600 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752062AbdHHQ1p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 8 Aug 2017 12:27:45 -0400
Content-Disposition: inline
In-Reply-To: <20170808161159.GB20707@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 08-08-17 09:11:59, Greg KH wrote:
> On Tue, Aug 08, 2017 at 02:44:40PM +0200, Jan Kara wrote:
> > 
> > Hello,
> > 
> > here are two ext4 ACL fixes with context fixed up so that they apply to
> > 4.12 kernel. Please apply them to 4.12-stable. Thanks!
> > 
> > 								Honza
> 
> Providing the git commit ids of the patches would have been more
> helpful.  Please do that in the future, I had to dig for them...

Sorry, they were part of the patches as 'Git-commit' header which is
somewhat unusual I guess. I'll add them in some more standard format next
time.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
