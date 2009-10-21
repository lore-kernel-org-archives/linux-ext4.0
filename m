From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: fix configure.in typo
Date: Wed, 21 Oct 2009 17:57:51 -0400
Message-ID: <20091021215751.GB20619@mit.edu>
References: <4ADE8477.2070906@redhat.com> <20091021075232.GA9574@mit.edu> <4ADF2711.50405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:40482 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbZJUV5z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Oct 2009 17:57:55 -0400
Content-Disposition: inline
In-Reply-To: <4ADF2711.50405@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 21, 2009 at 10:21:53AM -0500, Eric Sandeen wrote:
> 
> seems like it's not picking up the system /usr/include/blkid/blkid.h but
> rather e2fsprogs/lib/blkid/blkid.h
> 

Um, in the maint branch e2fsprogs/lib/blkid/blkid.h no longer exists
in the Git tree.  It's been renamed to e2fsprogs/lib/blkid/blkid.h.in,
and blkid.h is only built if libblkid is enabled.

Perhaps you have a stale file that wasn't deleted by git?

						- Ted
