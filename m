From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fscrypto: require write access to mount to set
 encryption policy
Date: Sat, 10 Sep 2016 01:20:28 -0400
Message-ID: <20160910052028.e5xnxysyhv4bjibn@thunk.org>
References: <1473369638-19995-1-git-send-email-ebiggers@google.com>
 <20160910041519.nmim57wyptdynwxh@thunk.org>
 <20160910044049.GD34151@jaegeuk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers@google.com>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
To: Jaegeuk Kim <jaegeuk@kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160910044049.GD34151@jaegeuk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Sep 09, 2016 at 09:40:49PM -0700, Jaegeuk Kim wrote:
> Acked-by: Jaegeuk Kim <jaegeuk@kernel.org>

Thanks for acking this so quickly!  I'll send all three fixes to
Linus, then.

> It'd be better to fix the below basic warnings tho.

Thanks, I've fixed the line over 80 characters warning.  The rest of
the file uses "printk(KERN_WARNING, ..." and that's a fairly pedantic
warning so I'm just going to ignore it.

	       	    	     	    - Ted
