From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v5 1/5] vfs: add support for a lazytime mount option
Date: Tue, 2 Dec 2014 16:01:19 -0500
Message-ID: <20141202210119.GD13618@thunk.org>
References: <1417154411-5367-1-git-send-email-tytso@mit.edu>
 <1417154411-5367-2-git-send-email-tytso@mit.edu>
 <20141128172323.GD738@quack.suse.cz>
 <20141128181421.GA19461@google.com>
 <20141202125820.GE9092@quack.suse.cz>
 <547DFD24.9070805@plexistor.com>
 <20141202192337.GA13618@thunk.org>
 <0CAF91FD-F713-4E98-8967-9CA0390CA784@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0CAF91FD-F713-4E98-8967-9CA0390CA784@dilger.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 02, 2014 at 01:37:27PM -0700, Andreas Dilger wrote:
> 
> One thing that comes to mind is touch/utimes()/utimensat().  Those
> should definitely not result in timestamps being kept only in memory
> for 24h, since the whole point of those calls is to update the times.
> It makes sense for these APIs to dirty the inode for proper writeout.

Not a problem.  Touch/utimes* go through notify_change() and
->setattr, so they won't go through the I_DIRTY_TIME code path.

	      	   	    	    	- Ted
