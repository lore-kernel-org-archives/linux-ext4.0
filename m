From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: remove the conditional test
Date: Sun, 20 May 2018 22:41:09 -0400
Message-ID: <20180521024109.GF4464@thunk.org>
References: <1517840679-5902-1-git-send-email-wanglong19@meituan.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: darrick.wong@oracle.com, jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Wang Long <wanglong19@meituan.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1517840679-5902-1-git-send-email-wanglong19@meituan.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Feb 05, 2018 at 10:24:39PM +0800, Wang Long wrote:
> kmem_cache_destroy already handles null pointers, so we can remove the
> conditional test entirely.
> 
> This patch also set NULL after the kmem_cache_destroy in function
> jbd2_journal_destroy_handle_cache.
> 
> Signed-off-by: Wang Long <wanglong19@meituan.com>

Thanks; I clarified the patch summary to be:

    jbd2: remove NULL check before calling kmem_cache_destroy()

and have applied it.  Apologies for not getting to this earlier.

    	 	      		    - Ted
