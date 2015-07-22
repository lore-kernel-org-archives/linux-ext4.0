From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 1/2] ext4: replace ext4_io_submit->io_op with ->io_wbc
Date: Tue, 21 Jul 2015 23:56:09 -0400
Message-ID: <20150722035609.GC2944@thunk.org>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <1434495193-31182-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org,
	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org,
	adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1434495193-31182-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 16, 2015 at 06:53:12PM -0400, Tejun Heo wrote:
> ext4_io_submit_init() takes the pointer to writeback_control to test
> its sync_mode and determine between WRITE and WRITE_SYNC and records
> the result in ->io_op.  This patch makes it record the pointer
> directly and moves the test to ext4_io_submit().
> 
> This doesn't cause any noticeable differences now but having
> writeback_control available throughout IO submission path will be
> depended upon by the planned cgroup writeback support.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
> Cc: Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
> Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Thanks, applied.

						- Ted
