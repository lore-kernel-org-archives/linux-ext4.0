From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Wed, 14 Aug 2013 13:50:02 -0700
Message-ID: <520BED7A.4000903@intel.com>
References: <520BB9EF.5020308@linux.intel.com>
	<20130814194359.GA22316@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@linux.intel.com>,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>,
	david@fromorbit.com, Tim Chen <tim.c.chen@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20130814194359.GA22316@thunk.org>
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

On 08/14/2013 12:43 PM, Theodore Ts'o wrote:
> Thanks dave for doing this comparison.  Is there any chance you can
> check whether lockstats shows anything interesting?
> 
>> Test case is this:
>>
>> 	https://github.com/antonblanchard/will-it-scale/blob/master/tests/page_fault3.c
> 
> One interesting thing about the test case.  It looks like the first
> time through the while loop, the file will need to be extended (since
> it is a new tempfile).  But subsequent times through the list the
> blocks for the file will already be allocated.  If the file is
> prezero'ed ahead of time, so we're only measuring the cost of the
> write page fault, and we take block allocation out of the comparison,
> do we see the same scalability curve?

Would a plain old fallocate() do the trick, or does it actually need
zeros written to it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
