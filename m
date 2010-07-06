From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: inconsistent file placement
Date: Tue, 06 Jul 2010 18:39:07 -0500
Message-ID: <4C33BE9B.4010402@redhat.com>
References: <469D2D911E4BF043BFC8AD32E8E30F5B24AED8@wdscexbe07.sc.wdc.com> <20100706185548.GA26677@thunk.org> <4C337D16.9000200@redhat.com> <469D2D911E4BF043BFC8AD32E8E30F5B24AEDB@wdscexbe07.sc.wdc.com> <20100706231412.GA7646@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Daniel Taylor <Daniel.Taylor@wdc.com>, amir73il@gmail.com,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab0GFXjP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Jul 2010 19:39:15 -0400
In-Reply-To: <20100706231412.GA7646@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> On Tue, Jul 06, 2010 at 03:15:00PM -0700, Daniel Taylor wrote:

...

> 
> Speaking of fallocate.... if this is a NAS box than the file is
> probably written using CIFS, right?  Are you using a modern version of
> Samba?  If you are use a new enough libc (that understands the
> fallocate system call) and a new enough version of Samba, the
> userspace should be using fallocate() to more efficiently allocate the
> space.  This is a feature which is not in ext3, but it is supported by
> ext4, and it's a major win.  The basic idea was discovered a while
> ago, and was written up here:
> 
> http://software.intel.com/en-us/articles/windows-client-cifs-behavior-can-slow-linux-nas-performance/
> 
> (This was a 2007 report, and back then ext4 wasn't ready, so the only
> file system available was XFS, which did have both delayed allocation
> and fallocate support for preallocation.  XFS is a good filesystem,
> although it often tends to be a bit memory-hungry for many bookshelf
> NAS systems.)

XFS is actually a favorite of the ARM embedded NAS space :)

> See also see here for a patch (but I'm pretty sure this functionality
> is already in the most recent version of Samba if I recall correctly):
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=525532

that patch is rather simplistic, FWIW; at least for XFS it -hurt- perf
due to the unwritten->written conversion and the relatively small, frequent
preallocations.

More smarts to merge up multiple 1-byte-writes into a large preallocation
might help, as the bug mentions.

But ... is something like it already in samba?  that'd be nifty, but I wasn't
aware of that.  There is a preallocation-sounding switch but I think it doesn't
do what you think it does.  I'd have to go look up details, though.

-Eric

> I know a fair number of folks on the Samba core team; most of them
> have been hired by companies to work full-time on CIFS support
> (usually using Samba), but some of them may still be available to help
> out on a consulting basis... let me know if you'd like me to make some
> introductions.
> 
> 							- Ted
> 
> P.S.  Amir, this is one of the reason why you folks should seriously think
> about merging Next3 support into ext4.  :-)

