From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 1/2] fs: ext4: use BUG_ON if writepage call comes from
 direct reclaim
Date: Tue, 3 Jul 2018 06:39:48 -0400
Message-ID: <20180703103948.GB27426@thunk.org>
References: <1530591079-33813-1-git-send-email-yang.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mgorman@techsingularity.net, adilger.kernel@dilger.ca,
        darrick.wong@oracle.com, dchinner@redhat.com,
        akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
To: Yang Shi <yang.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1530591079-33813-1-git-send-email-yang.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 03, 2018 at 12:11:18PM +0800, Yang Shi wrote:
> direct reclaim doesn't write out filesystem page, only kswapd could do
> it. So, if the call comes from direct reclaim, it is definitely a bug.
> 
> And, Mel Gormane also mentioned "Ultimately, this will be a BUG_ON." In
> commit 94054fa3fca1fd78db02cb3d68d5627120f0a1d4 ("xfs: warn if direct
> reclaim tries to writeback pages").
> 
> Although it is for xfs, ext4 has the similar behavior, so elevate
> WARN_ON to BUG_ON.
> 
> And, correct the comment accordingly.
> 
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>

What's the upside of crashing the kernel if the file sytsem can handle it?

       	   	     	      	  	    - Ted
