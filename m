From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] ext4: remove unused local variable "store" from
 ext4_readdir(...)
Date: Tue, 20 May 2014 23:08:27 +0300
Message-ID: <20140520200827.GM15585@mwanda>
References: <20140520144113.GB13333@vaio>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Giedrius Rekasius <giedrius.rekasius@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140520144113.GB13333@vaio>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 20, 2014 at 03:41:13PM +0100, Giedrius Rekasius wrote:
> From: Giedrius Rekasius <giedrius.rekasius@gmail.com>
> 
> Remove unused local variable "store" from ext4_readdir(...)
> 
> Local variable "stored" is initialized however never used inside the function.
> 
> Signed-off-by: Giedrius Rekasius <giedrius.rekasius@gmail.com>

You email client is corrupting the patch so it doesn't apply.

Read Documentation/email-clients.txt (linux-next version).

regards,
dan carpenter
