From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 patchqueue corrupted ?
Date: Fri, 11 Jul 2008 08:47:42 -0400
Message-ID: <20080711124742.GA20099@mit.edu>
References: <20080711034606.GA779@skywalker> <20080711084715.GT10151@machine.or.cz> <20080711122617.GA8154@mit.edu> <20080711123109.GA14606@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Petr Baudis <pasky@suse.cz>, Ming Ming Cao <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	git@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <git-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080711123109.GA14606@skywalker>
Sender: git-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 11, 2008 at 06:01:09PM +0530, Aneesh Kumar K.V wrote:
> On Fri, Jul 11, 2008 at 08:26:17AM -0400, Theodore Tso wrote:
> > On Fri, Jul 11, 2008 at 10:47:15AM +0200, Petr Baudis wrote:
> > >   very puzzling; I have backed up the broken objects store, can you
> > > repush, please? I'm curious about how this could have happenned;
> > > repo.or.cz now uses Git from latest next, which is a rather strange
> > > coincidence. ;-) Or did any of the pushers do anything special about
> > > pushin to the repository recently?
> > 
> > Aneesh, did you try repushing?  It looks like the objects store is
> > broken again.
> 
> I don't have permission to push to the repo. I can only pull.

Right, sorry, I forgot that you didn't have write access to the repo.

Pasky, my attempt to push is failing:

<tytso@closure> {/usr/projects/linux/ext4/.git/patches/ext4dev}  [master]
101% git push git+ssh://repo.or.cz/srv/git/ext4-patch-queue.git master:master
Everything up-to-date
error: refs/tags/v2.6.20-ext4-1 does not point to a valid object!
error: refs/tags/v2.6.20-rc5-ext4-1 does not point to a valid object!
<tytso@closure> {/usr/projects/linux/ext4/.git/patches/ext4dev}  [master]
102% git push git+ssh://repo.or.cz/srv/git/ext4-patch-queue.git +refs/heads/*:refs/heads/*
error: refs/tags/v2.6.20-ext4-1 does not point to a valid object!
error: refs/tags/v2.6.20-rc5-ext4-1 does not point to a valid object!
Total 0 (delta 0), reused 0 (delta 0)
error: unpack should have generated a1a5e2eaaea5292da062f6dfbed66b5e07d396d3, but I can't find it!
error: unpack should have generated bd5803bec71c494ba3ac7b147fd4d0deed423a5b, but I can't find it!
To git+ssh://repo.or.cz/srv/git/ext4-patch-queue.git
 ! [remote rejected] 2.6.23-ext4-1 -> 2.6.23-ext4-1 (bad pack)
 ! [remote rejected] origin -> origin (bad pack)
error: failed to push some refs to 'git+ssh://repo.or.cz/srv/git/ext4-patch-queue.git'

And git ls-remote tells an even sadder tale:

<tytso@closure> {/usr/projects/linux/ext4/.git/patches/ext4dev}  [master]
103% git ls-remote  git+ssh://repo.or.cz/srv/git/ext4-patch-queue.git
error: missing object referenced by 'refs/tags/2.6.23-ext4-1'
error: missing object referenced by 'refs/tags/2.6.24-ext4-1'
error: missing object referenced by 'refs/tags/2.6.24-ext4-rc4-1'
error: missing object referenced by 'refs/tags/2.6.24-git12-ext4-1'
error: missing object referenced by 'refs/tags/2.6.24-git6-ext4-1'
error: missing object referenced by 'refs/tags/2.6.24-rc1-ext4-1'
error: missing object referenced by 'refs/tags/2.6.24-rc8-ext4-1'
error: missing object referenced by 'refs/tags/2.6.25-git15-ext4-1'
error: missing object referenced by 'refs/tags/2.6.25-rc4-ext4-1'
error: refs/tags/v2.6.20-ext4-1 does not point to a valid object!
error: refs/tags/v2.6.20-rc5-ext4-1 does not point to a valid object!
error: missing object referenced by 'refs/tags/v2.6.20-rc7-ext4-1'
error: missing object referenced by 'refs/tags/v2.6.21-ext4-1'
error: missing object referenced by 'refs/tags/v2.6.22-rc4-ext4-1'
error: missing object referenced by 'refs/tags/v2.6.26-rc2-ext4-1'
ec90e41198ede71d186bb7075e2edea7a6daae5a        HEAD
ec90e41198ede71d186bb7075e2edea7a6daae5a        refs/heads/master
346bfccb5d3af0ee5bda961d2e2fcbf1c9d71ef6        refs/tags/2.6.23-ext4-1
47f7b357a1468e42a5d16b9f12ceb9d5c0d1da5e        refs/tags/2.6.24-ext4-1
558ca8d2472d43341f80627da9bef266a33e29c1        refs/tags/2.6.24-ext4-rc4-1
0f329cb9046106a0bc2ce1e8ba4a1d431e4761fe        refs/tags/2.6.24-git12-ext4-1
fb4f7981226285b1cd9230bd584ad8c442441fd1        refs/tags/2.6.24-git6-ext4-1
04ccbce687206f51e8e2d243505381c0da48db2b        refs/tags/2.6.24-rc1-ext4-1
058e44f59dc308408ac3558f7d375b1c55e429fe        refs/tags/2.6.24-rc8-ext4-1
419fe473159404c4ce0a516e3d435705271de3d8        refs/tags/2.6.25-git15-ext4-1
fe39106438de15396a7083d11cbc1f1511006382        refs/tags/2.6.25-rc4-ext4-1
dfc7edaaea270f4182d748de59ef83d3b679c54b        refs/tags/v2.6.20-rc7-ext4-1
fb7f3bc312359e429a7308bf0fcffeb920ab2efc        refs/tags/v2.6.21-ext4-1
0db80f52ee3366cae5a0c3276be2f7de1674b09b        refs/tags/v2.6.22-rc4-ext4-1
be15cbe06b269fcacb80b8d8484ec606f5788de1        refs/tags/v2.6.26-rc2-ext4-1

Can you completely zap the repository replace it with a freshly 
"git init"-ialized files, and I'll try repushing?

Thanks!!

						- Ted
