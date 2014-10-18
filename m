From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/12 v2] Moving i_dquot out of struct inode
Date: Sat, 18 Oct 2014 21:26:24 +0200
Message-ID: <20141018192624.GA16478@quack.suse.cz>
References: <1412952910-7142-1-git-send-email-jack@suse.cz>
 <20141011133452.GA29004@infradead.org>
 <20141017192428.GA19788@quack.suse.cz>
 <20141018151738.GG30355@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	xfs@oss.sgi.com, cluster-devel@redhat.com,
	Steven Whitehouse <swhiteho@redhat.com>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net, tytso@mit.edu,
	viro@zeniv.linux.org.uk
To: Christoph Hellwig <hch@infradead.org>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141018151738.GG30355@infradead.org>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat 18-10-14 08:17:38, Christoph Hellwig wrote:
> On Fri, Oct 17, 2014 at 09:24:28PM +0200, Jan Kara wrote:
> >   I don't see the 4-bytes per inode saving, what am I missing? Frankly, I
> > don't see a difference in readability but since you and Al agree on that I
> > concede to your taste :)
> 
> It's the removal of s_inode_fields that saves 4 bytes.
  But that was in the superblock, not in the inode...
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
