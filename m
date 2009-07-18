From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: very basic defragmentation testing for xfs &
	ext4
Date: Sat, 18 Jul 2009 10:31:14 -0400
Message-ID: <20090718143114.GC20905@infradead.org>
References: <4A5E3A37.5050306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs mailing list <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44412 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbZGRObP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Jul 2009 10:31:15 -0400
Content-Disposition: inline
In-Reply-To: <4A5E3A37.5050306@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 15, 2009 at 03:21:11PM -0500, Eric Sandeen wrote:
> Test a few very basic defragmentation scenarios.
> 
> This test creates some files, runs defrag on them,
> and compares the before/after fragmentation as well
> as file md5sums and timestamps.
> 
> (md5sums may just be reading buffered data though,
> suggestions?)

As Andreas said unmount it before.

> The test currently expects to find e4defrag in
> /usr/bin

> +_supported_fs xfs ext4

> +fragfile=$SCRATCH_MNT/fragfile.$$
> +
> +if [ "$FSTYP" == "xfs" ]; then
> +	DEFRAG=/usr/sbin/xfs_fsr
> +else
> +	DEFRAG=/usr/bin/e4defrag
> +fi
> +
> +_require_command $DEFRAG
> +_require_command /usr/sbin/filefrag

I think we're much better off adding a helpers for this in a new
common.defrag (or adding it somwhere).

Then set a DEFRAF_PROG variable there, and add a _require_defrag
ala

_require_defrag()
{
    case "$FSTYP" in
    xfs)
        DEFRAG_PROG=/usr/sbin/xfs_fsr
	;;
    ext4)
        DEFRAG_PROG=/usr/bin/e4defrag
	;;
    *)
        _notrun "defragmentation not supported for fstype \"$FSTYP\""
	;;
    esac

    _require_command $DEFRAG
    _require_command /usr/sbin/filefrag
}

