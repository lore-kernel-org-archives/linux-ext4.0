From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.24-rc6 -mm
	patch]
Date: Sun, 20 Jan 2008 21:51:17 -0500
Message-ID: <20080121025117.GB8105@mit.edu>
References: <200801140839.01986.abhishekrai@google.com> <20080115152801.GA7292@mit.edu> <d9885f0f0801170447r1c2bfeb9l6c911bfa0113366f@mail.gmail.com> <200801192010.20699.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Abhishek Rai <abhishekrai@google.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, rohitseth@google.com,
	linux-ext4@vger.kernel.org
To: Daniel Phillips <phillips@phunq.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:35514 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753236AbYAUCwM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Jan 2008 21:52:12 -0500
Content-Disposition: inline
In-Reply-To: <200801192010.20699.phillips@phunq.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 19, 2008 at 08:10:20PM -0800, Daniel Phillips wrote:
> 
> I can see value in preemptively loading indirect blocks into the buffer 
> cache, but is building a second-order extent tree really worth the 
> effort?  Probing the buffer cache is very fast.

It's not that much effort, and for a big database (say, like a 50GB
database file), the indirect blocks would take up 50 megabytes of
memory.  Collapsing it into an extent tree would save that memory into
a few kilobytes.  I suppose a database server would probably have
5-10GB's of memory, so the grand scheme of things it's not a vast
amount of memory, but the trick is keeping the indirect blocks pinned
so they don't get pushed out by some vast, gigunndo Java application
running in the same server as the database.  If you have the indirect
blocks encoded into the extent tree, then you don't have to worry
about that.

            	       	     	     	   - Ted
