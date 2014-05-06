From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 3/3] mke2fs: check for a partition table and warn if
 present
Date: Tue, 6 May 2014 14:52:02 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405061451230.2255@localhost.localdomain>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu> <1399295044-24489-3-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1405051549310.2223@localhost.localdomain> <20140505135804.GC22287@thunk.org> <alpine.LFD.2.00.1405051606480.2223@localhost.localdomain>
 <20140505142056.GE22287@thunk.org> <20140506122031.GQ5962@x2.net.home>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1800714552-1399380725=:2255"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512AbaEFMwH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2014 08:52:07 -0400
In-Reply-To: <20140506122031.GQ5962@x2.net.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1800714552-1399380725=:2255
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 6 May 2014, Karel Zak wrote:

> Date: Tue, 6 May 2014 14:20:31 +0200
> From: Karel Zak <kzak@redhat.com>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: Lukáš Czerner <lczerner@redhat.com>,
>     Ext4 Developers List <linux-ext4@vger.kernel.org>
> Subject: Re: [PATCH 3/3] mke2fs: check for a partition table and warn if
>     present
> 
> On Mon, May 05, 2014 at 10:20:56AM -0400, Theodore Ts'o wrote:
> > On Mon, May 05, 2014 at 04:11:41PM +0200, Lukáš Czerner wrote:
> > > 
> > > Fair enough. But we should still make the use of system libblkid by
> > > default if you do not have any objections.
> > 
> > What I want to do is test to see if there is a system libblkid
> > available at all, and if so, use it by default.  I want to be able to
> > use the internal libblkid for development testing purposes, but the
> > goal is that when Andreas builds on MacOS, it should use the internal
> > libblkid by default (since there is no system blkid), but on Linux
> > systems, we should use the system blkid by default in the 1.43 branch.
> 
> BTW, util-linux is not Linux only (although code portability is bonus
> rather than a primary goal :-). We have BSD, Solaris and GNU Hurd users. 
> 
> The plan for the next release (v2.25) is to support libs-only builds
> (for example build and install libblkid and libuuid, but nothing
> else).
> 
>     Karel

Nice, so we're a step further to actually get rid of the libblkid in
e2fsprogs tree ? :)

-Lukas
--8323328-1800714552-1399380725=:2255--
