From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 5/7] VFS: Avoid read-write deadlock in
 try_to_writeback_inodes_sb
Date: Fri, 6 Jan 2012 01:35:33 +0100
Message-ID: <20120106003533.GC3790@quack.suse.cz>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
 <1323367477-21685-6-git-send-email-kamal@canonical.com>
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
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1323367477-21685-6-git-send-email-kamal@canonical.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 08-12-11 10:04:35, Kamal Mostafa wrote:
> From: Valerie Aurora <val@vaaconsulting.com>
> 
> Use trylock in try_to_writeback_inodes_sb to avoid read-write
> deadlocks that could be triggered by freeze.
  Christoph asked about what is the exact deadlock this patch tries to fix.
I don't think you answered that. So can you elaborate please? Is it somehow
connected with the fact that ext4 calls try_to_writeback_inodes_sb() with
i_mutex held?

								Honza

> BugLink: https://bugs.launchpad.net/bugs/897421
> Signed-off-by: Valerie Aurora <val@vaaconsulting.com>
> Cc: Kamal Mostafa <kamal@canonical.com>
> Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
> [kamal@canonical.com: patch restructure]
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> ---
>  fs/fs-writeback.c |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index ea89b3f..3a80f1b 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1274,8 +1274,9 @@ EXPORT_SYMBOL(writeback_inodes_sb);
>   * try_to_writeback_inodes_sb	-	start writeback if none underway
>   * @sb: the superblock
>   *
> - * Invoke writeback_inodes_sb if no writeback is currently underway.
> - * Returns 1 if writeback was started, 0 if not.
> + * Invoke writeback_inodes_sb if no writeback is currently underway
> + * and no one else holds the s_umount lock.  Returns 1 if writeback
> + * was started, 0 if not.
>   */
>  int try_to_writeback_inodes_sb(struct super_block *sb, enum wb_reason reason)
>  {
> @@ -1288,15 +1289,17 @@ EXPORT_SYMBOL(try_to_writeback_inodes_sb);
>   * @sb: the superblock
>   * @nr: the number of pages to write
>   *
> - * Invoke writeback_inodes_sb if no writeback is currently underway.
> - * Returns 1 if writeback was started, 0 if not.
> + * Invoke writeback_inodes_sb if no writeback is currently underway
> + * and no one else holds the s_umount lock.  Returns 1 if writeback
> + * was started, 0 if not.
>   */
>  int try_to_writeback_inodes_sb_nr(struct super_block *sb,
>  				   unsigned long nr,
>  				   enum wb_reason reason)
>  {
>  	if (!writeback_in_progress(sb->s_bdi)) {
> -		down_read(&sb->s_umount);
> +		if (!down_read_trylock(&sb->s_umount))
> +		    return 0;
>  		if (nr == 0)
>  			writeback_inodes_sb(sb, reason);
>  		else
> -- 
> 1.7.5.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
