From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] A request to reserve a "tree id" field on ext[34] inodes
Date: Tue, 17 Nov 2009 18:12:26 +0100
Message-ID: <20091117171226.GC1923@atrey.karlin.mff.cuni.cz>
References: <4B02AD8B.2030202@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, Theodore Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, Dmitri Monakhov <dmonakhov@openvz.org>
To: Pavel Emelyanov <xemul@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34308 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbZKQRMV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Nov 2009 12:12:21 -0500
Content-Disposition: inline
In-Reply-To: <4B02AD8B.2030202@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

> We have a proposal to implement a 2-level disk quota on ext3 and ext4.
> 
> In two words - the aim is to have directories on ext3/4 partitions
> which are limited by its disk usage and the number of inodes. Further
> the plan is to allow configuring uid and gid quotas within them.
  If I understand it right, this is something like XFS's project quota,
right? Note that such thing has implications such as you have to forbid
hardlinks between different "quota trees", otherwise it just won't fly...
Also by 2-level, you mean it won't be possible to nest such subtrees?
I.e. have a quota on directories a/, b/, a/b, a/c?

> The main usage of this is containers. When two or more of them are
> located on one disk their roots will be marked with a unique tree id
> and thus the disk consumption of each container will be limited. While
> achieving this goal having an id of what tree an inode belongs to is
> a key requirement.
> 
> So first we would like to ask to reserve a place on ext3 and ext4 inodes
> for that ID.
  Do you really need to store tree ID on disk? I'd think that it should
be enough to keep some id / pointer in memory and initialize it when we
load inode into memory (from an id / pointer of parent directory). Then
it would be enough to store a fact that some directory is a root of
"quota tree" somewhere - either in extended attributes, as a flag in
the inode, or together with quota data.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
