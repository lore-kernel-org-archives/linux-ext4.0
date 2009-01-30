From: Theodore Tso <tytso@mit.edu>
Subject: Re: on disk format: value of bg_inode_table_hi?
Date: Thu, 29 Jan 2009 23:19:40 -0500
Message-ID: <20090130041940.GB23220@mit.edu>
References: <20090129051221.GH8990@mit.edu> <419866.84825.qm@web23605.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59656 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbZA3ETq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Jan 2009 23:19:46 -0500
Content-Disposition: inline
In-Reply-To: <419866.84825.qm@web23605.mail.ird.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 29, 2009 at 11:47:29AM +0000, Etienne Lorrain wrote:
> - If I only access the ext4 filesystem readonly, I do not
>  have any difference considering the flags of the superblock:
>  EXT4_FEATURE_INCOMPAT_META_BG, EXT4_FEATURE_INCOMPAT_MMP,
>  EXT4_FEATURE_INCOMPAT_FLEX_BG.

meta_bg is an INCOMPAT feature because kernels that don't understand
this option won't be able to find the inode table blocks, and would
crash and burn.

flex_bg is an INCOMPAT feature because older kernels do an explicit
sanity check to make sure a block group's metadata is in the block
group.  This one could have been ro_incompat, I suppose, since the
worst that would happen with an ro mount on those older kernels is
they would cause an error when the filesystem is mounted.  On the
other hand, if the filesystem was also marked "panic and reboot on
error", some users might consider it unfriendly that mounting such a
filesystem on an older kernel would cause an immediate reboot.

Given that there are some security extremists who consider the
possibility of filesystem images that cause a reboot as a "security
bug" that worthy of assignment of a CVE and urgent bug reports forcing
other developers to drop everything and address said "security bug",
it's probably best that flex_bg is an INCOMPAT feature.  :-)

          	      	   		      - Ted
