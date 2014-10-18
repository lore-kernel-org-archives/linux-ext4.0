From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/12 v2] Moving i_dquot out of struct inode
Date: Sat, 18 Oct 2014 08:17:38 -0700
Message-ID: <20141018151738.GG30355@infradead.org>
References: <1412952910-7142-1-git-send-email-jack@suse.cz>
 <20141011133452.GA29004@infradead.org>
 <20141017192428.GA19788@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
	cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net, tytso@mit.edu,
	viro@zeniv.linux.org.uk
To: Jan Kara <jack@suse.cz>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141017192428.GA19788@quack.suse.cz>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 17, 2014 at 09:24:28PM +0200, Jan Kara wrote:
>   I don't see the 4-bytes per inode saving, what am I missing? Frankly, I
> don't see a difference in readability but since you and Al agree on that I
> concede to your taste :)

It's the removal of s_inode_fields that saves 4 bytes.
