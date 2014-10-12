From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/12 v2] Moving i_dquot out of struct inode
Date: Sun, 12 Oct 2014 19:53:16 +0100
Message-ID: <20141012185316.GQ7996@ZenIV.linux.org.uk>
References: <1412952910-7142-1-git-send-email-jack@suse.cz>
 <20141011133452.GA29004@infradead.org>
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
	jfs-discussion@lists.sourceforge.net, tytso@mit.edu
To: Christoph Hellwig <hch@infradead.org>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141011133452.GA29004@infradead.org>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Oct 11, 2014 at 06:34:52AM -0700, Christoph Hellwig wrote:
> I still very much disagree with the s_inode_fields indirection.  Please
> find a patch below to remove it, and use a get_dquots super_block
> operation instead.  This leads to less and better readable code,
> and serves 4 bytes in every inode in the system.  Additionally the
> indirection could easily be optimized away by directly passing the
> dquot array in various functions, but for now I'd like to keep it
> simple.

Indeed.  This "array of offsets" approach is asking for trouble.  Please,
don't go there - playing that way with type safety is a bad idea.
