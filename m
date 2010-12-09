From: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] fs/vfs/security: pass last path component to LSM on
 inode creation
Date: Thu, 09 Dec 2010 10:52:21 -0500
Message-ID: <1291909941.3072.70.camel@localhost.localdomain>
References: <20101208194527.13537.77202.stgit@paris.rdu.redhat.com>
	 <19712.61515.201226.938553@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: xfs-masters@oss.sgi.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        cluster-devel@redhat.com, linux-mtd@lists.infradead.org,
        jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org,
        linux-security-module@vger.kernel.org, chris.mason@oracle.com,
        jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        tytso@mit.edu, swhiteho@redhat.com, dwmw2@infradead.org,
        shaggy@linux.vnet.ibm.com, mfasheh@suse.com, joel.becker@oracle.com,
        aelder@sgi.com, hughd@google.com, jmorris@namei.org, sds@tycho.nsa.gov,
        eparis@parisplace.org, hch@lst.de, dchinner@redhat.com,
        viro@zeniv.linux.org.uk, tao.ma@oracle.com, shemminger@vyatta.com,
        jeffm@suse.com, paul.moore@hp.com, penguin-ke
To: John Stoffel <john@stoffel.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <19712.61515.201226.938553@quad.stoffel.home>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2010-12-09 at 10:05 -0500, John Stoffel wrote:
> >>>>> "Eric" == Eric Paris <eparis@redhat.com> writes:

> So what happens when I create a file /home/john/shadow, does selinux
> (or LSM in general) then run extra checks because the filename is
> 'shadow' in your model?  

It's entirely a question of labeling and one that was discussed on the
LSM list in some detail:

http://marc.info/?t=129141308200002&r=1&w=2

The basic synopsis is that when a new inode is created SELinux must
apply some label.  It makes the decision for what label to apply based
on 3 pieces of information.

The label of the parent inode.
The label of the process creating the new inode.
The 'class' of the inode, S_ISREG, S_ISDIR, S_ISLNK, etc

This patch adds a 4th piece of information, the name of the object being
created.  An obvious situation where this will be useful is devtmpfs
(although you'll find other examples in the above thread).  devtmpfs
when it creates char/block devices is unable to distinguish between kmem
and console and so they are created with a generic label.  hotplug/udev
is then called which does some pathname like matching and relabels them
to something more specific.  We've found that many people are able to
race against this particular updating and get spurious denials in /dev.
With this patch devtmpfs will be able to get the labels correct to begin
with.

I'm certainly willing to discuss the security implications of this
patch, but that would probably be best done with a significantly
shortened cc-list.  You'll see in the above mentioned thread that a
number of 'security' people (even those who are staunchly anti-SELinux)
recognize there is value in this and that it is certainly much better
than we have today.

> I *think* the overhead shouldn't be there if SELINUX is disabled, but
> have you confirmed this?  How you run performance tests before/after
> this change when doing lots of creations of inodes to see what sort of
> performance changes might be there?

I've actually recently done some perf testing on creating large numbers
of inodes using bonnie++, since SELinux was a noticeable overhead in
that operation.  Doing that same test with SELinux disabled (or enabled)
I do not see a noticeable difference when this patch is applied or not.
It's just an extra argument to a function that goes unused.

-Eric

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom policy in Canada: sign http://dissolvethecrtc.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
