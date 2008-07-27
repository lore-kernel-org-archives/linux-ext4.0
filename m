From: Theodore Tso <tytso@mit.edu>
Subject: Re: [E2fsprogs] Compile error on RHEL4/ia64
Date: Sun, 27 Jul 2008 07:00:51 -0400
Message-ID: <20080727110050.GA8789@mit.edu>
References: <1217095878.3293.22.camel@alpha.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@Sun.COM>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Girish Shilamkar <Girish.Shilamkar@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:58674 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751030AbYG0LBI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jul 2008 07:01:08 -0400
Content-Disposition: inline
In-Reply-To: <1217095878.3293.22.camel@alpha.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 26, 2008 at 11:41:18PM +0530, Girish Shilamkar wrote:
> Hi Ted,
> 	While building e2fsprogs on ia64/rhel4 the following compile error was
> flagged:
> 
> Error messages:
> make[4]: Leaving directory `/cache/build/BUILD/e2fsprogs-1.40.7.sun1/lib/uuid'
>         CC clear.c
>         CC compare.c
>         CC copy.c
>         CC gen_uuid.c
> gen_uuid.c: In function `uuid__generate_time':
> gen_uuid.c:493: internal compiler error: in ia64_expand_load_address, at
> config/ia64/ia64.c:1184
> Please submit a full bug report,
> with preprocessed source if appropriate.
> See <URL:http://bugzilla.redhat.com/bugzilla> for instructions.
> Preprocessed source stored into /tmp/ccYkSBN6.out file, please attach this to
> your bugreport.
> make[3]: *** [gen_uuid.o] Error 1

Well, as stated above, this is very clearly an IA64 optimizer bug in
GCC where it's not able to handle __thread with a pretty specific
piece of code.

It's also on a relatively ancient distribution and GCC version.  You
could try reportig the bug to Red Hat to see if they are willing to
provide a fix.  Failing that, probably the best thing to do is just to
use configure --disable-tls on a RHEL4/ia64 system.  The main purpose
of the use of thread local storage is to avoid duplicate UUID's on SMP
systems when you have multiple threads generating UUID's at a very
high rate.

Certain database-driven applications will have a problem here, but
it's not clear it will matter for most users of Lustre.

Regards,

							- Ted
