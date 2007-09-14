From: Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.23-rc6: hanging ext3 dbench tests
Date: Fri, 14 Sep 2007 10:49:05 +0100
Message-ID: <20070914094905.GA32670@shadowen.org>
References: <20070911124202.GI9556@shadowen.org> <alpine.LFD.0.999.0709110949250.16478@woody.linux-foundation.org> <20070911173049.GA10499@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	mel@csn.ul.ie
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hellhawk.shadowen.org ([80.68.90.175]:3554 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbXINJtY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Sep 2007 05:49:24 -0400
Content-Disposition: inline
In-Reply-To: <20070911173049.GA10499@shadowen.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 11, 2007 at 06:30:49PM +0100, Andy Whitcroft wrote:
> Annoyingly this seems to be intermittent, and I have not managed to get
> a machine into this state again yet.  Will keep trying.

Ok, I have been completly unsuccessful in reproducing this.  Dispite
having two distinct machines showing this behaviour.  I have neither
been able to reproduce it with those machine on 2.6.23-rc6 nor has any
of the testing of any of the -git releases which follow thrown this
error.  I have run about 10 repeats of the jobs which failed too and
none of those have thrown the same error.

It is pretty clear from the dbench output that the problem is/was real,
that its not some artifact of the test harness.  I am a loss as to how to
get this to trigger again.

I guess I will keep monitoring the ongoing tests for new instances.  I
will also look to getting the sysrq-* stuff triggered automatically on
job timeout as that seems like a sane plan in all cases.

Frustrated.

-apw
