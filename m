From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 10/13] mm: Wire up MAP_SYNC
Date: Wed, 23 Aug 2017 11:43:49 -0700
Message-ID: <20170823184349.GA12660@infradead.org>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-11-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Boaz Harrosh <boazh-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170817160815.30466-11-jack-AlSwsSmVLrQ@public.gmane.org>
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

On Thu, Aug 17, 2017 at 06:08:12PM +0200, Jan Kara wrote:
> Pretty crude for now...
> 
> Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> ---
>  fs/ext4/file.c                  | 2 ++
>  include/linux/mm.h              | 1 +
>  include/linux/mman.h            | 3 ++-
>  include/uapi/asm-generic/mman.h | 1 +
>  mm/mmap.c                       | 5 +++++
>  5 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index f84bb29e941e..850037e140d7 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -340,6 +340,8 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
>  		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
>  	} else {
>  		vma->vm_ops = &ext4_file_vm_ops;
> +		if (vma->vm_flags & VM_SYNC)
> +			return -EOPNOTSUPP;
>  	}

So each mmap instance would need to reject the flag explicitly?

Or do I misunderstand this VM_SYNC flag?
