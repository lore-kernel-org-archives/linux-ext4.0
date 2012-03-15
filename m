From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Thu, 15 Mar 2012 11:42:24 +0100
Message-ID: <CADDYkjRSd-Dv2jECwKt=3Q95hceVhiA+StZj1fvwywZHWaEgfw@mail.gmail.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
	<alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com>
	<BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com>
	<20120310044804.GB5652@thunk.org>
	<9709DE62-CE25-41C4-A33C-63336B51DC5E@whamcloud.com>
	<20120311161320.GC1048@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Ted Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@whamcloud.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47384 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2COKm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Mar 2012 06:42:26 -0400
In-Reply-To: <20120311161320.GC1048@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/3/11 Ted Ts'o <tytso@mit.edu>:

>
> Well, my goal in proposing this optimization is that helps for the
> "medium size" directories in the cold cache case. =A0The ext4 user wh=
o
> first kicked off this thread was using his file system for an SVN
> server, as I recall. =A0I could easily believe that he has thousands =
of
> files; maybe even tens of thousands of files in a directory. =A0But t=
hat
> probably still fits in 256k, or at best 512k worth of directory block=
s.
>

That was not a SVN server. It was a build host having checkouts of SVN
projects.

The many files/dirs case is common for VCS and the SVN is not the only
that would be affected here. AFAIR git.kernel.org was also suffering
from the getdents(). Same applies to commercial products that are
heavily stuffed with many files/dirs, e.g. ClearCase or Synergy. In
the second one case we are running on XFS for a longer while and I
must say that this was a huge improvement mostly on backup times
(where a dump of Informix and the whole filesystem is ordinary
compressed in tarball).

A medium size you are referring would most probably fit into 256k and
this could be enough for 90% of cases. Large production system running
on ext4 need backups thus those would benefit the most here.

-Jacek
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
