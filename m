From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Wed, 14 Aug 2013 15:43:59 -0400
Message-ID: <20130814194359.GA22316@thunk.org>
References: <520BB9EF.5020308@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <ak@linux.intel.com>, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	Andy Lutomirski <luto@amacapital.net>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <520BB9EF.5020308@linux.intel.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

Thanks dave for doing this comparison.  Is there any chance you can
check whether lockstats shows anything interesting?

> Test case is this:
> 
> 	https://github.com/antonblanchard/will-it-scale/blob/master/tests/page_fault3.c

One interesting thing about the test case.  It looks like the first
time through the while loop, the file will need to be extended (since
it is a new tempfile).  But subsequent times through the list the
blocks for the file will already be allocated.  If the file is
prezero'ed ahead of time, so we're only measuring the cost of the
write page fault, and we take block allocation out of the comparison,
do we see the same scalability curve?


Thanks,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
