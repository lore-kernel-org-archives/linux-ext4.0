From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [ltt-dev] LTTng 0.89 for Linux 2.6.29-rc3
Date: Thu, 5 Feb 2009 10:44:56 -0800
Message-ID: <20090205184456.GK6915@linux.vnet.ibm.com>
References: <20090130200757.GA14999@Krystal> <20090205140432.GE6915@linux.vnet.ibm.com> <20090205150242.GA27895@Krystal> <20090205151841.GF6915@linux.vnet.ibm.com> <20090205153825.GA30255@Krystal> <20090205155854.GG6915@linux.vnet.ibm.com> <5d5443650902050822r2e4d08ffg2322b45a5e009fb8@mail.gmail.com> <20090205180132.GJ6915@linux.vnet.ibm.com> <20090205183158.GA1969@Krystal>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Trilok Soni <soni.trilok@gmail.com>, ltt-dev@lists.casi.polymtl.ca,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33116 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627AbZBESo6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Feb 2009 13:44:58 -0500
Content-Disposition: inline
In-Reply-To: <20090205183158.GA1969@Krystal>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 05, 2009 at 01:31:59PM -0500, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Thu, Feb 05, 2009 at 09:52:16PM +0530, Trilok Soni wrote:
> > > Hi Paul,
> > > 
> > > On Thu, Feb 5, 2009 at 9:28 PM, Paul E. McKenney
> > > <paulmck@linux.vnet.ibm.com> wrote:
> > > >>
> > > >> Are you using quilt to apply the patchset series file in the right order ?
> > > >
> > > > Ummm...  No.  I never have used quilt.
> > > >
> > > > Ah, there is a series file.  I guess it would not be too hard to make
> > > > an appropriate "sh" command:
> > > 
> > > How about trying?
> > > 
> > > #quilt push -a
> > 
> > Is the appropriate incantation as follows?
> > 
> > 	cd <top of git tree>
> > 	mkdir patches
> > 	cp /tmp/patch-2.6.29-rc3-lttng-0.92/* patches
> > 	quilt push -a
> > 
> 
> Yes, exactly.

Whew!  ;-)

> And from there you can follow the LTTng manual here :
> 
> http://ltt.polymtl.ca/svn/trunk/lttv/LTTngManual.html

I get some fuzz and the following:

	patching file kernel/trace/trace-clock-32-to-64.c
	Patch attempted to create file kernel/trace/trace-clock-32-to-64.c,
	which already exists.
	Hunk #1 FAILED at 1.
	1 out of 1 hunk FAILED -- rejects in file
	kernel/trace/trace-clock-32-to-64.c

Should I be starting from somewhere other than v2.6.29-rc3?

							Thanx, Paul
