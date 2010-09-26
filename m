From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/10] Fs: ext4: acl.c: fixed indent issue
Date: Sat, 25 Sep 2010 20:32:55 -0400
Message-ID: <20100926003255.GA19690@thunk.org>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
 <20100925233600.GA2854@lst.de>
 <AANLkTimf9Q=jfga=--H0VaZeWnbAVNhCPMn_G81sZ8vh@mail.gmail.com>
 <20100925235643.GA3224@lst.de>
 <20100926000154.GB5299@thunk.org>
 <1285459769.6115.74.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, T Dent <tdent48227@gmail.com>,
	adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
	sandeen@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1285459769.6115.74.camel@Joe-Laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Sep 25, 2010 at 05:09:29PM -0700, Joe Perches wrote:
> > Wow, I just looked at how get_maintainer.pl works, and it's amazing
> > how broken it is.  I guess I had heard some rumblings of unhappiness
> > about it, but I'm surprised it's been allowed to live.
> 
> In your opinion Ted, what's broken about it?
> 

It's casting **way** too wide of a net:

 ./scripts/get_maintainer.pl --roles -f fs/ext4/inode.c
"Theodore Ts'o" <tytso@mit.edu> (maintainer:EXT4 FILE SYSTEM,commit_signer)
Andreas Dilger <adilger.kernel@dilger.ca> (maintainer:EXT4 FILE SYSTEM)
Jan Kara <jack@suse.cz> (commit_signer)
Eric Sandeen <sandeen@redhat.com> (commit_signer)
Dmitry Monakhov <dmonakhov@openvz.org> (commit_signer)
Christoph Hellwig <hch@lst.de> (commit_signer)
linux-ext4@vger.kernel.org (open list:EXT4 FILE SYSTEM)
linux-kernel@vger.kernel.org (open list)

The right answer is to just send the e-mail to the linux-ext4 list.
That's what the MAINTAINERS file says, and it's right.  Using people
who have signed off of on commits, and blindly assuming that they are
therefore are maintainers, is Just Wrong.

Christoph has said he doesn't want to get e-mails about ext4 patches
--- and he shouldn't get them just because the get_maintainers.pl
script is broken.

					- Ted
