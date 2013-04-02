From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Excessive stall times on ext4 in 3.9-rc2
Date: Tue, 2 Apr 2013 11:14:36 -0400
Message-ID: <20130402151436.GC31577@thunk.org>
References: <20130402142717.GH32241@suse.de>
 <20130402150651.GB31577@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Mel Gorman <mgorman@suse.de>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
	Jiri Slaby <jslaby@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20130402150651.GB31577@thunk.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 02, 2013 at 11:06:51AM -0400, Theodore Ts'o wrote:
> 
> Can you try 3.9-rc4 or later and see if the problem still persists?
> There were a number of ext4 issues especially around low memory
> performance which weren't resolved until -rc4.

Actually, sorry, I took a closer look and I'm not as sure going to
-rc4 is going to help (although we did have some ext4 patches to fix a
number of bugs that flowed in as late as -rc4).

Can you send us the patch that you used to get record these long stall
times?  And I assume you're using a laptop drive?  5400RPM or 7200RPM?

	      	     	    	    	   - Ted

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
