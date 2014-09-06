From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] jbd2: fix descriptor block size handling errors with
 journal_csum
Date: Fri, 5 Sep 2014 21:01:54 -0700
Message-ID: <20140906040154.GA27293@birch.djwong.org>
References: <BAY406-EAS2912CB28A4B081AF994BDA2FDC70@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: TR Reardon <thomas_reardon@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50366 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaIFEB7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Sep 2014 00:01:59 -0400
Content-Disposition: inline
In-Reply-To: <BAY406-EAS2912CB28A4B081AF994BDA2FDC70@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 02, 2014 at 03:28:33PM -0400, TR Reardon wrote:
> There may still be problems with this patch.  After applying to 3.16.1, I am now getting "can't enable checksumming v2 and v3 at the same time" errors on mount.  Initial mount/dismount work fine, but once fs is touched--forcing superblock update--it cannot be mounted anew.
> 
> Note results from dumpe2fs  (without recent patches)
> 
> Journal backup:           inode blocks
> Checksum type:            crc32c
> Checksum:                 0x39141b69
> Journal features:         journal_incompat_revoke journal_64bit journal_async_commit journal_checksum_v2 FEATURE_I4
> Journal size:             128M
> Journal length:           32768
> Journal sequence:         0x00012aa4
> Journal start:            0
> Journal checksum type:    crc32c
> Journal checksum:         0x3952b695
> 
> Seems that the old v2 flag is not cleared on dismount?

Yep.  Thanks for catching this.

--D
> 
> 
> 
> --- Original Message ---
> 
> From: "Theodore Ts'o" <tytso@mit.edu>
> Sent: August 25, 2014 10:44 PM
> To: "Darrick J. Wong" <darrick.wong@oracle.com>
> Cc: linux-ext4@vger.kernel.org, "TR Reardon" <thomas_reardon@hotmail.com>
> Subject: Re: [PATCH 2/2] jbd2: fix descriptor block size handling errors with journal_csum
> 
> On Fri, Aug 15, 2014 at 01:43:59PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > It turns out that there are some serious problems with the on-disk
> > format of journal checksum v2.  The foremost is that the function to
> > calculate descriptor tag size returns sizes that are too big.  This
> > causes alignment issues on some architectures and is compounded by the
> > fact that some parts of jbd2 use the structure size (incorrectly) to
> > determine the presence of a 64bit journal instead of checking the
> > feature flags.
> >
> > Therefore, introduce journal checksum v3, which enlarges the
> > descriptor block tag format to allow for full 32-bit checksums of
> > journal blocks, fix the journal tag function to return the correct
> > sizes, and fix the jbd2 recovery code to use feature flags to
> > determine 64bitness.
> >
> > Add a few function helpers so we don't have to open-code quite so
> > many pieces.
> >
> > Switching to a 16-byte block size was found to increase journal size
> > overhead by a maximum of 0.1%, to convert a 32-bit journal with no
> > checksumming to a 32-bit journal with checksum v3 enabled.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reported-by: TR Reardon <thomas_reardon@hotmail.com>
> 
> Thanks, applied.
> 
>                                         - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
