From: Andreas Dilger <adilger@sun.com>
Subject: Re: [Bugme-new] [Bug 11564] New: ext3 I/O errors when <4096	blocksize
 on certain hardware
Date: Sun, 14 Sep 2008 23:22:31 -0700
Message-ID: <20080915062231.GI4090@webber.adilger.int>
References: <bug-11564-10286@http.bugzilla.kernel.org/>
 <20080914001433.c843cc74.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
	mrmazda@ij.net
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:35574 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbYIOGWi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Sep 2008 02:22:38 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8F6MXRa029385
	for <linux-ext4@vger.kernel.org>; Sun, 14 Sep 2008 23:22:33 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7800H014C56F00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sun, 14 Sep 2008 23:22:33 -0700 (PDT)
In-reply-to: <20080914001433.c843cc74.akpm@linux-foundation.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 14, 2008  00:14 -0700, Andrew Morton wrote:
> On Sat, 13 Sep 2008 19:20:35 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=11564
> > Tail of most recent (Factory 2.6.27-rc6) /var/log/messages:
> > Sep 13 21:29:23 xxxxx kernel: sd 0:0:1:0: [sda] Result: hostbyte=DID_SOFT_ERROR
> > driverbyte=DRIVER_OK,SUGGEST_OK
> > Sep 13 21:29:23 xxxxx kernel: end_request: I/O error, dev sda, sector 1810985
> > Sep 13 21:29:23 xxxxx kernel: sd 0:0:1:0: [sda] Result: hostbyte=DID_SOFT_ERROR
> > driverbyte=DRIVER_OK,SUGGEST_OK
> > Sep 13 21:29:23 xxxxx kernel: end_request: I/O error, dev sda, sector 1811039
> > Sep 13 21:29:23 xxxxx kernel: JBD: Detected IO errors while flushing file data
> > on sda7
> > Sep 13 21:29:23 xxxxx kernel: JBD: Detected IO errors while flushing file data
> > on sda7

I'd think from the above errors that the problem is in the device itself,
or in the SCSI layer.  No amount of ext3 IO should be able to trigger SCSI
errors.

> > Similar errors occur with other post-2.6.17 kernels. Typical result is rpm
> > database corruption (see e.g. https://qa.mandriva.com/show_bug.cgi?id=32547
> > not reported by me) making system very difficult to use.
> > 
> > The problem simply did and does not exist with the
> > Mandriva 2.6.17 and old kernels using the Atlas III. I tried cloning
> > the Atlas III to the Ultrastar, and cannot reproduce using either the
> > Barracuda or the Ultrastar. Trying a different SCSI cable didn't help.

This sounds like a case where git-bisect of 2.6.17-2.6.18 would be able
to isolate the problem fairly efficiently.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

