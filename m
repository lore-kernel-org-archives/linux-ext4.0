From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 2/2] ext4: implement cgroup writeback support
Date: Tue, 21 Jul 2015 23:56:20 -0400
Message-ID: <20150722035620.GD2944@thunk.org>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <1434495193-31182-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org,
	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org,
	adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1434495193-31182-3-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 16, 2015 at 06:53:13PM -0400, Tejun Heo wrote:
> For ordered and writeback data modes, all data IOs go through
> ext4_io_submit.  This patch adds cgroup writeback support by invoking
> wbc_init_bio() from io_submit_init_bio() and wbc_account_io() in
> io_submit_add_bh().  Journal data which is written by jbd2 worker is
> left alone by this patch and will always be written out from the root
> cgroup.
> 
> ext4_fill_super() is updated to set MS_CGROUPWB when data mode is
> either ordered or writeback.  In journaled data mode, most IOs become
> synchronous through the journal and enabling cgroup writeback support
> doesn't make much sense or difference.  Journaled data mode is left
> alone.
> 
> Lightly tested with sequential data write workload.  Behaves as
> expected.
> 
> v2: Updated for MS_CGROUPWB -> SB_I_CGROUPWB.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
> Cc: Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
> Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Thanks, applied.

						- Ted
