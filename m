From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 05/11] ext4: Make sure blocks are properly allocated
	under mmaped page even when blocksize < pagesize
Date: Wed, 27 May 2009 10:30:06 -0400
Message-ID: <20090527143006.GC10842@mit.edu>
References: <1243429268-3028-1-git-send-email-jack@suse.cz> <1243429268-3028-6-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de,
	linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36784 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758598AbZE0OaP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 May 2009 10:30:15 -0400
Content-Disposition: inline
In-Reply-To: <1243429268-3028-6-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 27, 2009 at 03:01:02PM +0200, Jan Kara wrote:
> In a situation like:
>   truncate(f, 1024);
>   a = mmap(f, 0, 4096);
>   a[0] = 'a';
>   truncate(f, 4096);
> 
> we end up with a dirty page which does not have all blocks allocated /
> reserved.  Fix the problem by using new VFS infrastructure.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Hi Jan,

Have you tested with -o nodelalloc?  There is apparently a problem
with ext4 when blocksize < pagesize which Aneesh has been working on.
He has been able to reproduce the problem, and theorized that an
earlier version your patch set would address the problem, but it
apparently did not.  See:

	http://bugzilla.kernel.org/show_bug.cgi?id=13369

... and Aneesh can provide more details.  Aneesh, you might want to
try testing with this latest set and see if you can reproduce the
problem with this set.

						- Ted
