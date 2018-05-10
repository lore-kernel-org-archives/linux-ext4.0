From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: make =?utf-8?Q?function_?=
 =?utf-8?B?4oCYZXh0NF9nZXRmc21hcF9maW5kX2ZpeGVkX21ldGFkYXRh4oCZ?= static
Date: Thu, 10 May 2018 09:09:58 -0700
Message-ID: <20180510160958.GB4111@magnolia>
References: <20180505200452.18962-1-malat@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Mathieu Malaterre <malat@debian.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180505200452.18962-1-malat@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, May 05, 2018 at 10:04:52PM +0200, Mathieu Malaterre wrote:
> Since function ‘ext4_getfsmap_find_fixed_metadata’ can be made static,
> make it so. Remove the following gcc warning (W=1):
> 
>   fs/ext4/fsmap.c:405:5: warning: no previous prototype for ‘ext4_getfsmap_find_fixed_metadata’ [-Wmissing-prototypes]
> 
> Signed-off-by: Mathieu Malaterre <malat@debian.org>

Sorry about being late to the party,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/ext4/fsmap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/fsmap.c b/fs/ext4/fsmap.c
> index e871c4bf18e9..4b99e2db95b8 100644
> --- a/fs/ext4/fsmap.c
> +++ b/fs/ext4/fsmap.c
> @@ -402,8 +402,8 @@ static void ext4_getfsmap_free_fixed_metadata(struct list_head *meta_list)
>  }
>  
>  /* Find all the fixed metadata in the filesystem. */
> -int ext4_getfsmap_find_fixed_metadata(struct super_block *sb,
> -				      struct list_head *meta_list)
> +static int ext4_getfsmap_find_fixed_metadata(struct super_block *sb,
> +					     struct list_head *meta_list)
>  {
>  	struct ext4_group_desc *gdp;
>  	ext4_group_t agno;
> -- 
> 2.11.0
> 
