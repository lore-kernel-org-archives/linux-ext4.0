From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 09/13] dax: Allow dax_iomap_fault() to return pfn
Date: Wed, 23 Aug 2017 11:34:00 -0700
Message-ID: <20170823183400.GG13778@infradead.org>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-10-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
 Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Boaz Harrosh <boazh-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170817160815.30466-10-jack-AlSwsSmVLrQ@public.gmane.org>
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

> @@ -1416,6 +1416,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
>   * @vmf: The description of the fault
>   * @pe_size: Size of the page to fault in
>   * @ops: Iomap ops passed from the file system
> + * @pfnp: PFN to insert for synchronous faults if fsync is required
>   *
>   * When a page fault occurs, filesystems may call this helper in
>   * their fault handler for DAX files. dax_iomap_fault() assumes the caller
> @@ -1423,13 +1424,13 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
>   * successfully.
>   */
>  int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
> -		    const struct iomap_ops *ops)
> +		    const struct iomap_ops *ops, pfn_t *pfnp)

Please keep the iomap_ops argument the last one for the exported
function (and probably all others for consistency).

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
