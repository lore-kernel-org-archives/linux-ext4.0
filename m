From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: fix configure.in typo
Date: Wed, 21 Oct 2009 18:19:32 -0400
Message-ID: <20091021221932.GC20619@mit.edu>
References: <4ADE8477.2070906@redhat.com> <20091021075232.GA9574@mit.edu> <4ADF2711.50405@redhat.com> <20091021215751.GB20619@mit.edu> <4ADF87B9.3040204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:35189 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762AbZJUWTd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Oct 2009 18:19:33 -0400
Content-Disposition: inline
In-Reply-To: <4ADF87B9.3040204@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 21, 2009 at 05:14:17PM -0500, Eric Sandeen wrote:
> oh dear, maybe that's it :)
> 
> Ok, on a fresh checkout it worked...
> 
> Sorry, not sure what state I got things into.

Git status should have shown the "extra" file; I make a practice of
using "git status" often to make sure there aren't any files I forgot
to check in, or anything other unexpected discrepancies between the
head of the git tree and the working directory.

					- Ted
