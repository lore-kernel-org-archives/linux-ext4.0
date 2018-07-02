From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 2/3] fs/ext2/inode: Fix a type cast error for fsdax
Date: Mon, 2 Jul 2018 09:55:43 +0200
Message-ID: <20180702075543.k7y73aj3s3gp4ptz@quack2.suse.cz>
References: <20180701061848.7036-1-yehs2007@zoho.com>
 <20180701061848.7036-2-yehs2007@zoho.com>
 <20180701192600.GT30522@ZenIV.linux.org.uk>
 <16459a9432e.10c419704327.5268154349116077352@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, chengnt-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, "\"Al Viro\"" <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, jack-IBi9RG/b67k@public.gmane.org,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Huaisheng Ye <yehs2007-ytc+IHgoah0@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <16459a9432e.10c419704327.5268154349116077352-ytc+IHgoah0@public.gmane.org>
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

On Mon 02-07-18 14:23:42, Huaisheng Ye wrote:
>  ---- On Mon, 02 Jul 2018 03:26:00 +0800 Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote ---- 
>  > On Sun, Jul 01, 2018 at 02:18:47PM +0800, Huaisheng Ye wrote: 
>  > > From: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org> 
>  > >  
>  > > The type of offset within struct iomap is loff_t, which represents 
>  > > file offset of mapping. 
>  > >  
>  > > In ext2_iomap_begin, iomap->offset shall be given a type cast as 
>  > > loff_t instead of u64. 
>  >  
>  > Why is it an error?  loff_t is uniformly typedefed to long long. 
>  > In which case the second variant is different from the first one 
>  > *and* does not step into nasal demon territory?
> 
> Sorry for my inaccuracy.
> The type of iomap->offset is loff_t, is it better to cast first_block
> to loff_t, then do the left shift operation?

I think what Al meant is that in the kernel loff_t is 64-bit anyway and
furthermore it is signed which means most people have to look up C standard
to remember how right shift is (un)defined if it would overflow ;). So this
does not really make the code any more readable. Rather on contrary...

								Honza

>  
>  >  
>  > > -    iomap->offset = (u64)first_block << blkbits; 
>  > > +    iomap->offset = (loff_t)first_block << blkbits; 
>  > 
> 
> ---
> Cheers,
> Huaisheng
> 
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
