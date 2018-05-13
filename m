From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2] fs: ext4: Adding new return type vm_fault_t
Date: Sun, 13 May 2018 16:02:36 -0400
Message-ID: <20180513200236.GF14763@thunk.org>
References: <20180510144136.GA26160@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, willy@infradead.org
To: Souptick Joarder <jrdr.linux@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180510144136.GA26160@jordon-HP-15-Notebook-PC>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 10, 2018 at 08:11:36PM +0530, Souptick Joarder wrote:
> Use new return type vm_fault_t for fault handler. For now,
> this is just documenting that the function returns a
> VM_FAULT value rather than an errno. Once all instances are
> converted, vm_fault_t will become a distinct type.
> 
> commit 1c8f422059ae ("mm: change return type to vm_fault_t")
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>

Applied, thanks.

					- Ted
