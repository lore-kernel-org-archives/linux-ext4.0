From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: handle the rest of ext4_mb_load_buddy() ENOMEM
 errors
Date: Sat, 20 May 2017 22:45:44 -0400
Message-ID: <20170521024544.udju6nbsfdanf5pl@thunk.org>
References: <149517779388.33359.16474190951431954772.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <149517779388.33359.16474190951431954772.stgit@buzz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 19, 2017 at 10:09:54AM +0300, Konstantin Khlebnikov wrote:
> I've got another report about breaking ext4 by ENOMEM error returned from
> ext4_mb_load_buddy() caused by memory shortage in memory cgroup.
> This time inside ext4_discard_preallocations().
> 
> This patch replaces ext4_error() with ext4_warning() where errors returned
> from ext4_mb_load_buddy() are not fatal and handled by caller:
> * ext4_mb_discard_group_preallocations() - called before generating ENOSPC,
>   we'll try to discard other group or return ENOSPC into user-space.
> * ext4_trim_all_free() - just stop trimming and return ENOMEM from ioctl.
> 
> Some callers cannot handle errors, thus __GFP_NOFAIL is used for them:
> * ext4_discard_preallocations()
> * ext4_mb_discard_lg_preallocations()
> 
> The only unclear case is ext4_group_add_blocks(), probably ext4_std_error()
> should handle ENOMEM as warning and don't break filesystem.
> 
> Fixes: adb7ef600cc9 ("ext4: use __GFP_NOFAIL in ext4_free_blocks()")
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Thanks, applied.

					- Ted

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
