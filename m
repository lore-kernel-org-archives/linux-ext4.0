From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [ltt-dev] LTTng 0.89 for Linux 2.6.29-rc3
Date: Thu, 5 Feb 2009 15:22:49 -0500
Message-ID: <20090205202249.GA26964@Krystal>
References: <20090130200757.GA14999@Krystal> <20090205140432.GE6915@linux.vnet.ibm.com> <20090205150242.GA27895@Krystal> <20090205151841.GF6915@linux.vnet.ibm.com> <20090205153825.GA30255@Krystal> <20090205155854.GG6915@linux.vnet.ibm.com> <5d5443650902050822r2e4d08ffg2322b45a5e009fb8@mail.gmail.com> <20090205180132.GJ6915@linux.vnet.ibm.com> <20090205183158.GA1969@Krystal> <20090205184456.GK6915@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Trilok Soni <soni.trilok@gmail.com>, ltt-dev@lists.casi.polymtl.ca,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tomts5.bellnexxia.net ([209.226.175.25]:62672 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083AbZBEUW7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Feb 2009 15:22:59 -0500
Content-Disposition: inline
In-Reply-To: <20090205184456.GK6915@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Thu, Feb 05, 2009 at 01:31:59PM -0500, Mathieu Desnoyers wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Thu, Feb 05, 2009 at 09:52:16PM +0530, Trilok Soni wrote:
> > > > Hi Paul,
> > > > 
> > > > On Thu, Feb 5, 2009 at 9:28 PM, Paul E. McKenney
> > > > <paulmck@linux.vnet.ibm.com> wrote:
> > > > >>
> > > > >> Are you using quilt to apply the patchset series file in the right order ?
> > > > >
> > > > > Ummm...  No.  I never have used quilt.
> > > > >
> > > > > Ah, there is a series file.  I guess it would not be too hard to make
> > > > > an appropriate "sh" command:
> > > > 
> > > > How about trying?
> > > > 
> > > > #quilt push -a
> > > 
> > > Is the appropriate incantation as follows?
> > > 
> > > 	cd <top of git tree>
> > > 	mkdir patches
> > > 	cp /tmp/patch-2.6.29-rc3-lttng-0.92/* patches
> > > 	quilt push -a
> > > 
> > 
> > Yes, exactly.
> 
> Whew!  ;-)
> 
> > And from there you can follow the LTTng manual here :
> > 
> > http://ltt.polymtl.ca/svn/trunk/lttv/LTTngManual.html
> 
> I get some fuzz and the following:
> 
> 	patching file kernel/trace/trace-clock-32-to-64.c
> 	Patch attempted to create file kernel/trace/trace-clock-32-to-64.c,
> 	which already exists.
> 	Hunk #1 FAILED at 1.
> 	1 out of 1 hunk FAILED -- rejects in file
> 	kernel/trace/trace-clock-32-to-64.c
> 
> Should I be starting from somewhere other than v2.6.29-rc3?
> 

Let's see it step by step, that should get us there.

With patches :

mkdir ~/lttng
cd ~/lttng
wget http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29-rc3.tar.bz2
wget http://lttng.org/files/lttng/patch-2.6.29-rc3-lttng-0.92.tar.bz2
bzip2 -cd linux-2.6.29-rc3.tar.bz2 |tar xvof -
bzip2 -cd patch-2.6.29-rc3-lttng-0.92.tar.bz2  |tar xvof -
cd linux-2.6.29-rc3
mkdir patches
ln -s ../patch-2.6.29-rc3-lttng-0.92 patches
quilt push -a

Does this work ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
