From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/2] ext4: ACL fixes for 4.12
Date: Tue, 8 Aug 2017 09:42:53 -0700
Message-ID: <20170808164253.GA7415@kroah.com>
References: <20170808124442.8963-1-jack@suse.cz>
 <20170808161159.GB20707@kroah.com>
 <20170808162742.GA23959@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46178 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752098AbdHHQmy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Aug 2017 12:42:54 -0400
Content-Disposition: inline
In-Reply-To: <20170808162742.GA23959@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 08, 2017 at 06:27:42PM +0200, Jan Kara wrote:
> On Tue 08-08-17 09:11:59, Greg KH wrote:
> > On Tue, Aug 08, 2017 at 02:44:40PM +0200, Jan Kara wrote:
> > > 
> > > Hello,
> > > 
> > > here are two ext4 ACL fixes with context fixed up so that they apply to
> > > 4.12 kernel. Please apply them to 4.12-stable. Thanks!
> > > 
> > > 								Honza
> > 
> > Providing the git commit ids of the patches would have been more
> > helpful.  Please do that in the future, I had to dig for them...
> 
> Sorry, they were part of the patches as 'Git-commit' header which is
> somewhat unusual I guess. I'll add them in some more standard format next
> time.

Ah, I should have looked at the email header, didn't think about that,
my coffee hasn't kicked in yet.  Will do that next time.

thanks,

greg k-h
