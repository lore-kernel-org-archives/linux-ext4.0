From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/3] vfs, writeback: replace FS_CGROUP_WRITEBACK with
 MS_CGROUPWB
Date: Sat, 13 Jun 2015 09:16:08 -0700
Message-ID: <20150613161608.GA29414@infradead.org>
References: <1434146254-26220-1-git-send-email-tj@kernel.org>
 <1434146254-26220-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org,
	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1434146254-26220-3-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 12, 2015 at 04:57:33PM -0500, Tejun Heo wrote:
> FS_CGROUP_WRITEBACK indicates whether a file_system_type supports
> cgroup writeback; however, different super_blocks of the same
> file_system_type may or may not support cgroup writeback depending on
> filesystem options.  This patch replaces FS_CGROUP_WRITEBACK with a
> kernel-internal super_block->s_flags MS_CGROUPWB.  The concatenated
> and abbreviated name is for consistency with other MS_* flags.

Nak.  As the uapi part makes it obvious the MS_ namespace is part
of the userspace ABI.  Please add a new in-kernel flags field instead.
