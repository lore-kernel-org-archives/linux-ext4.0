From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/12] quota: Allow each filesystem to specify which
	quota types it supports
Date: Thu, 23 Oct 2014 10:53:50 +0200
Message-ID: <20141023085349.GA30381@lst.de>
References: <1413902316-17997-1-git-send-email-jack@suse.cz> <1413902316-17997-3-git-send-email-jack@suse.cz> <20141022162915.GB18443@lst.de> <20141022165150.GA12809@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
	cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net, tytso@mit.edu,
	viro@zeniv.linux.org.uk
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141022165150.GA12809@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 22, 2014 at 06:51:50PM +0200, Jan Kara wrote:
>   So there are two reasons:
> 1) Currently if you call quotactl() with invalid quota type you'll get
> EINVAL. To maintain this with addition of project quotas you need to check
> the types early before calling check_quotactl_permission() and other
> checks.
> 
> 2) I didn't want filesystem quotactl callbacks to deal with quota types
> they don't support. Sure each fs could do a type check in the callback but
> this looked easier.
> 
> Now I see your point about s_dquot and I can move allowed_types out of
> s_dquot if that makes you happier. But otherwise what I did still seems as
> the best solution to me.

Moving it out of s_dquot seems very sensible to me.
