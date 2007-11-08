From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: More testing: 4x parallel 2G writes, sequential reads
Date: Wed, 07 Nov 2007 21:06:52 -0600
Message-ID: <47327D4C.7070604@redhat.com>
References: <47323F73.5080708@redhat.com> <20071108001434.GB16884@yzf.shaptech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Shapor Naghibzadeh <shapor@shapor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbXKHDG5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Nov 2007 22:06:57 -0500
In-Reply-To: <20071108001434.GB16884@yzf.shaptech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Shapor Naghibzadeh wrote:
> On Wed, Nov 07, 2007 at 04:42:59PM -0600, Eric Sandeen wrote:
>> Again this was on a decent HW raid so seek penalties are probably not
>> too bad.
> 
> You may want to verify that by doing a benchmark on the raw device.  I
> recently did some benchmarks doing random I/O on a Dell 2850 w/ a PERC
> (megaraid) RAID5 w/ 128MB onboard writeback cache and 6x 15krpm drives
> and noticed appoximately one order of magnitude throughput drop on
> small (stripe-sized) random reads versus linear.  It maxed out at ~100
> random read IOPs or "seeks/sec" (suprisingly low).
> 
> Out of curiousity, how are you counting the seeks?

Chris Mason's seekwatcher (google can find it for you) is doing the
graphing, it uses blocktrace for the raw data.

-Eric

> Shapor
