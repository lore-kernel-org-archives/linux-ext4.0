From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Kernel 3.3.8 breaks accidental ext3 mount of extended partition
Date: Mon, 25 Jun 2012 16:04:32 -0400
Message-ID: <x49bok7yx7z.fsf@segfault.boston.devel.redhat.com>
References: <4FDEC3C2.4060909@secunet.com>
	<20120625113457.GA1289@amd.home.annexia.org>
	<x49r4t3z6s4.fsf@segfault.boston.devel.redhat.com>
	<20120625193218.GZ21859@amd.home.annexia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Torsten Hilbrich <torsten.hilbrich@secunet.com>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: "Richard W.M. Jones" <rjones@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab2FYUEi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jun 2012 16:04:38 -0400
In-Reply-To: <20120625193218.GZ21859@amd.home.annexia.org> (Richard
	W. M. Jones's message of "Mon, 25 Jun 2012 20:32:18 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Richard W.M. Jones" <rjones@redhat.com> writes:

> On Mon, Jun 25, 2012 at 12:38:03PM -0400, Jeff Moyer wrote:
>> Please try the attached patch instead.  The patch I had originally
>> posted for this allowed marking the first buffer beyond EOD as
>> uptodate.  This isn't correct.  The patch I've attached below fixes the
>> infinite loop in __getblk_slow.
>
> This patch appears to fix both problems, thanks.

Thanks for testing, Rich!

-Jeff
