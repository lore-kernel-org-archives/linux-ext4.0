From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6/7] ext4: endless truncate due to nonlocked dio
 readers V2
Date: Thu, 13 Sep 2012 16:34:55 +0200
Message-ID: <20120913143455.GB4328@quack.suse.cz>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
 <1347211634-11509-7-git-send-email-dmonakhov@openvz.org>
 <20120913104136.GB11330@gmail.com>
 <20120913120736.GA4328@quack.suse.cz>
 <20120913125726.GA32155@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org, tytso@mit.edu, wenqing.lz@taobao.com
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab2IMOfD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Sep 2012 10:35:03 -0400
Content-Disposition: inline
In-Reply-To: <20120913125726.GA32155@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 13-09-12 20:57:26, Zheng Liu wrote:
> On Thu, Sep 13, 2012 at 02:07:36PM +0200, Jan Kara wrote:
> >   Hello,
> > 
> > On Thu 13-09-12 18:41:36, Zheng Liu wrote:
> > > Could you please provide more detailed workload to convince me?  I
> > > am thinking about whether we really need to disable dioread_nolock
> > > feature in here.  In our benchmarks, we don't see this problem.
> >   I just did:
> > 
> > # Create file
> > dd if=/dev/zero of=/mnt/file bs=1M count=30
> > sync
> > # Start 10 DIO dio readers in parallel reading the file in a loop
> > for (( i = 0; i < 10; i++ )); do
> >   while true; do
> >     dd if=/mnt/file bs=4k iflag=direct of=/dev/null
> >   done &
> > done
> > sleep 1
> > 
> > # Try to truncate the file - never finishes.
> > truncate -s 16 /mnt/file
> > 
> > It is pretty easy to hit this. Besides being a DOS attack vector (but I
> > won't be too concerned about this - there are plenty of ways how local
> > process can screw you) I can easily imagine some application to get bitten
> > by this. 
> 
> Hi Jan,
> 
> Thanks for your explanation, but in my desktop I cannot reproduce this
> problem.  The size of `file' is 16.  Am I missing something?
  Hum, on my test machine with 3.6-rc1 it does not... Maybe for your
desktop you need a larger sleep before running truncate so that readers
have time to start up? Also I suppose you have ext4 mounted with
dioread_nolock mount option?

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
