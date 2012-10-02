From: "Holger Hoffstaette" <holger.hoffstaette@googlemail.com>
Subject: Re: Repeatable ext4 oops with 3.6.0 (regression)
Date: Tue, 02 Oct 2012 16:31:57 +0200
Message-ID: <pan.2012.10.02.14.31.57.530230@googlemail.com>
References: <pan.2012.10.02.11.19.55.793436@googlemail.com> <20121002133642.GD22777@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53573 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab2JBOdP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Oct 2012 10:33:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1TJ3Wm-0007GU-WA
	for linux-ext4@vger.kernel.org; Tue, 02 Oct 2012 16:32:53 +0200
Received: from p54876660.dip.t-dialin.net ([84.135.102.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 02 Oct 2012 16:32:52 +0200
Received: from holger.hoffstaette by p54876660.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 02 Oct 2012 16:32:52 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 02 Oct 2012 15:36:42 +0200, Jan Kara wrote:

>   Thanks for report! Can you please attach here full dmesg after the oops
> happens - the output from syslog seems to be partially filtered which
> makes things unnecessarily hard... Thanks!

The output was cut from /var/log/messages since the machine hung and that file
was intact. Following are dmesg from the reboot after the crash and after
that is the full messages file from the crash I just reproduced; this time
gthumb "properly" segfaulted (15:49:32), but the kernel still started to
tumble and hung a few seconds later. Produced even more fireworks this
time. :)

(..after several posting attempts..)

I'm reading this through gmane and the files are apparently too big for
posting, so I put them here: http://hoho.dyndns.org/~holger/ext4-oops-3.6.0/

Just let me know if you need anything else.

Holger


