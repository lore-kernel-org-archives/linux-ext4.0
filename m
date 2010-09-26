From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/10] Fs: ext4: acl.c: fixed indent issue
Date: Sat, 25 Sep 2010 20:36:06 -0400
Message-ID: <20100926003606.GB19690@thunk.org>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
 <20100925233600.GA2854@lst.de>
 <AANLkTimf9Q=jfga=--H0VaZeWnbAVNhCPMn_G81sZ8vh@mail.gmail.com>
 <20100925235643.GA3224@lst.de>
 <20100926000154.GB5299@thunk.org>
 <1285459769.6115.74.camel@Joe-Laptop>
 <20100926003255.GA19690@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Joe Perches <joe@perches.com>, Christoph Hellwig <hch@lst.de>,
	T Dent <tdent48227@gmail.com>, adilger.kernel@dilger.ca,
	jack@suse.cz, dmonakhov@openvz.org, sandeen@redhat.com,
	linux-e
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60593 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013Ab0IZAgM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 25 Sep 2010 20:36:12 -0400
Content-Disposition: inline
In-Reply-To: <20100926003255.GA19690@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 25, 2010 at 08:32:55PM -0400, Ted Ts'o wrote:
> On Sat, Sep 25, 2010 at 05:09:29PM -0700, Joe Perches wrote:
> > > Wow, I just looked at how get_maintainer.pl works, and it's amazing
> > > how broken it is.  I guess I had heard some rumblings of unhappiness
> > > about it, but I'm surprised it's been allowed to live.
> > 
> > In your opinion Ted, what's broken about it?
> > 
> 
> It's casting **way** too wide of a net:

Oh, and the output on fs/ext4/acl.c must have been created by a
crack-addled monkey:

% ./scripts/get_maintainer.pl --roles -f fs/ext4/acl.c 
"Theodore Ts'o" <tytso@mit.edu> (maintainer:EXT4 FILE SYSTEM)
Andreas Dilger <adilger.kernel@dilger.ca> (maintainer:EXT4 FILE SYSTEM)
Al Viro <viro@zeniv.linux.org.uk> (commit_signer)
Stephen Hemminger <shemminger@vyatta.com> (commit_signer)
Joel Becker <joel.becker@oracle.com> (commit_signer)
James Morris <jmorris@namei.org> (commit_signer)
Jan Kara <jack@suse.cz> (commit_signer)
linux-ext4@vger.kernel.org (open list:EXT4 FILE SYSTEM)
linux-kernel@vger.kernel.org (open list)

I'm pretty sure Stephen Hemminger, Joel Becker, and James Morris don't
want to get spammed by random ext4 e-mails.

					- Ted


