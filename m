From: Dave Hansen <dave.hansen@intel.com>
Subject: ext4 extent status tree LRU locking
Date: Tue, 11 Jun 2013 16:22:16 -0700
Message-ID: <51B7B128.60909@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Jan kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I've got a test case which I intended to use to stress the VM a bit.  It
fills memory up with page cache a couple of times.  It essentially runs
30 or so cp's in parallel.

98% of my CPU is system time, and 96% of _that_ is being spent on the
spinlock in ext4_es_lru_add().  I think the LRU list head and its lock
end up being *REALLY* hot cachelines and are *the* bottleneck on this
test.  Note that this is _before_ we go in to reclaim and actually start
calling in to the shrinker.  There is zero memory pressure in this test.

I'm not sure the benefits of having a proper in-order LRU during reclaim
outweigh such a drastic downside for the common case.

Any thoughts?
