From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] new APIs to allocate buffer-cache for superblock in
 non-movable area
Date: Thu, 14 Aug 2014 14:26:10 -0700
Message-ID: <20140814142610.6f0d4194c373fef188870772@linux-foundation.org>
References: <53EC4531.1000904@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
	Joonsoo Kim <js1304@gmail.com>,
	=?UTF-8?Q?=EC=9D=B4?= =?UTF-8?Q?=EA=B1=B4=ED=98=B8?=
	<gunho.lee@lge.com>
To: Gioh Kim <gioh.kim@lge.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53EC4531.1000904@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 14 Aug 2014 14:12:17 +0900 Gioh Kim <gioh.kim@lge.com> wrote:

> This patch try to solve problem that a long-lasting page caches of
> ext4 superblock and journaling of superblock disturb page migration.
> 
> I've been testing CMA feature on my ARM-based platform
> and found that two page caches cannot be migrated.
> They are page caches of superblock of ext4 filesystem and its journaling data.
> 
> Current ext4 reads superblock with sb_bread() that allocates page
> from movable area. But the problem is that ext4 hold the page until
> it is unmounted. If root filesystem is ext4 the page cannot be migrated forever.
> And also the journaling data for the superblock cannot be migreated.
> 
> I introduce a new API for allocating page cache from non-movable area.
> It is useful for ext4/ext3 and others that want to hold page cache for a long time.

All seems reasonable to me.  The additional overhead in buffer.c from
additional function arguments is regrettable but I don't see a
non-hacky alternative.


One vital question which the changelog doesn't really address (it
should): how important is this patch?  Is your test system presently
"completely dead in the water utterly unusable" or "occasionally not
quite as good as it could be".  Somewhere in between?

See, the patch adds costs.  I'd like us to have a good understanding of
what benefits it brings.
