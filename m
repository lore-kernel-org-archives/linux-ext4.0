From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] e2fsprogs: remove misleading argument from
	ext2fs_bg_flags_clear
Date: Wed, 02 Sep 2009 23:12:35 -0600
Message-ID: <20090903051235.GL4197@webber.adilger.int>
References: <4A9EE6E4.2000307@redhat.com>
 <20090902232811.GG4197@webber.adilger.int> <20090902234243.GC30497@mit.edu>
 <4A9F313E.8030605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33995 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbZICFM3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2009 01:12:29 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n835CRIB015801
	for <linux-ext4@vger.kernel.org>; Wed, 2 Sep 2009 22:12:27 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KPD00H00QASQM00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Wed,
 02 Sep 2009 22:12:27 -0700 (PDT)
In-reply-to: <4A9F313E.8030605@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 02, 2009  22:00 -0500, Eric Sandeen wrote:
> What about perhaps just these 3:
>
> ext2fs_bg_flags_zero(fs, group) /* zeros bg_flags */
>
> ext2fs_bg_flags_set(fs, group, flags) /* adds flags to bg_flags */
> ext2fs_bg_flags_clear(fs, group, flags) /* clears flags in bg_flags */
>
> and remove the original ext2fs_bg_flags_set / ext2fs_bg_flags_clear.

Yes, this is exactly what I would expect from this kind of interface.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

