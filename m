From: tytso@mit.edu
Subject: Re: [PATCH] e2fck: don't complain about i_size for known blocks
 past EOF
Date: Wed, 24 Feb 2010 11:25:31 -0500
Message-ID: <20100224162531.GC5166@thunk.org>
References: <4B56226E.2090204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46911 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab0BXQZe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Feb 2010 11:25:34 -0500
Content-Disposition: inline
In-Reply-To: <4B56226E.2090204@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 19, 2010 at 03:21:50PM -0600, Eric Sandeen wrote:
> This is the userspace side of Jiaying's EOFBLOCKS patch, I think.
> With Aneesh's patches for .33, Jiaying's patch, and this one,
> xfstests 013/fsstress (even with direct IO enabled) has held up
> through many runs.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied into the maint branch.

					- Ted
