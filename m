From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 unkillable lseek.
Date: Wed, 13 Jan 2016 12:00:21 -0500
Message-ID: <20160113170021.GD30894@thunk.org>
References: <20160112145348.GA15634@codemonkey.org.uk>
 <723A6BDE-4D73-47A5-BF0B-7A3D4ACD2C6A@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Jones <davej@codemonkey.org.uk>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <723A6BDE-4D73-47A5-BF0B-7A3D4ACD2C6A@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 12, 2016 at 02:17:43PM -0700, Andreas Dilger wrote:
> 
> It looks like ext4_es_find_delayed_extent_range() is being called once
> for every block in the file looking for any delalloc data, which is
> pretty awful.  Checking the git history for this code, it seems it was
> fixed once upon a time in commit 14516bb7bb:
> 
>     ext4: fix suboptimal seek_{data,hole} extents traversial
> 
>     It is ridiculous practice to scan inode block by block, this technique
>     applicable only for old indirect files. This takes significant amount
>     of time for really large files. Let's reuse ext4_fiemap which already
>     traverse inode-tree in most optimal meaner.
> 
>     TESTCASE:
>     ftruncate64(fd, 0);
>     ftruncate64(fd, 1ULL << 40);
>     /* lseek will spin very long time */
>     lseek64(fd, 0, SEEK_DATA);
>     lseek64(fd, 0, SEEK_HOLE);
> 
>     Original report: https://lkml.org/lkml/2014/10/16/620
> 
>     Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> but it was later reverted in ad7fefb10 because of a problem with ext3 and
> never restored.

The relevant thread dates back to January 3, 2015 when it went
dead/dormant.  The last message from Dimitri was:

>Crap. I do not understand why I cant not reproduce this.
>I'm out of my normal dev environment for couple of days,
>so patch reverting looks reasonable.  But please add code which
>break the loop on signal because otherwise this result in DOS for huge file

We never did do that last bit, which is probably what we should do as
a short-term fix until we can debug the "fix suboptimal seek_{data,hole}
extents traversal" patch.

							- Ted
