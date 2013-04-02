From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: Excessive stall times on ext4 in 3.9-rc2
Date: Tue, 02 Apr 2013 17:00:12 +0200
Message-ID: <515AF27C.2060206@suse.cz>
References: <20130402142717.GH32241@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
To: Mel Gorman <mgorman@suse.de>, linux-ext4@vger.kernel.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130402142717.GH32241@suse.de>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On 04/02/2013 04:27 PM, Mel Gorman wrote:
> I'm testing a page-reclaim-related series on my laptop that is partially
> aimed at fixing long stalls when doing metadata-intensive operations on
> low memory such as a git checkout. I've been running 3.9-rc2 with the
> series applied but found that the interactive performance was awful even
> when there was plenty of free memory.
> 
> I activated a monitor from mmtests that logs when a process is stuck for
> a long time in D state and found that there are a lot of stalls in ext4.
> The report first states that processes have been stalled for a total of
> 6498 seconds on IO which seems like a lot. Here is a breakdown of the
> recorded events.

Just a note that I am indeed using ext4 on the affected machine for all
filesystems I have except for an efi partition...

-- 
js
suse labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
