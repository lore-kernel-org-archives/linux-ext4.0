From: Theodore Tso <tytso@mit.edu>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Tue, 19 May 2009 07:36:44 -0400
Message-ID: <20090519113644.GA7927@mit.edu>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu> <20090514110659.GA5146@kulgan> <20090514132506.GD5146@kulgan> <20090514140732.GI11352@mit.edu> <20090514143014.GH5146@kulgan> <20090514161254.GJ11352@mit.edu> <20090514210244.GL5146@kulgan> <20090514212325.GG21316@mit.edu> <m2iqjx5s4n.fsf@vador.mandriva.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>,
	Andreas Dilger <adilger@sun.com>, Alex Tomas <bzzz@sun.com>,
	linux-ext4@vger.kernel.org
To: Thierry Vignaud <tvignaud@mandriva.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:38910 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbZESLg7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 May 2009 07:36:59 -0400
Content-Disposition: inline
In-Reply-To: <m2iqjx5s4n.fsf@vador.mandriva.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 19, 2009 at 12:00:56PM +0200, Thierry Vignaud wrote:
> I wonder if that would explain the corruption I reported a couple weeks
> ago.
> 
> Now I remember I wrongly got 2 parallel cp from the same source
> directory to the same target directory.
>
> Could this be the cause?

Yes, it's possible.  There could be a problem either if the two cp's
tried targetting the same file at the same time, or if the directory
was getting expanded at the same time by the two different processes.
Since we don't cache logical->physical mapping for directories (since
because of the journalling requirements directories are stored in the
buffer cache, not the page cache), rather more likely to run into
problems with directories; more so since directoris will tend to be
fragmented.  

On the other hand, most of the time writes into the directory will
tend to be into pre-existing free space; but if you had two parallel
cp's copying a large number of files into the same directory, that
could certainly happen.

							- Ted


