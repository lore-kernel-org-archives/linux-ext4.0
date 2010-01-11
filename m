From: Casey Allen Shobe <casey@shobe.info>
Subject: Re: [Jfs-discussion] benchmark results
Date: Sun, 10 Jan 2010 20:03:04 -0500
Message-ID: <AAA45328-6BEA-465C-B999-C99D45FC56FF@shobe.info>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de> <19251.26403.762180.228181@tree.ty.sabi.co.uk> <20091224212756.GM21594@thunk.org> <alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de> <20091225161453.GD32757@thunk.org> <20091225162238.GB19303@bitmover.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org,
	Christian Kujau <lists@nerdbynature.de>,
	linux-ext4@vger.kernel.org,
	Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>,
	reiserfs-devel@vger.kernel.org, ext-users <ext3-users@redhat.com>,
	xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
To: Larry McVoy <lm@bitmover.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091225162238.GB19303@bitmover.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Dec 25, 2009, at 11:22 AM, Larry McVoy wrote:
> Dudes, sync() doesn't flush the fs cache, you have to unmount for  
> that.
> Once upon a time Linux had an ioctl() to flush the fs buffers, I used
> it in lmbench.


You do not need to unmount - 2.6.16+ have a mechanism in /proc to  
flush caches.  See http://linux-mm.org/Drop_Caches

Cheers,
-- 
Casey Allen Shobe
casey@shobe.info

