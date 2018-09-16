From: "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] ext4, dax: set ext4_dax_aops for dax files
Date: Sat, 15 Sep 2018 21:56:46 -0400
Message-ID: <20180916015646.GE8652@thunk.org>
References: <20180914145114.11122-1-toshi.kani@hpe.com>
 <20180914145114.11122-3-toshi.kani@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jack-AlSwsSmVLrQ@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180914145114.11122-3-toshi.kani-ZPxbGqLxI0U@public.gmane.org>
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

On Fri, Sep 14, 2018 at 08:51:13AM -0600, Toshi Kani wrote:
> Sync syscall to DAX file needs to flush processor cache, but it
> currently does not flush to existing DAX files.  This is because
> 'ext4_da_aops' is set to address_space_operations of existing DAX
> files, instead of 'ext4_dax_aops', since S_DAX flag is set after
> ext4_set_aops() in the open path.
> 
>   New file
>   --------
>   lookup_open
>     ext4_create
>       __ext4_new_inode
>         ext4_set_inode_flags   // Set S_DAX flag
>       ext4_set_aops            // Set aops to ext4_dax_aops
> 
>   Existing file
>   -------------
>   lookup_open
>     ext4_lookup
>       ext4_iget
>         ext4_set_aops          // Set aops to ext4_da_aops
>         ext4_set_inode_flags   // Set S_DAX flag
> 
> Change ext4_iget() to initialize i_flags before ext4_set_aops().
> 
> Fixes: 5f0663bb4a64 ("ext4, dax: introduce ext4_dax_aops")
> Signed-off-by: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
> Suggested-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
> Cc: Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Thanks, applied.

					- Ted
