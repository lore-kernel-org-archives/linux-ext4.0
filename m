From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/7] libext2fs: use abort() instead of perror()/exit()
Date: Tue, 31 Jul 2012 16:04:58 -0400
Message-ID: <20120731200458.GE32228@thunk.org>
References: <20120628024356.GB17989@thor.bakeyournoodle.com>
 <1343684862-13181-1-git-send-email-tytso@mit.edu>
 <1343684862-13181-2-git-send-email-tytso@mit.edu>
 <C4F449DF-59AB-4E63-9545-9D2F8F912563@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"tony@bakeyournoodle.com" <tony@bakeyournoodle.com>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42358 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271Ab2GaUFB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jul 2012 16:05:01 -0400
Content-Disposition: inline
In-Reply-To: <C4F449DF-59AB-4E63-9545-9D2F8F912563@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 31, 2012 at 11:34:38AM -0700, Andreas Dilger wrote:
> On 2012-07-30, at 14:47, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> > This simplifies the number of C library symbols needed by boot loader
> > systems such as yaboot.
> 
> This doesn't improve the debugability of the code at all. Instead of
> getting an error message (as cryptic as it was), now there is no
> error and the process will just die.

Well, at least for e2fsck, which is the program I was most concerned
about, the debuggability will actually improve, since
e2fsck/sigcatcher.c will give you a very nice stack backtrace (at
least, if your libc has the backtrace function).

> I'm guessing from the original coding that there is no error
> handling for this case?

Yes, the problem is that the ext2fs_{mark,unmark}_{block,inode}_bitmap()
functions return void, and changing this would require massive changes
all up and down the stack.

Even if they had originally return an errcode_t, given that with the
simple bit array implementation, they could Never Fail(tm), it's
likely that most if not all of the code sites would not have checked
them, and even if they did, all they could really do at that point is
die.  And if they didn't, then it would be even harder to debug why
the bitmap function was became a no-op due to a memory allocation
failure.

Sigh; I've become convinced that the Go language's philosphy not
letting memory allocation fail (and just simply dying if you can't
allocate the memory you need) is the Right Thing 99.99% of the time.


						- Ted
