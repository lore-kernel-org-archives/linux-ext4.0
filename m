From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/4] Fix fsync on ext3 and ext4 (v2)
Date: Thu, 5 Nov 2009 14:02:50 +0100
Message-ID: <20091105130250.GC17008@atrey.karlin.mff.cuni.cz>
References: <1256647729-29834-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43879 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544AbZKENDQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Nov 2009 08:03:16 -0500
Content-Disposition: inline
In-Reply-To: <1256647729-29834-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

>   this is a second try for a patchset which makes ext3 and ext4 properly force
> a transaction commit when needed. We now do not rely on buffer dirty bits
> (which does not work as pdflush can just clear them without forcing a
> transaction commit) but rather keep transaction ids that need to be committed
> for each inode.
>   Since last version, I've implemented Aneesh's and Curt's comments and also
> fixed a missing initialization of the fields. I've tested that now the patch
> works correctly for uninitialized extents as well as for standard writes.  If
> noone objects, would you merge the ext4 part Ted? I'll take care of the ext3
> patch.
  Aneesh, Ted, is the second version of the patchset fine with you?

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
