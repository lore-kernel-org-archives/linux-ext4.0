From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Subject: Re: Porting Zfs features to ext2/3
Date: Mon, 4 Aug 2008 23:38:13 +0300 (EEST)
Message-ID: <Pine.LNX.4.62.0808042320290.7281@tamago.serverit.net>
References: <18674437.post@talk.nabble.com> <1217199281.6992.0.camel@telesto>
 <20080727233855.GB9378@mit.edu> <loom.20080729T222131-137@post.gmane.org>
 <20080730013427.GD29748@mit.edu> <Pine.LNX.4.62.0807310255280.32725@tamago.serverit.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tamago.serverit.net ([91.189.209.155]:39691 "EHLO
	mail.hosting2.serverit.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762888AbYHDUiV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2008 16:38:21 -0400
In-Reply-To: <Pine.LNX.4.62.0807310255280.32725@tamago.serverit.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Thu, 31 Jul 2008, Szabolcs Szakacsits wrote:
> On Tue, 29 Jul 2008, Theodore Tso wrote:
>
> > What happens if you try benchmarking unpacking a kernel source tar.bz2 
> > file?  My guess is that ntfs-3g won't look as good.  :-)
> 
> It seems the tar.bz2 number is not so bad relatively but the metadata 
> performance difference is much more visible by eliminating the compression 
> overhead. The results are in second.
> 
>               ext3    ntfs-3g
>   tar.bz2      7.7      12.4
>   tar.gz       3.1       8.7
>   tar          1.4       7.6

Sorry, I didn't use the currently best performing ntfs-3g version. 
Corrected results:

               ext3    ntfs-3g
               ----    -------
   tar.bz2      7.7      9.9
   tar.gz       3.1      6.0
   tar          1.4      4.9

Compilation of e2fsprogs:

                 ext3     ntfs-3g
                 ----     -------
   unpack        0.27       0.47
   configure     8.42       9.73
   make         21.35      23.33
   make -j      13.21      14.09
   make clean    0.20       0.24

Please not that ntfs-3g and fuse is not yet optimized for metadata 
operations.

	Szaka

--
NTFS-3G:  http://ntfs-3g.org

