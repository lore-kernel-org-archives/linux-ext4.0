From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 1/7] pmem: add wb_cache_pmem() to the PMEM API
Date: Tue, 22 Dec 2015 14:44:40 -0800
Message-ID: <20151222144440.1ad9e076464f4751f3de6a1f@linux-foundation.org>
References: <1450502540-8744-1-git-send-email-ross.zwisler@linux.intel.com>
	<1450502540-8744-2-git-send-email-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 "J. Bruce Fields" <bfields@fieldses.org>, "Theodore Ts'o" <tytso@mit.edu>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger
 <adilger.kernel@dilger.ca>, Dave Chinner <david@fromorbit.com>, Ingo Molnar
 <mingo@redhat.com>, Jan Kara <jack@suse.com>, Jeff Layton
 <jlayton@poochiereds.net>, Matthew Wilcox <willy@linux.intel.com>, Thomas
 Gleixner <tglx@linutronix.de>, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-nvdimm@ml01.01.org, x86@kernel.org, xfs@oss.sgi.com, Dan Williams
 <dan.j.williams@intel.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1450502540-8744-2-git-send-email-ross.zwisler@linux.intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 18 Dec 2015 22:22:14 -0700 Ross Zwisler <ross.zwisler@linux.intel.com> wrote:

> The function __arch_wb_cache_pmem() was already an internal implementation
> detail of the x86 PMEM API, but this functionality needs to be exported as
> part of the general PMEM API to handle the fsync/msync case for DAX mmaps.
> 
> One thing worth noting is that we really do want this to be part of the
> PMEM API as opposed to a stand-alone function like clflush_cache_range()
> because of ordering restrictions.  By having wb_cache_pmem() as part of the
> PMEM API we can leave it unordered, call it multiple times to write back
> large amounts of memory, and then order the multiple calls with a single
> wmb_pmem().
> 
> @@ -138,7 +139,7 @@ static inline void arch_clear_pmem(void __pmem *addr, size_t size)
>  	else
>  		memset(vaddr, 0, size);
>  
> -	__arch_wb_cache_pmem(vaddr, size);
> +	arch_wb_cache_pmem(addr, size);
>  }
>  

reject.  I made this

	arch_wb_cache_pmem(vaddr, size);

due to Dan's
http://www.ozlabs.org/~akpm/mmots/broken-out/pmem-dax-clean-up-clear_pmem.patch

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
