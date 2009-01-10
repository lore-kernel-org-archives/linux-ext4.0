From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [ltt-dev] LTTng 0.74 for Linux 2.6.28 (ext4 tracepoints)
Date: Sat, 10 Jan 2009 11:11:38 -0500
Message-ID: <20090110161137.GA20526@Krystal>
References: <20090109235449.GA21999@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:37298 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900AbZAJQQl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Jan 2009 11:16:41 -0500
Content-Disposition: inline
In-Reply-To: <20090109235449.GA21999@Krystal>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

LTTng 0.74 fixes the probe Makefile to build the net-trace probe module.
It also adds jbd2 and ext4 tracepoints, and jbd2 probe module.

A new version including ext4 probe module should be available shortly.

Installation QUICKSTART :
http://ltt.polymtl.ca/svn/trunk/lttv/QUICKSTART

git url :

http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=shortlog;h=2.6.28-lttng-0.74

tarball : 

http://ltt.polymtl.ca/lttng/patch-2.6.28-lttng-0.74.tar.gz

jbd2/ext4 patches within the tarball :

ext4-instrumentation-add-tracepoints.patch
jbd2-instrumentation-move-to-tracepoints.patch
lttng-instrumentation-jbd2-probes.patch

Mathieu

* Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> Hi everyone,
> 
> I just ported LTTng to 2.6.28. Enjoy !
> 
> You may also want to upgrade to lttv 0.12.5 which puts back the syscall
> and softirq names in the event list.
> 
> For newcomers, instructions to install LTTng can be found at :
> http://ltt.polymtl.ca/svn/trunk/lttv/QUICKSTART
> 
> (I just updated the QUICKSTART guide. Please feel free to try it and
> report inconsistencies.)
> 
> Mathieu
> 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
