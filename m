From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/2] HACK: ext3: mount fast even when recovering
Date: Tue, 14 Jul 2009 17:22:21 -0400
Message-ID: <20090714212221.GD4829@webber.adilger.int>
References: <20090714140253.25993.64525.sendpatchset@ahunter-tower>
 <20090714140301.25993.97749.sendpatchset@ahunter-tower>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	Artem Bityutskiy <artem.bityutskiy@nokia.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:60648 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbZGNVWn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jul 2009 17:22:43 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6ELMNeb015360
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2009 14:22:38 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KMS00800J4VHX00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 14 Jul 2009 14:22:23 -0700 (PDT)
In-reply-to: <20090714140301.25993.97749.sendpatchset@ahunter-tower>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 14, 2009  17:03 +0300, Adrian Hunter wrote:
> Speed up ext3 recovery mount time by not sync'ing the
> block device.  Instead place all dirty buffers into the
> I/O queue and add a write barrier.  This ensures that
> no subsequent write will reach the disk before all the
> recovery writes, but that we do not have to wait for the
> I/O.
> 
> +	/*
> +	 * Set an option to indicate that we want to mount fast even
> +	 * when recovering.  That is achieved by not sync'ing the
> +	 * block device, but instead placing all dirty buffers into
> +	 * the I/O queue and adding a write barrier.
> +	 */
> +	set_opt(sbi->s_mount_opt, FAST);

Is there ever a time where one wouldn't want to do a fast mount?
Surely if this speeds things up and is safe, it makes sense to do
it always.  If it isn't safe to do always, then would you EVER want
to do it if you risk corrupting your filesystem?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

