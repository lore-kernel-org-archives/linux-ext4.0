From: Shapor Naghibzadeh <shapor@shapor.com>
Subject: Re: More testing: 4x parallel 2G writes, sequential reads
Date: Wed, 7 Nov 2007 16:14:34 -0800
Message-ID: <20071108001434.GB16884@yzf.shaptech.com>
References: <47323F73.5080708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yzf.shapor.com ([216.75.12.152]:33766 "EHLO yzf.shapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910AbXKHAla (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Nov 2007 19:41:30 -0500
Content-Disposition: inline
In-Reply-To: <47323F73.5080708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 07, 2007 at 04:42:59PM -0600, Eric Sandeen wrote:
> Again this was on a decent HW raid so seek penalties are probably not
> too bad.

You may want to verify that by doing a benchmark on the raw device.  I
recently did some benchmarks doing random I/O on a Dell 2850 w/ a PERC
(megaraid) RAID5 w/ 128MB onboard writeback cache and 6x 15krpm drives
and noticed appoximately one order of magnitude throughput drop on
small (stripe-sized) random reads versus linear.  It maxed out at ~100
random read IOPs or "seeks/sec" (suprisingly low).

Out of curiousity, how are you counting the seeks?

Shapor
