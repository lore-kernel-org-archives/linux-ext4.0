From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] fs: ext4: use new return type vm_fault_t
Date: Sun, 22 Jul 2018 18:13:14 -0400
Message-ID: <20180722221314.GB3358@thunk.org>
References: <20180707103029.GA13365@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, willy@infradead.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180707103029.GA13365@jordon-HP-15-Notebook-PC>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jul 07, 2018 at 04:00:30PM +0530, Souptick Joarder wrote:
> Use new return type vm_fault_t for fault handler
> ext4_filemap_fault.
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>

Thanks, applied.

					- Ted
