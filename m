From: tytso@mit.edu
Subject: Re: [PATCH] mke2fs: fix up topo complaints on regular files
Date: Sat, 6 Feb 2010 08:01:26 -0500
Message-ID: <20100206130126.GB321@thunk.org>
References: <4B5BC395.2050805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44601 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491Ab0BFNBb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 6 Feb 2010 08:01:31 -0500
Content-Disposition: inline
In-Reply-To: <4B5BC395.2050805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 23, 2010 at 09:50:45PM -0600, Eric Sandeen wrote:
> mkfsing a plain file would lead to a warning about being unable
> to determine geometry; we should just skip the topology-getting
> if we see that we have a regular file.
> 
> This was breaking "make check" but I had missed it since I
> inadvertently stopped running the checks during the Fedora
> RPM build.
> 
> Also, add a newline to the warning.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

					- Ted
