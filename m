From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Excessive stall times on ext4 in 3.9-rc2
Date: Tue, 2 Apr 2013 11:06:51 -0400
Message-ID: <20130402150651.GB31577@thunk.org>
References: <20130402142717.GH32241@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>
To: Mel Gorman <mgorman@suse.de>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20130402142717.GH32241@suse.de>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 02, 2013 at 03:27:17PM +0100, Mel Gorman wrote:
> I'm testing a page-reclaim-related series on my laptop that is partially
> aimed at fixing long stalls when doing metadata-intensive operations on
> low memory such as a git checkout. I've been running 3.9-rc2 with the
> series applied but found that the interactive performance was awful even
> when there was plenty of free memory.

Can you try 3.9-rc4 or later and see if the problem still persists?
There were a number of ext4 issues especially around low memory
performance which weren't resolved until -rc4.

Thanks,

						- Ted

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
