From: tytso@mit.edu
Subject: Re: inconsistent file placement
Date: Tue, 6 Jul 2010 19:14:12 -0400
Message-ID: <20100706231412.GA7646@thunk.org>
References: <469D2D911E4BF043BFC8AD32E8E30F5B24AED8@wdscexbe07.sc.wdc.com>
 <20100706185548.GA26677@thunk.org>
 <4C337D16.9000200@redhat.com>
 <469D2D911E4BF043BFC8AD32E8E30F5B24AEDB@wdscexbe07.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, amir73il@gmail.com,
	linux-ext4@vger.kernel.org
To: Daniel Taylor <Daniel.Taylor@wdc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57808 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab0GFXOS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Jul 2010 19:14:18 -0400
Content-Disposition: inline
In-Reply-To: <469D2D911E4BF043BFC8AD32E8E30F5B24AEDB@wdscexbe07.sc.wdc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 06, 2010 at 03:15:00PM -0700, Daniel Taylor wrote:
> 
> It is an unfortunate fact of life that simplistic benchmarks often
> drive sales.  This product will be a consumer NAS and when our
> internal runs of the common NAS benchmarks get inconsistent results,
> it creates a lot of concern.

Out of curiosity, what *are* the "common NAS benchmarks" in use today,
and who chooses them?

There have been times in the past when "common benchmarks" promulgated
by reviewers have done active harm in the industry, driving disk drive
manufacturers to chose unsafe defaults, all because the only thing
people paid attention to was crappy benchmarks.

Sometimes the right answer is to put a spotlight on deficient
benchmarks, and to try to change them...

> There's an option for ext4 (delayed allocation) that looks like it
> bypasses the "pid % 16" coloration.  I'll tinker some more with
> that and see how it goes.

Delayed allocation is the default for ext4.  If you are seeing random
behaviour there it's probably because you need to be smarter in how
you write them --- see my previous e-mail about using fallocate.

Speaking of fallocate.... if this is a NAS box than the file is
probably written using CIFS, right?  Are you using a modern version of
Samba?  If you are use a new enough libc (that understands the
fallocate system call) and a new enough version of Samba, the
userspace should be using fallocate() to more efficiently allocate the
space.  This is a feature which is not in ext3, but it is supported by
ext4, and it's a major win.  The basic idea was discovered a while
ago, and was written up here:

http://software.intel.com/en-us/articles/windows-client-cifs-behavior-can-slow-linux-nas-performance/

(This was a 2007 report, and back then ext4 wasn't ready, so the only
file system available was XFS, which did have both delayed allocation
and fallocate support for preallocation.  XFS is a good filesystem,
although it often tends to be a bit memory-hungry for many bookshelf
NAS systems.)

See also see here for a patch (but I'm pretty sure this functionality
is already in the most recent version of Samba if I recall correctly):

https://bugzilla.redhat.com/show_bug.cgi?id=525532

I know a fair number of folks on the Samba core team; most of them
have been hired by companies to work full-time on CIFS support
(usually using Samba), but some of them may still be available to help
out on a consulting basis... let me know if you'd like me to make some
introductions.

							- Ted

P.S.  Amir, this is one of the reason why you folks should seriously think
about merging Next3 support into ext4.  :-)
