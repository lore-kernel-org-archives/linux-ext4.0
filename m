From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/6 linux-next] ext4: avoid EXT4_INODE_EXTENTS double
 checking
Date: Thu, 15 Sep 2016 11:43:16 -0400
Message-ID: <20160915154316.okll4lnjq2gqstgk@thunk.org>
References: <1472069000-18897-1-git-send-email-fabf@skynet.be>
 <1472069000-18897-2-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1472069000-18897-2-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 24, 2016 at 10:03:15PM +0200, Fabian Frederick wrote:
> ext4_collapse_range() and ext4_insert_range()
> already checked inode flag at the beginning of function.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Actually, these checks are required since the check at the beginning
are done before taking the inode lock.

One could argue that we should get rid of the first check, since we
don't need to optimize for the error case.  But removing the second
check is definitely wrong.

Cheers,

					- Ted
