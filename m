From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [Jfs-discussion] benchmark results
Date: Sun, 27 Dec 2009 13:55:26 -0800 (PST)
Message-ID: <alpine.DEB.2.01.0912271346240.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de> <19251.26403.762180.228181@tree.ty.sabi.co.uk> <20091224212756.GM21594@thunk.org> <alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de> <20091225161453.GD32757@thunk.org>
 <20091225162238.GB19303@bitmover.com> <alpine.DEB.2.01.0912251042540.3483@bogon.housecafe.de> <4B36333B.3030600@hp.com> <4B365EBE.5050804@nerdbynature.de> <4B37BA76.7050403@hp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Larry McVoy <lm@bitmover.com>, tytso@mit.edu,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org,
	Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>,
	ext-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <4B37BA76.7050403@hp.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 27 Dec 2009 at 14:50, jim owens wrote:
> And I don't even care about comparing 2 filesystems, I only care about
> timing 2 versions of code in the single filesystem I am working on,
> and forgetting about hardware cache effects has screwed me there.  

Not me, I'm comparing filesystems - and when the HBA or whatever plays 
tricks and "sync" doesn't flush all the data, it'll do so for every tested 
filesystem. Of course, filesystem could handle "sync" differently, and 
they probably do, hence the different times they take to complete. That's 
what my tests are about: timing comparision (does that still fall under 
the "benchmark" category?), not functional comparision. That's left as a 
task for the reader of these results: "hm, filesystem xy is so much faster 
when doing foo, why is that? And am I willing to sacrifice e.g. proper 
syncs to gain more speed?"

> So unless you are sure you have no hardware cache effects...
> "the comparison still stands" is *false*.

Again, I don't argue with "hardware caches will have effects", but that's 
not the point of these tests. Of course hardware is different, but 
filesystems are too and I'm testing filesystems (on the same hardware).

Christian.
-- 
BOFH excuse #278:

The Dilithium Crystals need to be rotated.
