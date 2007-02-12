From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [patch 206/241] fix umask when noACL kernel meets extN tuned for ACLs
Date: Sun, 11 Feb 2007 22:01:50 -0800
Message-ID: <200702112201.50952.agruen@suse.de>
References: <200702100946.l1A9kDah009321@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: torvalds@linux-foundation.org, hugh@veritas.com,
	linux-ext4@vger.kernel.org, tigran@aivazian.fsnet.co.uk
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:45829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933010AbXBLGCB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Feb 2007 01:02:01 -0500
In-Reply-To: <200702100946.l1A9kDah009321@shell0.pdx.osdl.net>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Saturday 10 February 2007 01:46, akpm@linux-foundation.org wrote:
> From: Hugh Dickins <hugh@veritas.com>
>
> Fix insecure default behaviour reported by Tigran Aivazian: if an ext2 or
> ext3 or ext4 filesystem is tuned to mount with "acl", but mounted by a
> kernel built without ACL support, then umask was ignored when creating
> inodes - though root or user has umask 022, touch creates files as 0666,
> and mkdir creates directories as 0777.
>
> This appears to have worked right until 2.6.11, when a fix to the default
> mode on symlinks (always 0777) assumed VFS applies umask: which it does,
> unless the mount is marked for ACLs; but ext[234] set MS_POSIXACL in
> s_flags according to s_mount_opt set according to def_mount_opts.
>
> We could revert to the 2.6.10 ext[234]_init_acl (adding an S_ISLNK test);
> but other filesystems only set MS_POSIXACL when ACLs are configured.  We
> could fix this at another level; but it seems most robust to avoid setting
> the s_mount_opt flag in the first place (at the expense of more ifdefs).
>
> Likewise don't set the XATTR_USER flag when built without XATTR support.
>
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
> Cc: <linux-ext4@vger.kernel.org>
> Cc: Andreas Gruenbacher <agruen@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Ack -- and thanks for this fix!

Andreas
