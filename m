From: CAI Qian <caiqian@redhat.com>
Subject: Re: 3.10 GA: ext4 crash on power7
Date: Mon, 8 Jul 2013 04:19:01 -0400 (EDT)
Message-ID: <1104940584.434263.1373271541663.JavaMail.root@redhat.com>
References: <2044908741.7743522.1372746883931.JavaMail.root@redhat.com> <1598633085.7744466.1372747320569.JavaMail.root@redhat.com> <20130706115200.GC32062@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:59523 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab3GHITE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Jul 2013 04:19:04 -0400
In-Reply-To: <20130706115200.GC32062@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



----- Original Message -----
> From: "Theodore Ts'o" <tytso@mit.edu>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Sent: Saturday, July 6, 2013 7:52:00 PM
> Subject: Re: 3.10 GA: ext4 crash on power7
> 
> On Tue, Jul 02, 2013 at 02:42:00AM -0400, CAI Qian wrote:
> > This has never been seen during either 3.10-rc7 or the last year's ext4
> > devel tree testing. Maybe because I have recently upgraded the distro
> > of the Fedora to the latest. This has happened using the fs_mark test and
> > reproduced on all power7 systems.
> 
> Can you reproduce it with the newer Fedora userspace and the 3.10-rc7
> kernel?   If so, perhaps this is something we could bisect?
> 
> Thanks,
> 
> 	     	 	      	 	   - Ted
> 
Hi Ted, so the bisect right now pointed out that the problem was introduced back
in the 3.10-rc1. I am keep running...
CAI Qian
