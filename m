From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Wed, 14 Aug 2013 19:06:48 -0400
Message-ID: <20130814230648.GD22316@thunk.org>
References: <520BB9EF.5020308@linux.intel.com>
	<20130814194359.GA22316@thunk.org> <520BED7A.4000903@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <ak@linux.intel.com>, Jan Kara <jack@suse.cz>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	Andy Lutomirski <luto@amacapital.net>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <520BED7A.4000903@intel.com>
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

On Wed, Aug 14, 2013 at 01:50:02PM -0700, Dave Hansen wrote:
> 
> Would a plain old fallocate() do the trick, or does it actually need
> zeros written to it?

It would be better to write zeros to it, so we aren't measuring the
cost of the unwritten->written conversion.

We could do a different test where at the end of each while loop, we
truncate the file and then do an fallocate, at which point we could be
measuring the scalability of the unwritten->written conversion as well
as the write page fault.  And that might be a useful thing to do at
some point.

But I'd suggest focusing on just the write page fault first, and then
once we're sure we've improved the scalability of that micro-operation
as much as possible, we can expand our scalability testing to include
either writing into fallocated space, or doing extending writes.

Cheers,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
