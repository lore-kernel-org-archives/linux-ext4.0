From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: EXT4 is ~2X as slow as XFS (593MB/s vs 304MB/s) for writes?
Date: Mon, 01 Mar 2010 17:48:16 +0300
Message-ID: <4B8BD3B0.3020502@msgid.tls.msk.ru>
References: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan> <4B886CA1.9050906@redhat.com> <alpine.DEB.2.00.1002262006000.8247@p34.internal.lan> <4B887160.2090606@redhat.com> <4B887548.50508@redhat.com> <alpine.DEB.2.00.1002270513280.17433@p34.internal.lan> <alpine.DEB.2.00.1002270550330.17433@p34.internal.lan> <alpine.DEB.2.00.1002270607020.17433@p34.internal.lan> <alpine.DEB.2.00.1002270634200.17433@p34.internal.lan> <20100228054240.GE14646@thunk.org> <alpine.DEB.2.00.1002280628550.22822@p34.internal.lan> <832C6227-BF34-43C2-8768-1308C00AB17F@sun.com> <alpine.DEB.2.00.1003010419090.20072@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, tytso@mit.edu,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([81.13.33.159]:46256 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab0CAOsS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Mar 2010 09:48:18 -0500
In-Reply-To: <alpine.DEB.2.00.1003010419090.20072@p34.internal.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Justin Piszcz wrote:
> 
> On Mon, 1 Mar 2010, Andreas Dilger wrote:
> 
>> On 2010-02-28, at 07:55, Justin Piszcz wrote:
>>> === CREATE RAID-0 WITH 11 DISKS
>>
>> Have you tried testing with "nice" numbers of disks in your RAID set
>> (e.g. 8 disks for RAID-0, 9 for RAID-5, 10 for RAID-6)?  The mballoc
>> code is really much better tuned for power-of-two sized allocations.
> 
> Hi,
> 
> Yes, the second system (RAID-5) has 8 disks and it shows the same
> performance problems with ext4 and not XFS (as shown from previous
> e-mail), where XFS usually got 500-600MiB/s for writes.
> 
> http://groups.google.com/group/linux.kernel/browse_thread/thread/e7b189bcaa2c1cb4/ad6c2a54b678cf5f?show_docid=ad6c2a54b678cf5f&pli=1
> 
> 
> For the RAID-5 (from earlier testing):  <- This one has 8 disks.

Note that for RAID-5, the "nice" number of disks is 9 as Andreas
said, not 8 as in your example.

/mjt
