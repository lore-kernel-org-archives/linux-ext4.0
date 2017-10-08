From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4/026: skip test if kernel does not support the
 ea_inode feature
Date: Mon, 9 Oct 2017 08:41:17 +1100
Message-ID: <20171008214117.GU15067@dastard>
References: <20171008192324.20477-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171008192324.20477-1-tytso@mit.edu>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Oct 08, 2017 at 03:23:24PM -0400, Theodore Ts'o wrote:
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  tests/ext4/026 | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/ext4/026 b/tests/ext4/026
> index 94a737ce..ba77f36e 100755
> --- a/tests/ext4/026
> +++ b/tests/ext4/026
> @@ -53,7 +53,8 @@ _require_attrs
>  _require_ext4_mkfs_feature ea_inode
>  
>  _scratch_mkfs_ext4 -O ea_inode >/dev/null 2>&1
> -_scratch_mount
> +_scratch_mount >/dev/null 2>&1 \
> +	|| _notrun "kernel doesn't support ea_inode feature on $FSTYP"

Needs to be in a _requires check?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
