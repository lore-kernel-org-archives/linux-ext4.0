From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH RFC] Insure direct IO writes do not use the page cache
Date: Wed, 29 Jul 2009 14:48:11 -0500
Message-ID: <4A70A77B.6080006@redhat.com>
References: <6601abe90907281728h22be79fenc68a16b578e28a91@mail.gmail.com> <6601abe90907290910x7cf1122cwac689d1f106326d3@mail.gmail.com> <4A708451.4060908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49261 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbZG2TsO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Jul 2009 15:48:14 -0400
In-Reply-To: <4A708451.4060908@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
...

> Also, IIRC xfs does the conversion to written (vs. unwritten) extents in
> an IO completion handler, just FWIW.

After talking w/ Jeff Moyer, realized that w/o using the io completion,
there's a race with AIO.

Userspace will get notified that the write is done before the extents
get flipped to initialized ....

-Eric
