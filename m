From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] vfs: don't let the dirty time inodes get more than a
	day stale
Date: Mon, 24 Nov 2014 23:45:08 -0500
Message-ID: <20141125044508.GG31339@thunk.org>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-4-git-send-email-tytso@mit.edu>
	<20141125015332.GE27262@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20141125015332.GE27262@dastard>
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

On Tue, Nov 25, 2014 at 12:53:32PM +1100, Dave Chinner wrote:
> On Fri, Nov 21, 2014 at 02:59:23PM -0500, Theodore Ts'o wrote:
> > Guarantee that the on-disk timestamps will be no more than 24 hours
> > stale.
> > 
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> If we put these inodes on the dirty inode list with at writeback
> time of 24 hours, this is completely unnecessary.

What do you mean by "a writeback time of 24 hours"?  Do you mean
creating a new field in the inode which specifies when the writeback
should happen?  I still worry about the dirty inode list getting
somewhat long large in the strictatime && lazytime case, and the inode
bloat nazi's coming after us for adding a new field to struct inode
structure.

Or do you mean trying to abuse the dirtied_when field in some way?

      	       	      	       	   - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
