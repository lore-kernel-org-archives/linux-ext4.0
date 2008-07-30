From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [Bug 11175] New: ext3 BUG in add_dirent_to_buf+0x6c/0x269
Date: Tue, 29 Jul 2008 22:48:56 -0400
Message-ID: <20080730024856.GE29748@mit.edu>
References: <bug-11175-27@http.bugzilla.kernel.org/> <20080729171207.d88728cf.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
	kernel.bugzilla@asheesh.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:44643 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759339AbYG3Ctr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jul 2008 22:49:47 -0400
Content-Disposition: inline
In-Reply-To: <20080729171207.d88728cf.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hmm... disassembling the code, it's pretty clear the problem is here
in do_split(), around line 1208:

	map = (struct dx_map_entry *) (data2 + blocksize);
	count = dx_make_map ((struct ext3_dir_entry_2 *) data1,
			     blocksize, hinfo, map);
	map -= count;
	dx_sort_map (map, count);
	/* Split the existing block in the middle, size-wise */
	size = 0;
	move = 0;
	for (i = count-1; i >= 0; i--) {
		/* is more than half of this entry in 2nd half of the block? */
		if (size + map[i].size/2 > blocksize/2)  <====
			break;
		size += map[i].size;
		move++;
	}

I suspect dx_make_map returned 0, and since i and count are an
unsigned int, things started to go downhill after i was assigned the
value of ((unsigned) -1).

How could this happen?  The only way thing I can think of is a
directory block with a large number of deleted directory entries that
were not coalesced for some reason.  That shouldn't happen normally,
but that's the only explanation I can think of why we might be trying
to split an directory block where dx_make_map() is returning 0.

Asheesh, are you willing to recompile a kernel with some debugging
code inserted?

						- Ted
