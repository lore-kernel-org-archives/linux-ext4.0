From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] blkid: fix swap tests (again)
Date: Sat, 21 Jun 2008 14:23:19 -0400
Message-ID: <20080621182318.GA26070@mit.edu>
References: <485968FF.3020905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:35788 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752010AbYFUSX0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Jun 2008 14:23:26 -0400
Content-Disposition: inline
In-Reply-To: <485968FF.3020905@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 18, 2008 at 02:58:55PM -0500, Eric Sandeen wrote:
> Some architectures (ppc ...) need a bigger swapfile than is shipped,
> in the test image so the current re-make of swap was failing.
> 
> We could either ship a bigger image or just dd a bigger file...
> 
> There is one more minor problem with the tests; older mkswap does not
> support the -U uuid specification.  I'm not sure offhand what to do
> about that problem, or if it really needs fixing.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

						- Ted
