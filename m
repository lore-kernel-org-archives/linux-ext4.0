From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4/ioctl.c: copy_{from,to}_user expect __user
 pointers
Date: Tue, 11 Oct 2011 23:10:13 -0400
Message-ID: <20111012031013.GG11548@thunk.org>
References: <201109231525.54301.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
To: H Hartley Sweeten <hartleys@visionengravers.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201109231525.54301.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Sep 23, 2011 at 03:25:54PM -0700, H Hartley Sweeten wrote:
> This quiets the sparse noise:
> 
> warning: incorrect type in argument 2 (different address spaces)
>    expected void const [noderef] <asn:1>*from
>    got struct fstrim_range *<noident>
> warning: incorrect type in argument 1 (different address spaces)
>    expected void [noderef] <asn:1>*to
>    got struct fstrim_range *<noident>
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>

Thanks, applied.

					- Ted
