From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] ext4: call WARN_ON after the debug message
Date: Mon, 28 Jan 2013 08:10:40 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1301280810210.23664@dhcp-1-104.brq.redhat.com>
References: <1359045044-31435-1-git-send-email-lczerner@redhat.com> <20130124195458.GD9477@thunk.org> <alpine.LFD.2.00.1301251012200.20753@localhost> <20130125150948.GK28908@thunk.org> <20130126010055.GH2667@dastard>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571107329-1835304876-1359357043=:23664"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	=?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab3A1HKx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 02:10:53 -0500
In-Reply-To: <20130126010055.GH2667@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571107329-1835304876-1359357043=:23664
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sat, 26 Jan 2013, Dave Chinner wrote:

> Date: Sat, 26 Jan 2013 12:00:55 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: Lukáš Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 1/2] ext4: call WARN_ON after the debug message
> 
> On Fri, Jan 25, 2013 at 10:09:48AM -0500, Theodore Ts'o wrote:
> > On Fri, Jan 25, 2013 at 10:22:44AM +0100, Lukáš Czerner wrote:
> > > 
> > > we can get the EIO error from ext4_map_blocks not only in the case
> > > of hardware error. The extent tree might not be in consistent state,
> > > or we could even ask for blocks outside the file system itself (I
> > > believe I've seen this before) and I think that in those cases it
> > > might be worth to all WARN_ON.
> > 
> > Sure, but in those cases, the file system is corrupt, and we should
> > have thrown an ext4_error() in ext4_map_blocks().  The point is that a
> > WARN_ON is only useful if there is a potential programming bug.  If we
> > know for sure that it's caused by a file system corruption, then we
> > don't want to throw a WARN_ON.
> 
> FWIW, XFS handles this problem with an error level sysctl. For
> situations like this, the default level doesn't throw stack traces
> (just the error message), but there are situations where diagnosis
> requires emitting the stack trace.
> 
> Hence if it is necessary for bug triage, users can then turn the
> sysctl up to 11 and the stack trace will be emitted after the
> warning message.  CONFIG_XFS_DEBUG sets the default log level to 11,
> because developers always want to know where an error came from ;)
> 
> Cheers,
> 
> Dave.
> 

That might actually be very useful. Thanks Dave!

-Lukas
--571107329-1835304876-1359357043=:23664--
