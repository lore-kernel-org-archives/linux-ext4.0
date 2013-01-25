From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] ext4: call WARN_ON after the debug message
Date: Fri, 25 Jan 2013 16:14:30 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1301251613260.20753@localhost>
References: <1359045044-31435-1-git-send-email-lczerner@redhat.com> <20130124195458.GD9477@thunk.org> <alpine.LFD.2.00.1301251012200.20753@localhost> <20130125150948.GK28908@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-274057290-1359126873=:20753"
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368Ab3AYPOf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jan 2013 10:14:35 -0500
In-Reply-To: <20130125150948.GK28908@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-274057290-1359126873=:20753
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 25 Jan 2013, Theodore Ts'o wrote:

> Date: Fri, 25 Jan 2013 10:09:48 -0500
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 1/2] ext4: call WARN_ON after the debug message
> 
> On Fri, Jan 25, 2013 at 10:22:44AM +0100, Lukáš Czerner wrote:
> > 
> > we can get the EIO error from ext4_map_blocks not only in the case
> > of hardware error. The extent tree might not be in consistent state,
> > or we could even ask for blocks outside the file system itself (I
> > believe I've seen this before) and I think that in those cases it
> > might be worth to all WARN_ON.
> 
> Sure, but in those cases, the file system is corrupt, and we should
> have thrown an ext4_error() in ext4_map_blocks().  The point is that a
> WARN_ON is only useful if there is a potential programming bug.  If we
> know for sure that it's caused by a file system corruption, then we
> don't want to throw a WARN_ON.
> 
> Even if there is a kerneloops.org replacement --- in fact, especially
> if there is kerneloops.org replacement --- we only want to throw
> WARN_ON's in cases where it's just a pedestrian file system
> corruption.  Otherwise we'll end up wasting a lot of time chasing down
> something which was caused by a hardware error, and needing to calm
> down users (and breathless, spectacularizing, irresponsible journalism
> from web sites such as Phoronix).
> 
> 					- Ted

Fair enough, I'll remove the WARN_ON and use ext4_warning() instead
of ext4_msg.

Thanks!
-Lukas
--8323328-274057290-1359126873=:20753--
