From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH RFC] ext3 data=guarded v3
Date: Wed, 15 Apr 2009 17:09:49 -0400
Message-ID: <20090415210949.GF21586@mit.edu>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com> <alpine.LFD.2.00.0904151333020.4042@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47449 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbZDOVKF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Apr 2009 17:10:05 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904151333020.4042@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 15, 2009 at 01:35:23PM -0700, Linus Torvalds wrote:
> I'm inclined to apply the first two patches as infrastructure, since they 
> seem to make sense regardless of data=ordered. The ability to get a 
> callback when IO ends sounds like something that a number of cases might 
> find intriguing, and it's obviously how the actual IO has worked 
> internally anyway.

The first two patches look good to me.  I haven't had time to go
through the last patch carefully (and that's the most complicated one
of course).  They don't currently have any in-kernel users, so it
fails the traditional test for inclusion, but the basic functionality
they provide makes a lot of sense to me.

					- Ted
