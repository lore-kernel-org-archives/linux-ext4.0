From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: make xattr inode reads faster
Date: Sun, 6 Aug 2017 00:14:57 -0400
Message-ID: <20170806041457.3sedyg67nnvypwhx@thunk.org>
References: <705A22C6-4583-47D4-8FB0-B2820F7051F3@dilger.ca>
 <20170717062012.26331-1-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170717062012.26331-1-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jul 16, 2017 at 11:20:12PM -0700, Tahsin Erdogan wrote:
> ext4_xattr_inode_read() currently reads each block sequentially while
> waiting for io operation to complete before moving on to the next
> block. This prevents request merging in block layer.
> 
> Add a ext4_bread_batch() function that starts reads for all blocks
> then optionally waits for them to complete. A similar logic is used
> in ext4_find_entry(), so update that code to use the new function.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, applied.

					- Ted
