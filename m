From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Remove unnecessary NULL checks in ext4.
Date: Sun, 20 May 2018 22:45:24 -0400
Message-ID: <20180521024524.GG4464@thunk.org>
References: <1517915730-11198-1-git-send-email-fxinrong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Sean Fu <fxinrong@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1517915730-11198-1-git-send-email-fxinrong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 06, 2018 at 07:15:30PM +0800, Sean Fu wrote:
> NULL check is done in kmem_cache_destroy. So remove NULL checks in ext4.
> 
> Signed-off-by: Sean Fu <fxinrong@gmail.com>

Thanks, applied.  I clarified the patch summary to be:

    ext4: remove NULL check before calling kmem_cache_destroy()

    	  	      	    	   	   - Ted
