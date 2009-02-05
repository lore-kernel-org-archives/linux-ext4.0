From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: LTTng 0.89 for Linux 2.6.29-rc3
Date: Thu, 5 Feb 2009 06:04:33 -0800
Message-ID: <20090205140432.GE6915@linux.vnet.ibm.com>
References: <20090130200757.GA14999@Krystal>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58826 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbZBEOEj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Feb 2009 09:04:39 -0500
Content-Disposition: inline
In-Reply-To: <20090130200757.GA14999@Krystal>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 30, 2009 at 03:07:57PM -0500, Mathieu Desnoyers wrote:
> Hi,
> 
> I just ported LTTng to the 2.6.29-rc3 kernel. It includes the following
> changes :
> 
> - Tree RCU instrumentation
> - Updated ext4 and jbd2 instrumentation
> 
> Please feel free to try it and report any success/problem you may have.
> Note that cross-build has been slightly less tested this time because
> I'll have to upgrade many of my compilers to a version compatible with
> kernel 2.6.29-rc.
> 
> It also includes the recently added kprobes support through a simple
> 
> echo symbol_name > /mnt/debugfs/ltt/kprobes/enable
> 
> It's available at the new LTTng website :
> 
> http://www.lttng.org/

Hello, Matheiu,

When I try to apply this to v2.6.29-rc3, I get the following:

	can't find file to patch at input line 61
	Perhaps you used the wrong -p or --strip option?
	The text leading up to this was:
	--------------------------
	|get_ltt_root() is necessary for ltt-trace-control to create subdirs in
	ltt's
	|debugfs dir.
	|
	|From: Zhao Lei <zhaolei@cn.fujitsu.com>
	|Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
	|Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
	|---
	| include/linux/ltt-core.h |    8 ++++++++
	| ltt/ltt-core.c           |   14 ++++++++++++++
	| ltt/ltt-relay.c          |    8 +-------
	| 3 files changed, 23 insertions(+), 7 deletions(-)
	|
	|Index: linux-2.6-lttng/include/linux/ltt-core.h
	|===================================================================
	|--- linux-2.6-lttng.orig/include/linux/ltt-core.h      2009-01-15
	15:55:18.000000000 -0500
	|+++ linux-2.6-lttng/include/linux/ltt-core.h   2009-01-15
	15:55:24.000000000 -0500

Help?

							Thanx, Paul
