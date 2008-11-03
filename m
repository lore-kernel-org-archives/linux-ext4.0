From: "Roc Valles" <vallesroc@gmail.com>
Subject: data corruption with ext4 (from 2.6.27.4) exposed by rtorrent
Date: Mon, 3 Nov 2008 12:42:11 +0000
Message-ID: <3d3ce57e0811030442o377cf2bet212eefba79d714bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:49415 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbYKCMmM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 07:42:12 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2209341fgg.17
        for <linux-ext4@vger.kernel.org>; Mon, 03 Nov 2008 04:42:11 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some person already reported this. I'm having the same problem.
http://marc.info/?l=linux-ext4&m=122557056518246&w=2
rtorrent is a bittorrent client that makes heavy use of mmap instead
of read/write to avoid needless duplication of data. It has exposed
other bugs in the past (mmap bug in 2.6.19).
http://libtorrent.rakshasa.no
Downloading a big torrent (>2GB) with rtorrent triggers it more times
than not. The bigger the torrent, the higher the likeliness of
failure. When the torrent is finished, if a hash check is forced by
pressing control-r on the torrent, some blocks will fail.
The torrent doesn't need to be a single file, but can be a series of
small files that add up enough.
Downloading on ext3 or XFS instead is 100% fine.
I've discarded posix fallocate as the culprit by building rtorrent
without the patch that adds that (and doing a du just in case,
definitively not preallocating).
Filesystem is ~1.4TB. I've also reproduced it on a 200GB partition.
The system is: Linux kaguya 2.6.27.4 #1 SMP Mon Oct 27 14:43:19 UTC
2008 x86_64 Intel(R) Atom(TM) CPU 330 @ 1.60GHz GenuineIntel GNU/Linux
No kernel patches were applied.
