From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] fs: Convert return type int to vm_fault_t
Date: Sun, 2 Sep 2018 21:49:49 -0700
Message-ID: <20180903044949.GB17856@bombadil.infradead.org>
References: <20180830172547.GA4408@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp,
        viro@zeniv.linux.org.uk, tytso@mit.edu, adilger.kernel@dilger.ca,
        axboe@kernel.dk, darrick.wong@oracle.com, ebiggers@google.com,
        pombredanne@nexb.com, agruenba@redhat.com,
        gregkh@linuxfoundation.org, kemi.wang@intel.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nilfs@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180830172547.GA4408@jordon-HP-15-Notebook-PC>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 30, 2018 at 10:55:47PM +0530, Souptick Joarder wrote:
> +vm_fault_t block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
> +			 get_block_t get_block, int *err)

I don't like returning both the errno and the vm_fault_t.  To me that's a
sign we need to rethink this interface.

I have two suggestions.  First, we could allocate a new VM_FAULT_NOSPC
bit.  Second, we could repurpose one of the existing bits, such as
VM_FAULT_RETRY for this purpose.

> -int ext4_page_mkwrite(struct vm_fault *vmf)
> +vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)

I also think perhaps we could start by _not_ converting block_page_mkwrite().
Just convert ext4_page_mkwrite(), and save converting block_page_mkwrite()
for later.
