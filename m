From: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Mon, 14 Jan 2008 11:54:39 +0800
Message-ID: <E1JEGPH-0001uw-Df__30193.3937626474$1200282949$gmane$org@localhost.localdomain>
References: <200801071151.11200.lists@naasa.net> <200801130905.44855.jplatte@naasa.net> <400212488.11031@ustc.edu.cn> <200801131049.33111.jplatte@naasa.net> <20080113115933.GA11045@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Joerg Platte <jplatte@naasa.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755860AbYANDzM@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080113115933.GA11045@mail.ustc.edu.cn>
Message-Id: <E1JEGPH-0001uw-Df@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jan 13, 2008 at 07:59:33PM +0800, Fengguang Wu wrote:
> On Sun, Jan 13, 2008 at 10:49:31AM +0100, Joerg Platte wrote:
> > register_jprobe(ext2_writepage) = 0
> > register_jprobe(requeue_io) = 0
> > register_kprobe(submit_bio) = 0
> > requeue_io:
> > inode 114019(sda7/.kde) count 2,2 size 0 pages 1
> > 0	2	0	U____
> > requeue_io:
> > inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
> > 0	2	0	U____
> > requeue_io:
> > inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
> > 0	2	0	U____
> > requeue_io:
> > inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
> > 0	2	0	U____
> 
> It helps. Thank you, Joerg!
> 
> The .kde/cache-ibm/socket-ibm/0266584877 above are directories.
> It's weird that dirs would have their own mappings in ext2. In

Oh, ext2 dirs have their own mapping pages. Not the same with ext3.

> particular this bug is triggered because the dir mapping page has
> PAGECACHE_TAG_DIRTY set and PG_dirty cleared, staying in an
> inconsistent state.

Just found that a deleted dir will enter that inconsistent state when
someone still have reference to it...

