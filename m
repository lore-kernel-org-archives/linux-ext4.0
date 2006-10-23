From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Mon, 23 Oct 2006 08:48:25 -0600
Message-ID: <20061023144824.GK3509@schatzie.adilger.int>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz> <20061023141641.GA29649@thunk.org> <m3vembnlwz.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Alex Tomas <alex@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <m3vembnlwz.fsf@bzzz.home.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 23, 2006  18:31 +0400, Alex Tomas wrote:
> isn't that a kernel responsbility to find/allocate target blocks?
> wouldn't it better to specify desirable target group and minimal
> acceptable chunk of free blocks?

In some cases this is useful (e.g. if file has small fragments after
being written in small pieces or in a fragmented free space).  In other
cases the user tool HAS to be able to specify the new mapping in order
to make progress.

Consider if there are two very large fragmented files and user-space
defrag tool wants to make contiguous free space.  If kernel is left to do
allocation it will always consume the largest chunk of free space first,
even if it is not yet optimal (e.g. large 1MB aligned extent).

I would make this interface optionally allow the target extent to be
specified, but if target block == 0 then the kernel is free to do its
own allocation.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

