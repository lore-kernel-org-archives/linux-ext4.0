From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 17/25] mke2fs: Do not let -t or -T be specified more
 than once
Date: Fri, 16 Sep 2011 18:57:54 -0400
Message-ID: <20110916225754.GU16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-18-git-send-email-sandeen@redhat.com>
 <20110916225720.GT16246@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49480 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454Ab1IPW5z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 18:57:55 -0400
Content-Disposition: inline
In-Reply-To: <20110916225720.GT16246@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 06:57:20PM -0400, Ted Ts'o wrote:
> On Fri, Sep 16, 2011 at 03:49:32PM -0500, Eric Sandeen wrote:
> > In addition to not making since, it causes a memory leak
> > when fs_type gets overwritten.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Applied, with whitespace cleanups.

Oh, and s/since/sense/

					- Ted
