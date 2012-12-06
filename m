From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V7 00/23] ext4: Add inline data support
Date: Thu, 6 Dec 2012 12:30:22 -0500
Message-ID: <20121206173022.GE30273@thunk.org>
References: <1351047002-4723-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37169 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423067Ab2LFRa0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Dec 2012 12:30:26 -0500
Content-Disposition: inline
In-Reply-To: <1351047002-4723-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Tao,

I've been going over the patch series, and one of the things that I
started thinking about was whether we really needed the inline_data
flag, strictly speaking.  After all, the information will be in the
extended attribute space in the inode table, so it's relatively cheap
to search the ibody looking for the extended attribute, and then to
cache that information in a state flag.  That might be a useful thing
to do, so I'd welcome your comments about whether you think this would
be a good idea.

But this brought up a bigger issue, which is the one downside of doing
this is the potential locking overhead before fetching the information
out of the extended attribute --- and that's when I realized the
locking is currently *missing*.  At the moment, the VFS layer takes
i_mutex before calling the per-filesystem extended attribute
functions, and that takes care of the locking.  However, the inline
data patches call ext4_xattr_ibody_find() and ext4_xattr_ibody_set()
directly, and they are not taking the i_mutex first.

Hence, we have potential races between the a process setting an
userspace extended attribute, or selinux setting a security.* xattr,
and the new code which tries reading or writing inline data.

Could you take a look at this, please?

Many thanks,

						- Ted
