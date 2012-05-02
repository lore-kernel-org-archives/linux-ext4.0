From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Support systems without posix_memalign() and memalign()
Date: Wed, 2 May 2012 15:40:58 -0400
Message-ID: <20120502194058.GA18002@thunk.org>
References: <1335983451-30160-1-git-send-email-tytso@mit.edu>
 <C93BF332-FFF4-45E1-811D-6E641F54C9BD@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ksumrall@google.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55774 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756137Ab2EBTlE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 May 2012 15:41:04 -0400
Content-Disposition: inline
In-Reply-To: <C93BF332-FFF4-45E1-811D-6E641F54C9BD@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 02, 2012 at 12:52:06PM -0600, Andreas Dilger wrote:
> 
> Won't this cause e.g. the 16kB/64kB blocksize regression tests to
> fail on MacOS?  I've been assuming that the memalign functionality
> is only necessary for O_DIRECT, which isn't even working on MacOS,
> so it is enough to just return an unaligned memory chunk and it
> will work for normal buffered IO on MacOS.

Hmm, good point.  What we should probably do is fix things so we only
try to use ext2fs_get_memalign() if we are doing O_DIRECT in the first
place, since can be be overhead using ext2fs_memalign if it's not
needed, especially if we are using valloc().

I don't want to leave ext2fs_get_memalign doing something which isn't
as the function is documented, even if it's good enough for our
current needs and it will just work today.  That leaves behind an
accident waiting to happen later on --- for example if some progam
uses ext2fs_get_memalign() for some use other than what we currently
assume that it will be used for...

							 - Ted
