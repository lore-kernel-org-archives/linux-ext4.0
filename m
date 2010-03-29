From: CaT <cat@zip.com.au>
Subject: 2.6.33.1: ext4 disk free weirdness
Date: Mon, 29 Mar 2010 15:57:49 +1100
Message-ID: <20100329045748.GR2657@zip.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nessie.weebeastie.net ([220.233.7.36]:58413 "EHLO
	bunyip.billabong.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751138Ab0C2Fmt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Mar 2010 01:42:49 -0400
Received: from hogarth by bunyip.billabong.weebeastie.net with local (Exim 4.69)
	(envelope-from <cat@zip.com.au>)
	id 1Nw72r-0006Uf-0t
	for linux-ext4@vger.kernel.org; Mon, 29 Mar 2010 15:57:49 +1100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Using kernel 2.6.33.1. Am rsyncing from /data/mirror (a raid0 mount) to
/dev/sda1 (a usb HD). Both filesystems formatted as ext3 but mounted as
ext4. /mnt filesystem is only being added to and currently large files
(iso files 700MB-4.4GB) are being copied. When I remounted /mnt as ext3
I could not duplicate the issue and the amount of disk used stabilised
at 182G. The df results, whilst /mnt is mounted as ext4, are below:

1 [29/03 15:05:58] >> df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md5              1.3T  1.2T  113G  92% /data/mirror
/dev/sda1             917G  317G  555G  37% /mnt
1 [29/03 15:11:05] >> df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md5              1.3T  1.2T  113G  92% /data/mirror
/dev/sda1             917G  224G  647G  26% /mnt
1 [29/03 15:41:38] >> df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md5              1.3T  1.2T  113G  92% /data/mirror
/dev/sda1             917G  670G  201G  77% /mnt 
1 [29/03 15:48:32] >> df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md5              1.3T  1.2T  113G  92% /data/mirror
/dev/sda1             917G  246G  626G  29% /mnt 
1 [29/03 15:48:36] >> df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md5              1.3T  1.2T  113G  92% /data/mirror
/dev/sda1             917G  313G  559G  36% /mnt 
1 [29/03 15:48:37] >> df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md5              1.3T  1.2T  113G  92% /data/mirror
/dev/sda1             917G  396G  475G  46% /mnt 
1 [29/03 15:48:37] >> df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md5              1.3T  1.2T  113G  92% /data/mirror
/dev/sda1             917G  615G  256G  71% /mnt 
1 [29/03 15:48:39] >> df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md5              1.3T  1.2T  113G  92% /data/mirror
/dev/sda1             917G  671G  201G  77% /mnt 
1 [29/03 15:48:40] >> df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md5              1.3T  1.2T  113G  92% /data/mirror
/dev/sda1             917G  671G  201G  77% /mnt 
1 [29/03 15:48:40] >> df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md5              1.3T  1.2T  113G  92% /data/mirror
/dev/sda1             917G  215G  656G  25% /mnt 
1 [29/03 15:48:41] >> df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md5              1.3T  1.2T  113G  92% /data/mirror
/dev/sda1             917G  334G  538G  39% /mnt 
1 [29/03 15:48:42] >> df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md5              1.3T  1.2T  113G  92% /data/mirror
/dev/sda1             917G  522G  349G  60% /mnt 
1 [29/03 15:48:43] >> 

-- 
  "A search of his car uncovered pornography, a homemade sex aid, women's 
  stockings and a Jack Russell terrier."
    - http://www.news.com.au/story/0%2C27574%2C24675808-421%2C00.html
