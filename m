From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: #blocks per group too big: 37265
Date: Thu, 03 Apr 2008 14:24:38 -0500
Message-ID: <47F52EF6.5040905@redhat.com>
References: <20080403161904.GA31670@msgid.wurtel.net> <47F51AC6.6010205@redhat.com> <20080403191254.GG13486@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667AbYDCTZF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Apr 2008 15:25:05 -0400
In-Reply-To: <20080403191254.GG13486@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Thu, Apr 03, 2008 at 12:58:30PM -0500, Eric Sandeen wrote:
>>> I obtained the 1.39-tyt3 version of e2fsprogs, and did:
> 
>>> | mke2fs 1.38 (30-Jun-2005)
> 
>> I'd probably not use 1.39-tyt3... that's pretty old.  (see the 2005?) :)
> 
> Actually, e2fsprogs 1.39-tyt isn't that old (April 2007).  The 2005 is
> because the mke2fs in use was 1.38, not 1.39.  (Which was probably
> another problem.)

Ah, missed that.

Ted, it looks like the stride value is still getting % 65536, just FWIW.

[e2fsprogs]$ misc/mke2fs -F -E stride=65536 testit
mke2fs 1.40.8 (13-Mar-2008)
Invalid stride parameter: 65536

Bad option(s) specified:
...

[e2fsprogs]$ misc/mke2fs -F -E stride=65537 testit
mke2fs 1.40.8 (13-Mar-2008)

Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
...

I'll send a patch for it in a bit, trying not to get too distracted
right now ;)

-Eric

