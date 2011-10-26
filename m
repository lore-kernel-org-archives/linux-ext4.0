From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/6] ext4: fix punch_hole extend handler
Date: Wed, 26 Oct 2011 09:38:01 -0400
Message-ID: <20111026133801.GX31921@thunk.org>
References: <1319144939-28801-1-git-send-email-dmonakhov@openvz.org>
 <1319144939-28801-6-git-send-email-dmonakhov@openvz.org>
 <20111025120553.GF31921@thunk.org>
 <87fwihi6zi.fsf@dmbot.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59804 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932742Ab1JZNiI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Oct 2011 09:38:08 -0400
Content-Disposition: inline
In-Reply-To: <87fwihi6zi.fsf@dmbot.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 25, 2011 at 04:35:45PM +0400, Dmitry Monakhov wrote:
> BTW can you please highlight your plans to make libquota in to working
> shape, right now it simply rewrites old quota file so fsck each time
> result int fs modifications. I have some patches in my queue which add
> quota check capabilities in libquota/e2fsck. 

I've requested that Aditya make changes to libquota so it doesn't
always rewrite the quota file at each fsck; I consider this a bug.
Unfortunately he hasn't had a chance to get to this yet.  If you have
patches which implement part of this, please feel free to submit your
patches.

I don't believe libquota is going to make sense the way it is
currently written to be an exported library.  It's very tightly
dependent on ext2fs, and it's not clear it would be useful to external
programs.  It would require major changes to the API so it could be
useful for other file systems.  Given that there are some other file
systems (like ocfs2) which are using the quota formats as internal
file, perhaps it would be worthwhile to abstract away the ext2fs
specific functionality.  But I'm not entirely convinced, and perhaps
we will just rename libquota to libinternal, assume that it will
always be built statically, and then move things like profile.c into
libinternal.a.

						- Ted
