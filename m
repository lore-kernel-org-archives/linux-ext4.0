From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: initialize large inodes for journal & resize
Date: Wed, 17 Jun 2009 19:52:29 -0400
Message-ID: <20090617235229.GG7867@mit.edu>
References: <4A385A0D.3040505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40354 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZFQXw2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jun 2009 19:52:28 -0400
Content-Disposition: inline
In-Reply-To: <4A385A0D.3040505@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 16, 2009 at 09:50:53PM -0500, Eric Sandeen wrote:
> I noticed that neither the journal nor resize inodes have
> i_extra_isize set post-mkfs; while this isn't likely
> to be a big problem, I think the below patch tidies
> it up.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, I've taken this patch into e2fsprogs's maint branch.

	     	   	      	   - Ted
