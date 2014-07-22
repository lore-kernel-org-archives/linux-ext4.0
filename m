From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/2] new API to allocate buffer-cache for superblock in
 non-movable area
Date: Tue, 22 Jul 2014 09:30:05 +0200
Message-ID: <20140722073005.GT3935@laptop>
References: <53CDF437.4090306@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Gioh Kim <gioh.kim@lge.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53CDF437.4090306@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 22, 2014 at 02:18:47PM +0900, Gioh Kim wrote:
> Hello,
> 
> This patch try to solve problem that a long-lasting page cache of
> ext4 superblock disturbs page migration.
> 
> I've been testing CMA feature on my ARM-based platform
> and found some pages for page caches cannot be migrated.
> Some of them are page caches of superblock of ext4 filesystem.
> 
> Current ext4 reads superblock with sb_bread(). sb_bread() allocates page
> from movable area. But the problem is that ext4 hold the page until
> it is unmounted. If root filesystem is ext4 the page cannot be migrated forever.
> 
> I introduce a new API for allocating page from non-movable area.
> It is useful for ext4 and others that want to hold page cache for a long time.

There's no word on why you can't teach ext4 to still migrate that page.
For all I know it might be impossible, but at least mention why.
