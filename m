From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Wed, 14 Mar 2012 15:34:13 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203141507220.14894@dhcp-27-109.brq.redhat.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com> <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com> <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com> <20120310044804.GB5652@thunk.org> <4F5F9A97.5060404@ubuntu.com>
 <20120313195339.GA24124@thunk.org> <4F5FAC9C.9070607@gmail.com> <20120313213304.GB11969@thunk.org> <alpine.LFD.2.00.1203140825090.5379@dhcp-27-109.brq.redhat.com> <20120314125002.GH15379@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Phillip Susi <phillsusi@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120314125002.GH15379@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 14 Mar 2012, Ted Ts'o wrote:

> On Wed, Mar 14, 2012 at 09:12:02AM +0100, Lukas Czerner wrote:
> > I kind of like the idea about having the separate btree with inode
> > numbers for the directory reading, just because it does not affect
> > allocation policy nor the write performance which is a good thing. Also
> > it has been done before in btrfs and it works very well for them. The
> > only downside (aside from format change) is the extra step when removing
> > the directory entry, but the positives outperform the negatives.
> 
> Well, there will be extra (journaled!) block reads and writes involved
> when adding or removing directory entries.  So the performance on
> workloads that do a large number of directory adds and removed will
> have to be impacted.  By how much is not obvious, but it will be
> something which is measurable.

Yes, it would have to be measured in various workloads.

> 
> > Maybe this might be even done in a way which does not require format
> > change. We can have new inode flag (say EXT4_INUM_INDEX_FL) which will
> > tell us that there is a inode number btree to use on directory reads.
> > Then the pointer to the root of that tree would be stored at the end of
> > the root block of the hree (of course if there is still some space for
> > it) and the rest is easy.
> 
> You can make it be a RO_COMPAT change instead of an INCOMPAT change,
> yes.

Does it have to be RO_COMPAT change though ? Since this would be both
forward and backward compatible.

> 
> And if you want to do it as simply as possible, we could just recycle
> the current htree approach for the second tree, and simply store the
> root in another set of directory blocks.  But by putting the index
> nodes in the directory blocks, masquerading as deleted directories, it
> means that readdir() has to cycle through them and ignore the index
> blocks.
> 
> The alternate approach is to use physical block numbers instead of
> logical block numbers for the index blocks, and to store it separately
> from the blocks containing actual directory entries.  But if we do
> that for the inumber tree, the next question that arise is maybe we
> should do that for the hash tree as well --- and then once you upon
> that can of worms, it gets a lot more complicated.
> 
> So the question that really arises here is how wide open do we want to
> leave the design space, and whether we are optimizing for the best
> possible layout change ignoring the amount of implementation work it
> might require, or whether we keep things as simple as possible from a
> code change perspective.

What do you expect to gain by storing the index nodes outside the
directory entries ? Only to avoid reading the index nodes of both trees
when walking just one of it ? If I understand it correctly directory
blocks are laid out sequentially so reading it in cold cache state would
not pose much troubles I think. Nor the iteration through all of the
index nodes. However it would have to be measured first.

> 
> There are good arguments that can be made either way, and a lot
> depends on the quality of the students you can recruit, the amount of
> time they have, and how much review time it will take out of the core
> team during the design and implementation phase.

I am always hoping for the best :). We have had a good expedience with
the students here, but you'll never know that in advance. They'll have
the whole year to get through this, which is plenty of thine, but the
question of course is whether they'll use that time wisely :). But
anyway, I think it is definitely worth a try.

Thanks!
-Lukas

> 
> Regards,
> 
> 						- Ted
> 

-- 
