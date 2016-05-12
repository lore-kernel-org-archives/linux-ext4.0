From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 5/7] dax: New fault locking
Date: Thu, 12 May 2016 13:36:24 -0600
Message-ID: <20160512193624.GA20719@linux.intel.com>
References: <1463070560-1979-1-git-send-email-jack@suse.cz>
 <1463070560-1979-6-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-nvdimm@lists.01.org, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1463070560-1979-6-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 12, 2016 at 06:29:18PM +0200, Jan Kara wrote:
> Currently DAX page fault locking is racy.
>=20
> CPU0 (write fault)		CPU1 (read fault)
>=20
> __dax_fault()			__dax_fault()
>   get_block(inode, block, &bh, 0) -> not mapped
> 				  get_block(inode, block, &bh, 0)
> 				    -> not mapped
>   if (!buffer_mapped(&bh))
>     if (vmf->flags & FAULT_FLAG_WRITE)
>       get_block(inode, block, &bh, 1) -> allocates blocks
>   if (page) -> no
> 				  if (!buffer_mapped(&bh))
> 				    if (vmf->flags & FAULT_FLAG_WRITE) {
> 				    } else {
> 				      dax_load_hole();
> 				    }
>   dax_insert_mapping()
>=20
> And we are in a situation where we fail in dax_radix_entry() with -EI=
O.
>=20
> Another problem with the current DAX page fault locking is that there=
 is
> no race-free way to clear dirty tag in the radix tree. We can always
> end up with clean radix tree and dirty data in CPU cache.
>=20
> We fix the first problem by introducing locking of exceptional radix
> tree entries in DAX mappings acting very similarly to page lock and t=
hus
> synchronizing properly faults against the same mapping index. The sam=
e
> lock can later be used to avoid races when clearing radix tree dirty
> tag.
>=20
> Reviewed-by: NeilBrown <neilb@suse.com>
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
<>
> @@ -897,13 +1166,10 @@ int __dax_pmd_fault(struct vm_area_struct *vma=
, unsigned long address,
>  		 * the write to insert a dirty entry.
>  		 */
>  		if (write) {
> -			error =3D dax_radix_entry(mapping, pgoff, dax.sector,
> -					true, true);
> -			if (error) {
> -				dax_pmd_dbg(&bh, address,
> -						"PMD radix insertion failed");
> -				goto fallback;
> -			}
> +			/*
> +			 * We should insert radix-tree entry and dirty it here.
> +			 * For now this is broken...
> +			 */

With this change the 'error' variable in __dax_pmd_fault() is now unuse=
d,
resulting in a compiler warning.

fs/dax.c: In function =E2=80=98__dax_pmd_fault=E2=80=99:
fs/dax.c:1019:6: warning: unused variable =E2=80=98error=E2=80=99 [-Wun=
used-variable]
  int error, result =3D 0;
        ^

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
