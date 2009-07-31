From: Michael Rubin <mrubin@google.com>
Subject: Re: [PATCH RFC] Insure direct IO writes do not use the page cache
Date: Fri, 31 Jul 2009 11:03:07 -0700
Message-ID: <532480950907311103s422a70acx25c0ab9c56d1ae31@mail.gmail.com>
References: <6601abe90907281728h22be79fenc68a16b578e28a91@mail.gmail.com>
	 <20090729181007.GC14105@mit.edu>
	 <20090730183053.GE9223@atrey.karlin.mff.cuni.cz>
	 <20090730203351.GB6833@mit.edu>
	 <1249063137.3917.8.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:1883 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZGaSDL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Jul 2009 14:03:11 -0400
Received: from zps77.corp.google.com (zps77.corp.google.com [172.25.146.77])
	by smtp-out.google.com with ESMTP id n6VI3Bvx004504
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2009 11:03:11 -0700
Received: from fxm27 (fxm27.prod.google.com [10.184.13.27])
	by zps77.corp.google.com with ESMTP id n6VI38iY018718
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2009 11:03:08 -0700
Received: by fxm27 with SMTP id 27so1218235fxm.11
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2009 11:03:07 -0700 (PDT)
In-Reply-To: <1249063137.3917.8.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 31, 2009 at 10:58 AM, Mingming<cmm@us.ibm.com> wrote:
> Eric and I looked at xfs code together the other day, xfs code did not
> ensure DIO sync metadata (conversion) before return back to userspace.
> It does ensure the workqueue kickoff the conversion and journal commit,
> but it seems not waiting for it to complete. This seems confirmed by xfs
> expert on IRC, who expressed DIO means only bypass page cache, but not
> necessarily means sync on data and metadata unless file is opened with
> SYNC mode.

This will our expectations for DIO on ext4 also.

mrubin
