From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext3 warnings from LTP rename14
Date: Tue, 16 Oct 2007 20:20:59 -0500
Message-ID: <4715637B.1090503@redhat.com>
References: <20071017002009.GA2966@palantir8>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761546AbXJQBVA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Oct 2007 21:21:00 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id l9H1KxPa013496
	for <linux-ext4@vger.kernel.org>; Tue, 16 Oct 2007 21:20:59 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l9H1KwIE000384
	for <linux-ext4@vger.kernel.org>; Tue, 16 Oct 2007 21:20:58 -0400
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l9H1KvKq003825
	for <linux-ext4@vger.kernel.org>; Tue, 16 Oct 2007 21:20:58 -0400
In-Reply-To: <20071017002009.GA2966@palantir8>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Martin Habets wrote:
> Hello,
> 
> I ran the ltp-full-20070930 tests on 2.6.23-rc9-mph4 (sparc32 SMP), and am
> seeing the following warnings:

This makes me a little nervous about my change
ef2b02d3e617cb0400eedf2668f86215e1b0e6af
(ext34: ensure do_split leaves enough free space in both blocks)

Do you know when this first showed up?  Could you test -rc6?

You say you can reproduce it; have you checked (fsck'd) the filesystem
in between, and is it in good shape?

-Eric
