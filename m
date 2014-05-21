From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] ext4: remove unused local variable "stored" from
 ext4_readdir(...)
Date: Wed, 21 May 2014 20:44:09 +0300
Message-ID: <20140521174409.GD15585@mwanda>
References: <20140521153226.GD8826@vaio>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Giedrius Rekasius <giedrius.rekasius@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140521153226.GD8826@vaio>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 21, 2014 at 04:32:26PM +0100, Giedrius Rekasius wrote:
> From: Giedrius Rekasius <giedrius.rekasius@gmail.com>
> 
> Remove local variable "stored" from ext4_readdir(...). This variable 
> gets initialized but is never used inside the function.
> 
> Signed-off-by: Giedrius Rekasius <giedrius.rekasius@gmail.com>

Looks good.

regards,
dan carpenter
