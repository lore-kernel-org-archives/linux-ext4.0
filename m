From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/8] ext2: write superblock only once on unmount
Date: Tue, 3 Apr 2012 00:10:27 +0200
Message-ID: <20120402221027.GD5270@quack.suse.cz>
References: <1332346475-1441-1-git-send-email-dedekind1@gmail.com>
 <1332346475-1441-4-git-send-email-dedekind1@gmail.com>
 <20120331115332.GB4569@quack.suse.cz>
 <1333374249.22146.2.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60500 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab2DBWKa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Apr 2012 18:10:30 -0400
Content-Disposition: inline
In-Reply-To: <1333374249.22146.2.camel@sauron.fi.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 02-04-12 16:44:09, Artem Bityutskiy wrote:
> On Sat, 2012-03-31 at 13:53 +0200, Jan Kara wrote:
> > On Wed 21-03-12 18:14:30, Artem Bityutskiy wrote:
> > > From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> > > 
> > > Currently on unmount if we are mounted R/W, we first write the superblock to
> > > the media if it is dirty, and then write it again, which is not optimal. This
> > > patch makes ext2 write the superblock on unmount less times.
> >   Looks good. I've added the patch to my tree.
> 
> I would like to test v2 against your tree, I found this one:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git
> 
> but I do not see this patch there - is that the right tree, or may be
> you did not push out? Which branch should I use?
  Yeah, I didn't push out the changes. Now they are out (for_next /
for_testing) branch.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
