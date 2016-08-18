From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] common/rc: improve _require_metadata_journaling() for
 ext4
Date: Thu, 18 Aug 2016 23:26:20 +0800
Message-ID: <20160818152620.GC27776@eguan.usersys.redhat.com>
References: <20160818144253.GA14069@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160818144253.GA14069@localhost.localdomain>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 18, 2016 at 10:42:53AM -0400, Eric Whitney wrote:
> The code in _require_metadata_journaling() currently rejects ext4 file
> systems that have been created without a journal.  However, an ext4
> file system with a journal should also be rejected if the journal is
> not loaded and made available for use at mount time.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> ---
>  common/rc | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 3fb0600..9a3c9bd 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3057,6 +3057,9 @@ _require_metadata_journaling()
>  		_require_dumpe2fs
>  		$DUMPE2FS_PROG -h $DEV 2>&1 | grep -q has_journal || \
>  			_notrun "$FSTYP on $DEV not configured with metadata journaling"
> +		# ext4 may not have loaded a journal
> +		echo $MOUNT_OPTIONS | grep -q noload && \
> +			_notrun "$FSTYP on $DEV not mounted with metadata journaling"

I think this can be done by the new helper _exclude_scratch_mount_option
which was introduced recently, e.g.

_exclude_scratch_mount_option "noload"

Thanks,
Eryu

>  		;;
>  	*)
>  		# by default we pass; if you need to, add your fs above!
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
