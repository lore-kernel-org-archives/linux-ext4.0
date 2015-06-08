From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1 linux-next] ext4: fix incorrect type argument
Date: Mon, 8 Jun 2015 12:21:57 -0400
Message-ID: <20150608162157.GI19168@thunk.org>
References: <1431723673-25450-1-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431723673-25450-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 15, 2015 at 11:01:13PM +0200, Fabian Frederick wrote:
> Fix sparse warning introduced in commit
> 9bd8212f981e
> ("ext4 crypto: add encryption policy and password salt support")
> 
> fs/ext4/ioctl.c:678:35: warning: incorrect type in argument 1
> (different address spaces)
> fs/ext4/ioctl.c:678:35:    expected void [noderef] <asn:1>*to
> fs/ext4/ioctl.c:678:35:    got void *<noident>
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Thanks for pointing this out!  I'll fix this and another sparse
warning at the same time.

					- Ted
