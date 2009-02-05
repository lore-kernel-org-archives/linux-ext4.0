From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [ltt-dev] LTTng 0.89 for Linux 2.6.29-rc3
Date: Thu, 5 Feb 2009 07:58:54 -0800
Message-ID: <20090205155854.GG6915@linux.vnet.ibm.com>
References: <20090130200757.GA14999@Krystal> <20090205140432.GE6915@linux.vnet.ibm.com> <20090205150242.GA27895@Krystal> <20090205151841.GF6915@linux.vnet.ibm.com> <20090205153825.GA30255@Krystal>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ltt-dev@lists.casi.polymtl.ca, "Theodore Ts'o" <tytso@mit.edu>,
	linux-kernel@vger.kernel.org
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54033 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262AbZBEP65 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Feb 2009 10:58:57 -0500
Content-Disposition: inline
In-Reply-To: <20090205153825.GA30255@Krystal>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 05, 2009 at 10:38:25AM -0500, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Thu, Feb 05, 2009 at 10:02:42AM -0500, Mathieu Desnoyers wrote:
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > On Fri, Jan 30, 2009 at 03:07:57PM -0500, Mathieu Desnoyers wrote:
> > > > > Hi,
> > > > > 
> > > > > I just ported LTTng to the 2.6.29-rc3 kernel. It includes the following
> > > > > changes :
> > > > > 
> > > > > - Tree RCU instrumentation
> > > > > - Updated ext4 and jbd2 instrumentation
> > > > > 
> > > > > Please feel free to try it and report any success/problem you may have.
> > > > > Note that cross-build has been slightly less tested this time because
> > > > > I'll have to upgrade many of my compilers to a version compatible with
> > > > > kernel 2.6.29-rc.
> > > > > 
> > > > > It also includes the recently added kprobes support through a simple
> > > > > 
> > > > > echo symbol_name > /mnt/debugfs/ltt/kprobes/enable
> > > > > 
> > > > > It's available at the new LTTng website :
> > > > > 
> > > > > http://www.lttng.org/
> > > > 
> > > > Hello, Matheiu,
> > > > 
> > > > When I try to apply this to v2.6.29-rc3, I get the following:
> > > > 
> > > > 	can't find file to patch at input line 61
> > > > 	Perhaps you used the wrong -p or --strip option?
> > > > 	The text leading up to this was:
> > > > 	--------------------------
> > > > 	|get_ltt_root() is necessary for ltt-trace-control to create subdirs in
> > > > 	ltt's
> > > > 	|debugfs dir.
> > > > 	|
> > > > 	|From: Zhao Lei <zhaolei@cn.fujitsu.com>
> > > > 	|Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> > > > 	|Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > > > 	|---
> > > > 	| include/linux/ltt-core.h |    8 ++++++++
> > > > 	| ltt/ltt-core.c           |   14 ++++++++++++++
> > > > 	| ltt/ltt-relay.c          |    8 +-------
> > > > 	| 3 files changed, 23 insertions(+), 7 deletions(-)
> > > > 	|
> > > > 	|Index: linux-2.6-lttng/include/linux/ltt-core.h
> > > > 	|===================================================================
> > > > 	|--- linux-2.6-lttng.orig/include/linux/ltt-core.h      2009-01-15
> > > > 	15:55:18.000000000 -0500
> > > > 	|+++ linux-2.6-lttng/include/linux/ltt-core.h   2009-01-15
> > > > 	15:55:24.000000000 -0500
> > > > 
> > > > Help?
> > > > 
> > > 
> > > Hi Paul,
> > > 
> > > I must admit I'm a bit puzzled. I've tried to quilt push -a both 
> > > LTTng 0.89 and LTTng 0.92 taken from the website and they both apply
> > > correctly on 2.6.29-rc3. When I quilt pop -a, neither of those 3 files
> > > (include/linux/ltt-core.h, ltt/ltt-core.c, ltt/ltt-relay.c) are stucked
> > > in my tree.
> > > 
> > > I've used files from :
> > > 
> > > http://www.lttng.org/files/lttng/patch-2.6.29-rc3-lttng-0.92.tar.bz2
> > > 
> > > Which tarballs are you using exactly ?
> > 
> > That is indeed the one that I am using.
> > 
> > > I guess you need to apply them to your existing tree, so pointing you to
> > > git.kernel.org lttng tree won't help much here.
> > 
> > I am attempting to apply to v2.6.29-rc3, which is commit
> > 18e352e4a73465349711a9324767e1b2453383e2 in the linux-2.6 git tree.
> > 
> > Later on, I might well want to apply on top of some other stuff, but
> > figured I should try it straight first.  ;-)
> > 
> 
> Are you using quilt to apply the patchset series file in the right order ?

Ummm...  No.  I never have used quilt.

Ah, there is a series file.  I guess it would not be too hard to make
an appropriate "sh" command:

cat /tmp/patch-2.6.29-rc3-lttng-0.92/series | grep -v '^#' | sed -e 's/^/patch
-p1 < \/tmp\/patch-2.6.29-rc3-lttng-0.92\//' | sh

But this complains about directories.  OK, "sudo apt-get install quilt"
followed by "man quilt".  Than "quilt import" seems to do some of the
work, but doesn't seem to apply all the patches.  Thank goodness for
"git reset --hard"!!!

Help?

							Thanx, Paul

> Mathieu
> 
> > 							Thanx, Paul
> > 
> > > Mathieu
> > > 
> > > > 							Thanx, Paul
> > > 
> > > -- 
> > > Mathieu Desnoyers
> > > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > _______________________________________________
> > ltt-dev mailing list
> > ltt-dev@lists.casi.polymtl.ca
> > http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
