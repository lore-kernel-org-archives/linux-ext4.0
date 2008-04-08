From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 not updating ctime on truncate ?
Date: Tue, 08 Apr 2008 10:40:51 -0500
Message-ID: <47FB9203.4090801@redhat.com>
References: <Pine.LNX.4.62.0804022313390.664@tamago.serverit.net>	 <1207247251.30407.59.camel@dyn9047017100.beaverton.ibm.com>	 <Pine.LNX.4.62.0804070207160.25240@tamago.serverit.net>	 <1207587843.31073.3.camel@badari-desktop> <1207669069.18386.6.camel@badari-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Szabolcs Szakacsits <szaka@ntfs-3g.org>
To: Badari Pulavarty <pbadari@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbYDHPlB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Apr 2008 11:41:01 -0400
In-Reply-To: <1207669069.18386.6.camel@badari-desktop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Badari Pulavarty wrote:
> Hi,
> 
> I ran Linux POSIX filesystem test suite released by  Szabolcs Szakacsits
> on ext4. I get one failure on ext4.
> 
> Failed Test                     Stat Wstat Total Fail  Failed  List of
> Failed
> -------------------------------------------------------------------------------
> /root/posix/tests/truncate/00.t               21    1   4.76%  15
> 
> Looking at the test, its complaining that ext4 is not updating ctime
> for truncate. Is this a known issue ?

Solofo sent a patch for this just yesterday:

[PATCH] ext4: update ctime and mtime for truncate with extents.

-Eric
