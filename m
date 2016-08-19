From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/6] xfstest-bld: use parallel gzip if possible
Date: Fri, 19 Aug 2016 09:32:25 -0400
Message-ID: <20160819133225.GD10888@thunk.org>
References: <1471553651-9547-1-git-send-email-dmonakhov@openvz.org>
 <1471553651-9547-5-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45486 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752088AbcHSNc3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 19 Aug 2016 09:32:29 -0400
Content-Disposition: inline
In-Reply-To: <1471553651-9547-5-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 19, 2016 at 12:54:09AM +0400, Dmitry Monakhov wrote:
> diff --git a/kvm-xfstests/kvm-xfstests b/kvm-xfstests/kvm-xfstests
> index d608317..10782d0 100755
> --- a/kvm-xfstests/kvm-xfstests
> +++ b/kvm-xfstests/kvm-xfstests
> @@ -9,6 +9,7 @@ fi
>  . "$DIR/util/get-config"
>  
>  QUIET="quiet loglevel=0"
> +which pigz &>/dev/null && GZIP=pigz || GZIP=gzip
>  
>  . $DIR/util/parse_cli
>  
> @@ -71,7 +72,7 @@ then
>      fi
>      (cd "$DIR/test-appliance"; \
>       tar -X kvm-exclude-files -C files -cf - . | \
> -	 gzip -9n > "$TDIR/files.tar.gz")
> +	 $GZIP -9n > "$TDIR/files.tar.gz")
>      tar -r -f $VDH -C "$TDIR" files.tar.gz
>      rm -rf "$TDIR"
>  fi

There's no real point in using pigz for files.tar.gz, since the file
is so small.  In fact, it's slightly slower on my system:

% time gzip -9 < /tmp/files.tar  > /tmp/files.tar.gz

real   0m0.010s
user   0m0.000s
sys    0m0.000s

% time pigz -9 < /tmp/files.tar  > /tmp/files.tar.gz

real   0m0.012s
user   0m0.010s
sys    0m0.010s

For the xfstests.tar.gz file, it does make sense; it cuts down the
compression time form 3 seconds to half a second.  That's fair,
although at least in my workflow I'm not recreating the
xfstests.tar.gz file all that often.

Cheers,

						- Ted
