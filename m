From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] ext4: fix up huge_fault rename
Date: Thu, 2 Feb 2017 13:02:20 -0700
Message-ID: <20170202200220.GA14747@linux.intel.com>
References: <20170202113625.702169-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170202113625.702169-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Feb 02, 2017 at 12:36:12PM +0100, Arnd Bergmann wrote:
> It looks like a search+replace accidentally change one function pointer that
> should have remained as before, as shown by this new warning:
> 
> fs/ext4/file.c:279:1: error: 'ext4_dax_huge_fault' defined but not used [-Werror=unused-function]
> 
> This reverts the one line of the changeset.
> 
> Fixes: 80a841811260 ("mm,fs,dax: change ->pmd_fault to ->huge_fault")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  fs/ext4/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index ed22d20e843c..e1a581133aa1 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -329,7 +329,7 @@ static int ext4_dax_pfn_mkwrite(struct vm_fault *vmf)
>  static const struct vm_operations_struct ext4_dax_vm_ops = {
>  	.fault		= ext4_dax_fault,
>  	.huge_fault	= ext4_dax_fault,
> -	.page_mkwrite	= ext4_dax_fault,
> +	.page_mkwrite	= ext4_dax_huge_fault,
>  	.pfn_mkwrite	= ext4_dax_pfn_mkwrite,
>  };
>  #else
> -- 
> 2.9.0

Hey Arnd,

I saw this as well, but fixed it by removing ext4_dax_huge_fault() since after
Dave's changes ext4_dax_fault() and ext4_dax_huge_fault() are identical.

http://www.spinics.net/lists/linux-mm/msg121117.html

If you're alright with it let's go that way so we can remove a redundant
function.

- Ross
