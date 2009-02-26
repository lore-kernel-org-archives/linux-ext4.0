From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] don't call jbd2_journal_force_commit_nested w/o journal
Date: Thu, 26 Feb 2009 01:00:01 -0500
Message-ID: <20090226060001.GB7227@mit.edu>
References: <49A5A6D9.2080602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57522 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbZBZGAE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Feb 2009 01:00:04 -0500
Content-Disposition: inline
In-Reply-To: <49A5A6D9.2080602@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 25, 2009 at 02:15:21PM -0600, Eric Sandeen wrote:
> Running without a journal, I oopsed when I ran out of space,
> because we called jbd2_journal_force_commit_nested() from
> ext4_should_retry_alloc() without a journal.
> 
> This should take care of it, I think.

Thanks applied in the ext4 patch queue.

						- Ted
