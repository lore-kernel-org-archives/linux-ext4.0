From: Andreas Dilger <adilger@sun.com>
Subject: Re: how to scale root-reserved space going forward...
Date: Mon, 02 Mar 2009 01:56:32 -0700
Message-ID: <20090302085632.GM3199@webber.adilger.int>
References: <49AB0ABE.1030009@redhat.com> <20090302024754.GF6973@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:48711 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbZCBI4v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Mar 2009 03:56:51 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n228ujwJ001097
	for <linux-ext4@vger.kernel.org>; Mon, 2 Mar 2009 00:56:47 -0800 (PST)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec 23 2008))
 id <0KFV00500FBPF200@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 02 Mar 2009 00:56:45 -0800 (PST)
In-reply-to: <20090302024754.GF6973@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 01, 2009  21:47 -0500, Theodore Ts'o wrote:
> This is a reasonable question.  What would be great is if we could get
> a benchmarking team to fill an ext4 filesystem with files.  The simple
> thing would be if we did something fixed --- say, 50 files per
> directory, each file 100k, and say 10 subdirectories in each
> directory, to some fixed depth, and with a filesystem size of at least
> 8 gigabytes (which would give us at least 16 flex groups with the
> default flex size of 16) --- and then filled each filesystem to from
> 0% to 90% in increments of 10%, and from 90% to 99% in increments of
> 1%, and then ran some throughput benchmark like bonnie on the mostly
> filled filesystem.

We've done tests like this, and it is important to take the inner vs.
outer cyliners into account.  It can happen that even a "perfectly"
allocated filesystem will appear to show slowdowns in performance as
it gets full, yet this is partitially due to physical disk layout issues.

> A better filler would probably use a random file sizes with a average
> size of say 64k, but with outliers from 4k to 128 megs, and a similar
> random distribution of number of files per directory, and number of
> subdirectories and depth of subdirectories.

You describe the Reiserfs "Mongo" benchmark.

> I suppose it would be good to do one set of charts with a filesystem
> size of 8 gigs, and another at 80 gigs and 800 gigs, and see if the
> shape of the filesystem curve changes at scale.  Once we have that, we
> would be in a position to make a reasonable set of defaults.
> 
> Or we could just guess and come up with some percentage figure that
> sounds good.  :-)

I suspect that at a certain filesystem size, there isn't much benefit
in having more reserved space.  If we keep 50GB of reserved space then
this is likely to contain a decent amount of 1MB free chunks, which is
what we really care about.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

