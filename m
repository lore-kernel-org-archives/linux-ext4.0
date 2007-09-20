From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] - ignore bind mounts in fsck
Date: Thu, 20 Sep 2007 10:42:45 -0400
Message-ID: <20070920144245.GD30221@thunk.org>
References: <46F1847E.6080400@redhat.com> <20070919204249.GH25497@thunk.org> <46F2845C.2010000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58621 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbXITOmq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Sep 2007 10:42:46 -0400
Content-Disposition: inline
In-Reply-To: <46F2845C.2010000@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 20, 2007 at 09:31:56AM -0500, Eric Sandeen wrote:
> Agreed.  If you think fsck shouldn't silently cope with this mistake,
> and instead punish the user for it (it is what they asked for, after
> all), I'm ok with that too.  I'm willing to close my end as NOTABUG if
> you don't want to take this patch.  :)

I'm willing to take the patch, although I am thinking that it might be
appropriate for fsck to print a warning message --- "Bind mount with
non-zero fsck pass, skipping", or some such.

What do you think?

							- Ted
