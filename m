From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 3/3] fs/ext2/inode: Optimize the condition for iomap_begin
Date: Mon, 2 Jul 2018 09:57:27 +0200
Message-ID: <20180702075727.3s7yymczrmm4xiox@quack2.suse.cz>
References: <20180701061848.7036-1-yehs2007@zoho.com>
 <20180701061848.7036-3-yehs2007@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, chengnt-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, jack-IBi9RG/b67k@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Huaisheng Ye <yehs2007-ytc+IHgoah0@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180701061848.7036-3-yehs2007-ytc+IHgoah0@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

On Sun 01-07-18 14:18:48, Huaisheng Ye wrote:
> From: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>
> 
> If ext2_get_blocks returns negative result, ext2_iomap_begin
> will return for error case.
> Adjust the judging condition of ret value will be useful for
> code simplification.
> 
> Signed-off-by: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>

I'm sorry but how exactly is this simpler?

								Honza

> ---
>  fs/ext2/inode.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index ca211bd..9b1004d 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -819,15 +819,15 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  	iomap->offset = (loff_t)first_block << blkbits;
>  	iomap->dax_dev = sbi->s_daxdev;
>  
> -	if (ret == 0) {
> -		iomap->type = IOMAP_HOLE;
> -		iomap->addr = IOMAP_NULL_ADDR;
> -		iomap->length = 1 << blkbits;
> -	} else {
> +	if (ret) {
>  		iomap->type = IOMAP_MAPPED;
>  		iomap->addr = (u64)bno << blkbits;
>  		iomap->length = (u64)ret << blkbits;
>  		iomap->flags |= IOMAP_F_MERGED;
> +	} else {
> +		iomap->type = IOMAP_HOLE;
> +		iomap->addr = IOMAP_NULL_ADDR;
> +		iomap->length = 1 << blkbits;
>  	}
>  
>  	if (new)
> -- 
> 1.8.3.1
> 
> 
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
