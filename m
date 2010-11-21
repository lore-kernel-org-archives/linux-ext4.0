From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [BUG?] [Ext4] INFO: suspicious rcu_dereference_check() usage
Date: Sun, 21 Nov 2010 12:37:26 -0500
Message-ID: <20101121173726.GG23423@thunk.org>
References: <20101121112611.GB4267@deepthought.bhanu.net>
 <20101121133024.GF23423@thunk.org>
 <20101121153949.GD20947@barrios-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Paul McKenney <paulmck@linux.vnet.ibm.com>,
	Eric Sandeen <sandeen@redhat.com>
To: Minchan Kim <minchan.kim@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20101121153949.GD20947@barrios-desktop>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 22, 2010 at 12:39:49AM +0900, Minchan Kim wrote:
> 
> I think it's no problem. 
> 
> That's because migration always holds lock_page on the file page.
> So the page couldn't remove from radix. 

It may be "ok" in that it won't cause a race, but it still leaves an
unsightly warning if LOCKDEP is enabled, and LOCKDEP warnings will
cause /proc_lock_stat to be disabled.  So I think it still needs to be
fixed by adding rcu_read_lock()/rcu_read_unlock() to
migrate_page_move_mapping().

      	 					     - Ted

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom policy in Canada: sign http://dissolvethecrtc.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
