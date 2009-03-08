From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] debugfs - fix segfault on "stat" command with no open
	fs
Date: Sun, 8 Mar 2009 19:31:04 -0400
Message-ID: <20090308233103.GB5578@mit.edu>
References: <498231C4.6090203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Andrew Hecox <ahecox@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44177 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbZCIDPp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Mar 2009 23:15:45 -0400
Content-Disposition: inline
In-Reply-To: <498231C4.6090203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 29, 2009 at 05:46:28PM -0500, Eric Sandeen wrote:
> This is a regression from commit 
> 8fdf29117f922419bd5b3f741e5d554b1d5b8893, which attempts to access
> current_fs via a feature check before we check that it's open.
> 
> Just moving the feature check below the open check should fix it.

Thanks, applied to the e2fsprogs git tree.

						- Ted
