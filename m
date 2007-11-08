From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: More testing: 4x parallel 2G writes, sequential reads
Date: Wed, 07 Nov 2007 21:39:33 -0600
Message-ID: <473284F5.4010000@redhat.com>
References: <47323F73.5080708@redhat.com> <20071107230905.GQ3966@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbXKHDjh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Nov 2007 22:39:37 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lA83dabb010547
	for <linux-ext4@vger.kernel.org>; Wed, 7 Nov 2007 22:39:36 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lA83daFk030788
	for <linux-ext4@vger.kernel.org>; Wed, 7 Nov 2007 22:39:36 -0500
In-Reply-To: <20071107230905.GQ3966@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:

> The test shows ext4 finishing marginally faster in the write case, and
> marginally slower in the read case.  What happens if you have 4 parallel
> readers?

http://people.redhat.com/esandeen/seekwatcher/ext4_4_thread_par_read.png
http://people.redhat.com/esandeen/seekwatcher/xfs_4_thread_par_read.png
http://people.redhat.com/esandeen/seekwatcher/ext4_xfs_4_thread_par_read.png

-Eric
