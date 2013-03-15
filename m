From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] xfstests: make defrag test 222 generic
Date: Fri, 15 Mar 2013 15:55:40 +0100
Message-ID: <20130315145540.GG7229@twin.jikos.cz>
References: <513F5B0A.4030405@redhat.com>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703Ab3COOzn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Mar 2013 10:55:43 -0400
Content-Disposition: inline
In-Reply-To: <513F5B0A.4030405@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 12, 2013 at 11:42:50AM -0500, Eric Sandeen wrote:
> Define a new _defrag_dir() helper which just runs noisy/debug
> dir defrag for ext4 and/or btrfs as well, and use that in 222
> instead of hardcoded xfs_fsr.

Dir defrag on btrfs does not recurse in the given directory to defrag
all files, but defragments the tree of the containing subvolume and the
whole extent tree (thus needs CAP_SYS_ADMIN).

This is known (and not very intuitive) behaviour, it would be better to
add a special parameter to defrag the root and/or the extent root and
pass it down to the ioctl via flags.

Until this is implemented I suggest to use a workaround via 'find':

 find $dir -print -execdir $DEFRAG_PROG '{}' +

Otherwise the test looks ok.

david

> +# Defrag a whole directory.  No checking as above, just run it, noisily
> +# output should be sent to $seq.full since it's very fs-specific
> +_defrag_dir()
> +{
> +    case "$FSTYP" in
> +    xfs)
> +	$DEFRAG_PROG -d -v $1
> +	;;
> +    ext4|ext4dev|btrfs)
       ext4|ext4dev)
> +	$DEFRAG_PROG -v $1
> +	;;
       btrfs)
        find $1 -print -execdir $DEFRAG_PROG '{}' +
        ;;
> +    *)
> +	$DEFRAG_PROG $1
> +	;;
> +    esac
> +}
