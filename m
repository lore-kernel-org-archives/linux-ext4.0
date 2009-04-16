From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH RFC] ext3 data=guarded v3
Date: Thu, 16 Apr 2009 13:39:13 +0200
Message-ID: <1239881953.20254.17.camel@marge.simson.net>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58863 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753050AbZDPLjS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Apr 2009 07:39:18 -0400
In-Reply-To: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-04-15 at 13:22 -0400, Chris Mason wrote:
> Hello everyone,

Greetings,

> This passed a longer stress test and generally seems to be working.  I
> don't think anyone would recommend it as a default for 2.6.30, but it
> may be a good idea to have a review party and decide if it is safe enough
> to include so people can experiment with it.

I know you didn't say RFT, but I did some anyway, and found a 100%
repeatable corruption scenario wrt git+umount.

/dev/sdf3 on /media/root type ext3 (rw,_netdev,noatime,data=guarded,acl,user_xattr)

<user git>
cd /media/root/home/git/testo
git init
cp /usr/local/src/kernel/linux-2.6.30.git/.git/config .git/.
git fetch
git pull
cd
<user root>
umount /media/root
mount /media/root
<user git>
cd /media/root/home/git/testo
git checkout -f

git@marge:..git/testo> git checkout -f
error: packfile .git/objects/pack/pack-5897f5ab55217236982c43fd644e854d0c42fa97.pack does not match index
error: packfile .git/objects/pack/pack-5897f5ab55217236982c43fd644e854d0c42fa97.pack cannot be accessed
error: packfile .git/objects/pack/pack-5897f5ab55217236982c43fd644e854d0c42fa97.pack does not match index
error: packfile .git/objects/pack/pack-5897f5ab55217236982c43fd644e854d0c42fa97.pack cannot be accessed
fatal: You are on a branch yet to be born

git@marge:..git/testo> md5sum .git/objects/pack/pack-5897f5ab55217236982c43fd644e854d0c42fa97.pack .git.good/objects/pack/pack-5897f5ab55217236982c43fd644e854d0c42fa97.pack
a54de2e5ed5f2dd8925169b404463261  .git/objects/pack/pack-5897f5ab55217236982c43fd644e854d0c42fa97.pack
88ca6b0eac30ef18e623b3a6f6490299  .git.good/objects/pack/pack-5897f5ab55217236982c43fd644e854d0c42fa97.pack
t@marge:..git/testo> md5sum .git/index .git.good/index
f2f9a1ffd2544841985f112e0831d2a5  .git/index
1f88bfbe71adfd649254e3a4bd91e7fa  .git.good/index

git version 1.6.2.3
.git/config
[core]
	repositoryformatversion = 0
	filemode = true
	bare = false
	logallrefupdates = true
[remote "master"]
	url = git://localhost/~git/linux-2.6
	fetch = +refs/heads/master:refs/remotes/master/master
[branch "master"]
	remote = master
	merge = refs/heads/master

If I move a .git created while mounted data=writeback into this
directory, I can mount/umount/checkout to my hearts content while
mounted data=guarded, but if I do the fetch/pull/umount while
data=guarded, after umount/mount, the repo is corrupt.

Prior to umount, all seems fine, trees build, git fsck is happy etc.

	-Mike

