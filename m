From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 6/7] VFS: Document s_frozen state through
 freeze_super
Date: Fri, 6 Jan 2012 01:36:04 +0100
Message-ID: <20120106003604.GD3790@quack.suse.cz>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
 <1323367477-21685-7-git-send-email-kamal@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Surbhi Palande <csurbhi@gmail.com>,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>
To: Kamal Mostafa <kamal@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964847Ab2AFAgG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Jan 2012 19:36:06 -0500
Content-Disposition: inline
In-Reply-To: <1323367477-21685-7-git-send-email-kamal@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 08-12-11 10:04:36, Kamal Mostafa wrote:
> From: Valerie Aurora <val@vaaconsulting.com>
  Looks good. You can add:
Acked-by: Jan Kara <jack@suse.cz>

								Honza

> BugLink: https://bugs.launchpad.net/bugs/897421
> Signed-off-by: Valerie Aurora <val@vaaconsulting.com>
> Cc: Kamal Mostafa <kamal@canonical.com>
> Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
> [kamal@canonical.com: patch restructure]
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> ---
>  fs/super.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 5629d06..a56696b 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1140,6 +1140,24 @@ out:
>   * Syncs the super to make sure the filesystem is consistent and calls the fs's
>   * freeze_fs.  Subsequent calls to this without first thawing the fs will return
>   * -EBUSY.
> + *
> + * During this function, sb->s_frozen goes through these values:
> + *
> + * SB_UNFROZEN: File system is normal, all writes progress as usual.
> + *
> + * SB_FREEZE_WRITE: The file system is in the process of being frozen
> + * and any remaining out-standing writes are being synced.  Writes
> + * that complete in-process writes should be permitted but new ones
> + * should be blocked.
> + *
> + * SB_FREEZE_TRANS: The file system is frozen.  The ->freeze_fs and
> + * ->unfreeze_fs ops are the only operations permitted to write to the
> + * file system in this state.
> + *
> + * sb->s_frozen is protected by sb->s_umount.  Additionally,
> + * SB_FREEZE_WRITE is only temporarily set during freeze/thaw while
> + * holding sb->s_umount for writing, so any other callers holding
> + * sb->s_umount will never see this state.
>   */
>  int freeze_super(struct super_block *sb)
>  {
> -- 
> 1.7.5.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
