From: Chris Mason <chris.mason@oracle.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Wed, 29 Feb 2012 09:05:49 -0500
Message-ID: <20120229140549.GC5054@shiny>
References: <CADDYkjRnRKPMW53F=oELhwkSt5EQB9v0JkC=inNvZQPKu94Xtw@mail.gmail.com>
 <20120229135158.GA5054@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, "Ted Ts'o" <tytso@mit.edu>
To: Jacek Luczak <difrost.kernel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:50605 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995Ab2B2OWl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Feb 2012 09:22:41 -0500
Content-Disposition: inline
In-Reply-To: <20120229135158.GA5054@shiny>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 29, 2012 at 08:51:58AM -0500, Chris Mason wrote:
> On Wed, Feb 29, 2012 at 02:31:03PM +0100, Jacek Luczak wrote:
> > Ext4 results:
> > | Type     | 2.6.39.4-3   | 3.2.7
> > | Dir cnt  | 17m 40sec  | 11m 20sec
> > | File cnt |  17m 36sec | 11m 22sec
> > | Copy    | 1h 28m        | 1h 27m
> > | Remove| 3m 43sec
> 
> Are the btrfs numbers missing? ;)

[ answered in a different reply, btrfs is faster in everything except
delete ]

The btrfs readdir uses an index that is much more likely to be
sequential on disk than ext.  This makes the readdir more sequential and
it makes the actual file IO more sequential because we're reading things
in the order they were created instead of (random) htree index order.

> 
> In order for btrfs to be faster for cp -a, the files probably didn't
> change much since creation.  Btrfs maintains extra directory indexes
> that help in sequential backup scans, but this usually means slower
> delete performance.
> 
> But, how exactly did you benchmark it?  If you compare a fresh
> mkfs.btrfs where you just copied all the data over with an ext4 FS that
> has been on the disk for a long time, it isn't quite fair to ext4.
> 

But, the consistent benchmarking part is really important.  We shouldn't
put an aged ext4 up against a fresh mkfs.btrfs.  Did you do ext4
comparisons on a fresh copy?

-chris

