From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/12] quota: Allow each filesystem to specify which
	quota types it supports
Date: Wed, 22 Oct 2014 18:29:15 +0200
Message-ID: <20141022162915.GB18443@lst.de>
References: <1413902316-17997-1-git-send-email-jack@suse.cz> <1413902316-17997-3-git-send-email-jack@suse.cz>
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
	viro@zeniv.linux.org.uk, hch@lst.de
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54125 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbaJVQ3X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Oct 2014 12:29:23 -0400
Content-Disposition: inline
In-Reply-To: <1413902316-17997-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 21, 2014 at 04:38:26PM +0200, Jan Kara wrote:
> Currently all filesystems supporting VFS quota support user and group
> quotas. With introduction of project quotas this is going to change so
> make sure filesystem isn't called for quota type it doesn't support by
> introduction of a bitmask determining which quota types each filesystem
> supports.

Why don't you keep this bitmask in the dquot.c instead of pushing it
to the caller?  So far usage of s_dquot is mostly confined to dquot.c
(with a few leaks to the filesystems using it), so keeping it that
way seems like a good idea.

