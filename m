From: Dave Chinner <david@fromorbit.com>
Subject: Re: large directory entry
Date: Sat, 2 May 2015 10:28:45 +1000
Message-ID: <20150502002845.GE15810@dastard>
References: <alpine.DEB.2.20.7.1504301634450.29119@trent.utfs.org>
 <20150501143147.GB9936@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Kujau <lists@nerdbynature.de>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:63209 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383AbbEBA2t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 May 2015 20:28:49 -0400
Content-Disposition: inline
In-Reply-To: <20150501143147.GB9936@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 01, 2015 at 10:31:47AM -0400, Theodore Ts'o wrote:
> On Thu, Apr 30, 2015 at 10:02:58PM -0700, Christian Kujau wrote:
> > Notice the "18M" entry for "." - I realize this is a directory for 
> > temporary files, meaning that lots of files are generated here, but
> > the server is not _that_ busy; according to lsof(8) no files are
> > currently open in /var/lib/php5 and only the "sessions" directory
> > contains 100 files, there are far less files below the other directories.
> 
> That's simply because shrinking directories while the file system is
> mounted is... tricky.  At some point we might try to get this
> supported, but until we do, there are two workarounds:
.....
> I'm not sure I would call this a bug; it's a long standing proper of
> ext2/3/4, the BSD FFS, etc., which is directories can't get shurnk by
> the file system.  At some point the directory had enough files in it
> that it grew to that size, and once having grown to that size, it
> won't shirnk on its own.

Interesting - I didn't realise that ext4 had this property. I'm so
used to XFS where the directory structure grows and shrinks
according to it's contents. I learnt something new about ext4 today!

> It would be possible to enhance ext4 to be able to shrink directories
> on-line, but it would require adding a new file system (to allow
> sparse directories),

Yeah, XFS directories are sparsely mapped files with internal
indexes to maintain constant offset mappings and index free space.
It is rather complex... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
