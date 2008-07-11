From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 patchqueue corrupted ?
Date: Fri, 11 Jul 2008 08:26:17 -0400
Message-ID: <20080711122617.GA8154@mit.edu>
References: <20080711034606.GA779@skywalker> <20080711084715.GT10151@machine.or.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ming Ming Cao <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	git@vger.kernel.org
To: Petr Baudis <pasky@suse.cz>
Return-path: <git-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080711084715.GT10151@machine.or.cz>
Sender: git-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 11, 2008 at 10:47:15AM +0200, Petr Baudis wrote:
>   very puzzling; I have backed up the broken objects store, can you
> repush, please? I'm curious about how this could have happenned;
> repo.or.cz now uses Git from latest next, which is a rather strange
> coincidence. ;-) Or did any of the pushers do anything special about
> pushin to the repository recently?

Aneesh, did you try repushing?  It looks like the objects store is
broken again.

Pasky, in case it helps, and for the benefit of Linux-ext4 folks, I
have a copy of my repository (which I last pushed to repo.or.cz around
noon US/Eastern yesterday) here:

     git://git.kernel.org/pub/scm/fs/ext2/ext4-patch-queue.git

My most recent HEAD is ec90e411; if anyone has something more recent,
they can send it to me via:

     git bundle create /tmp/to-send ec90e411

... and then e-mailing me as an attachment the resulting binary file
in /tmp/to-send.

						- Ted
