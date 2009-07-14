From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 2/2] HACK: do I/O read requests while ext3 journal	recovers
Date: Tue, 14 Jul 2009 17:26:25 -0400
Message-ID: <20090714212625.GE4829@webber.adilger.int>
References: <20090714140253.25993.64525.sendpatchset@ahunter-tower>
 <20090714140307.25993.26360.sendpatchset@ahunter-tower>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Andrew.Morton.akpm@linux-foundation.org,
	Andreas.Dilger.adilger@sun.com, Stephen.Tweedie.sct@redhat.com,
	Artem Bityutskiy <artem.bityutskiy@nokia.com>,
	linux-ext4@vger.kernel.org
To: Adrian Hunter <adrian.hunter@nokia.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:34724 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbZGNV0z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jul 2009 17:26:55 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6ELQqUX012977
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2009 14:26:52 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KMS00E00JDXKW00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 14 Jul 2009 14:26:52 -0700 (PDT)
In-reply-to: <20090714140307.25993.26360.sendpatchset@ahunter-tower>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 14, 2009  17:03 +0300, Adrian Hunter wrote:
> The ext3 journal can take a long time to recover at mount
> time.  That was partially fixed by placing a barrier into
> the I/O queue and then not waiting for the actual I/O to
> complete.

Note that you can also reduce the journal recovery time by
reducing the size of the journal.  Having a large journal
is needed for getting good performance with lots of updates
at high speeds.  If you aren't doing a large amount of
filesystem IO (which I'd guess for an embedded device, assuming
you are using it for that), then you could reduce the size of
the journal to the minimum (1000 blocks) and this will also
reduce the recovery time correspondingly.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

