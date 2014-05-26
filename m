From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove unused local variable "stored" from
 ext4_readdir(...)
Date: Mon, 26 May 2014 12:34:50 -0400
Message-ID: <20140526163450.GK22284@thunk.org>
References: <20140521153226.GD8826@vaio>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
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

Applied, thanks.

					- Ted
