From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: release bh in make_indexed_dir
Date: Fri, 30 Sep 2016 01:34:44 -0400
Message-ID: <20160930053444.qnbikbjh3sqz5wi7@thunk.org>
References: <1475170590.1830.13.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jack@suse.cz
To: gmail <yngsion@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1475170590.1830.13.camel@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Sep 30, 2016 at 01:36:30AM +0800, gmail wrote:
> The commit 6050d47adcad
> ("ext4: bail out from make_indexed_dir() on first error")
> miss to release bh in make_indexed_dir.
> 
> Signed-off-by: yangsheng <yngsion@gmail.com>

Thanks, applied.  I rewrote the commit description and also took out
the confusing "bh = bh2" and then used bh2 where we were using bh
before, which makes the code much easier to understand.

	      	    	     	  - Ted
