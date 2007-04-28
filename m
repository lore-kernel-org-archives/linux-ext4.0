From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
Date: Sun, 29 Apr 2007 00:38:03 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0704290006330.12830@artax.karlin.mff.cuni.cz>
References: <1177660767.6567.41.camel@Homer.simpson.net>
 <20070427013350.d0d7ac38.akpm@linux-foundation.org>
 <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
 <alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>
 <20070427193130.GD5967@schatzie.adilger.int>
 <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org>
 <20070427201235.GA11170@gnuppy.monkey.org> <Pine.LNX.4.64.0704280708500.9055@artax.karlin.mff.cuni.cz>
 <20070428215756.GA13477@gnuppy.monkey.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andreas Dilger <adilger@clusterfs.com>,
	Marat Buharov <marat.buharov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Alex Tomas <alex@clusterfs.com>
To: Bill Huey <billh@gnuppy.monkey.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:37636 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031290AbXD1WiG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 28 Apr 2007 18:38:06 -0400
In-Reply-To: <20070428215756.GA13477@gnuppy.monkey.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Sat, Apr 28, 2007 at 07:37:17AM +0200, Mikulas Patocka wrote:
>> SpadFS doesn't write to unallocated parts like log filesystems (LFS) or
>> phase tree filesystems (TUX2); it writes inside normal used structures,
>> but it marks each structure with generation tags --- when it updates
>> global table of tags, it atomically makes several structures valid. I
>> don't know about this idea being used elsewhere.
>
> So how is this generation structure organized ? paper ?

Paper is in CITSA 2006 proceedings (but you likely don't have them and I 
signed some statement that I can't post it elsewhere :-( )

Basicly the idea is this:
* you have array containing 65536 32-bit numbers --- crash count table --- 
that array is on disk and in memory (see struct __spadfs->cct in my sources)
* you have 16-bit value --- crash count, that value is on disk and in memory 
too (see struct __spadfs->cc)

* On mount, you load crash count table and crash count from disk to 
memory. You increment carsh count on disk (but leave old in memory). You 
increment one entry in crash count table - cct[cc] in memory, but leave 
old on disk.
* On sync you write all metadata buffers, do write barrier, write one 
sector of crash count table from memory to disk and do write 
barrier again.
* On unmount, you sync and decrement crash count on disk.

--- so crash count counts crashes --- it is increased each time you mount 
and don't unmount.

Consistency of structures:
* Each directory entry has two tags --- 32-bit transaction count (txc) 
and 16-bit crash count(cc).
* You create directory entry with entry->txc = fs->txc[fs->cc] and 
entry->cc = fs->cc
* Directory entry is considered valid if fs->txc[entry->cc] >= entry->txc 
(see macro CC_VALID)
* If the directory entry is not valid, it is skipped during directory 
scan, as if it wasn't there
--- so you create a directory entry and its valid. If the system crashes, 
it will load crash count table from disk and there's one-less value than 
entry->txc, so the entry will be invalid. It will also run with increased 
cc, so it will never touch txc at an old index, so the entry will be valid 
forever.
--- if you sync, you write crash count table to disk and directory entry 
will be atomically made valid forever (because values in crash count table 
never decrease)

In my implementation, the top bit of entry->txc is used to mark whether 
the entry is scheduled for adding or delete, so that you can atomically 
add one directory entry and delete other.

Space allocation bitmaps or lists are managed in such a way that there are 
two copies and cc/txc pair determining which one is valid.

Files are extended in such a way that each file has two "size" entries and 
cc/txc pair denoting which one is valid, so that you can atomically 
extend/truncate file and mark its space allocated/freed in bitmaps or 
lists (BTW. this cc/txc pair is the same one that denotes if the directory 
entry is valid and another bit determines one of these two functions --- 
to save space).

Mikulas
