From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 51/51] ext2: enable cgroup writeback support
Date: Wed, 1 Jul 2015 23:08:28 -0400
Message-ID: <20150702030828.GO26440@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-52-git-send-email-tj@kernel.org>
 <20150701192912.GN7252@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org,
	hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org,
	vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org,
	linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com,
	fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com,
	khlebnikov@yandex-team.ru, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150701192912.GN7252@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 01, 2015 at 09:29:12PM +0200, Jan Kara wrote:
> On Fri 22-05-15 17:14:05, Tejun Heo wrote:
> > Writeback now supports cgroup writeback and the generic writeback,
> > buffer, libfs, and mpage helpers that ext2 uses are all updated to
> > work with cgroup writeback.
> > 
> > This patch enables cgroup writeback for ext2 by adding
> > FS_CGROUP_WRITEBACK to its ->fs_flags.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: linux-ext4@vger.kernel.org
> 
> Hallelujah!
> 
> Reviewed-by: Jan Kara <jack@suse.com>

Hooray!  Thanks a lot for going through all the patches!  :)

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
