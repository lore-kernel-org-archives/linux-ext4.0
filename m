From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [Jfs-discussion] benchmark results
Date: Fri, 25 Dec 2009 10:51:05 -0800 (PST)
Message-ID: <alpine.DEB.2.01.0912251042540.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de> <19251.26403.762180.228181@tree.ty.sabi.co.uk> <20091224212756.GM21594@thunk.org> <alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de> <20091225161453.GD32757@thunk.org>
 <20091225162238.GB19303@bitmover.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, xfs@oss.sgi.com,
	reiserfs-devel@vger.kernel.org,
	Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>,
	ext-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Larry McVoy <lm@bitmover.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <20091225162238.GB19303@bitmover.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 25 Dec 2009 at 08:22, Larry McVoy wrote:
> Dudes, sync() doesn't flush the fs cache, you have to unmount for that.

Thanks Larry, that was exactly my point[0] too, I should add that to the 
results page to avoid further confusion or misassumptions:

   > Well, I do "sync" after each operation, so the data should be on
   > disk, but that doesn't mean it'll clear the filesystem buffers 
   > - but this doesn't happen that often in the real world too.

I realize however that on the same results page the bonnie++ tests were 
run with a filesize *specifically* set to not utilize the filesystem 
buffers any more but the measure *disk* performance while my "generic* 
tests do something else - and thus cannot be compared to the bonnie++ or 
hdparm results.

> No idea if that is still supported, but sync() is a joke for benchmarking.

I was using "sync" to make sure that the data "should" be on the disks 
now, I did not want to flush the filesystem buffers during the "generic" 
tests.

Thanks,
Christian.

[0] http://www.spinics.net/lists/linux-ext4/msg16878.html
-- 
BOFH excuse #210:

We didn't pay the Internet bill and it's been cut off.
