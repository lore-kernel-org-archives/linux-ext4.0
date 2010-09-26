From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 01/10] Fs: ext4: acl.c: fixed indent issue
Date: Sat, 25 Sep 2010 17:50:43 -0700
Message-ID: <1285462243.6115.89.camel@Joe-Laptop>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
	 <20100925233600.GA2854@lst.de>
	 <AANLkTimf9Q=jfga=--H0VaZeWnbAVNhCPMn_G81sZ8vh@mail.gmail.com>
	 <20100925235643.GA3224@lst.de> <20100926000154.GB5299@thunk.org>
	 <1285459769.6115.74.camel@Joe-Laptop>  <20100926003255.GA19690@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@lst.de>, T Dent <tdent48227@gmail.com>,
	adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
	sandeen@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100926003255.GA19690@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 2010-09-25 at 20:32 -0400, Ted Ts'o wrote:
> On Sat, Sep 25, 2010 at 05:09:29PM -0700, Joe Perches wrote:
> > > Wow, I just looked at how get_maintainer.pl works, and it's amazing
> > > how broken it is.  I guess I had heard some rumblings of unhappiness
> > > about it, but I'm surprised it's been allowed to live.
> > In your opinion Ted, what's broken about it?
> It's casting **way** too wide of a net:
>  ./scripts/get_maintainer.pl --roles -f fs/ext4/inode.c
> "Theodore Ts'o" <tytso@mit.edu> (maintainer:EXT4 FILE SYSTEM,commit_signer)
> Andreas Dilger <adilger.kernel@dilger.ca> (maintainer:EXT4 FILE SYSTEM)
> Jan Kara <jack@suse.cz> (commit_signer)
> Eric Sandeen <sandeen@redhat.com> (commit_signer)
> Dmitry Monakhov <dmonakhov@openvz.org> (commit_signer)
> Christoph Hellwig <hch@lst.de> (commit_signer)
> linux-ext4@vger.kernel.org (open list:EXT4 FILE SYSTEM)
> linux-kernel@vger.kernel.org (open list)
> 
> The right answer is to just send the e-mail to the linux-ext4 list.
> That's what the MAINTAINERS file says, and it's right.

What the MAINTAINERS file says is:

5.	Make a patch available to the relevant maintainer in the list

It doesn't say to send emails only to any appropriate list.

The EXT4 section is:

EXT4 FILE SYSTEM
M:	"Theodore Ts'o" <tytso@mit.edu>
M:	Andreas Dilger <adilger.kernel@dilger.ca>
L:	linux-ext4@vger.kernel.org
W:	http://ext4.wiki.kernel.org
Q:	http://patchwork.ozlabs.org/project/linux-ext4/list/
S:	Maintained
F:	Documentation/filesystems/ext4.txt
F:	fs/ext4/

> Using people
> who have signed off of on commits, and blindly assuming that they are
> therefore are maintainers, is Just Wrong.
> 
> Christoph has said he doesn't want to get e-mails about ext4 patches
> --- and he shouldn't get them just because the get_maintainers.pl
> script is broken.

The reason get_maintainers by default cc'd signers is mostly
historical.  The file pattern coverage in MAINTAINERS when
it was added wasn't very good, so signers were always added.
It was also the Linus' preferred mechanism to find those
"who really do the work".

http://lkml.org/lkml/2007/8/14/276

Anyway, the current file pattern coverage is probably
sufficiently good to change the --git default to off, as was
done by this commit already in Andrew Morton's mm tree.

Now git history is used only if there is no specifically
named maintainer.

The current version returns:

$ ./scripts/get_maintainer.pl -f fs/ext4/acl.c
"Theodore Ts'o" <tytso@mit.edu>
Andreas Dilger <adilger.kernel@dilger.ca>
linux-ext4@vger.kernel.org
linux-kernel@vger.kernel.org

cheers, Joe
