From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [Q] ext3 mkfs: zeroing journal blocks
Date: Mon, 11 May 2009 13:44:18 -0500
Message-ID: <4A087202.4010601@redhat.com>
References: <71a0d6ff0905110803t1a6b34ccq91d5494f95fe1f34@mail.gmail.com> <4A086763.9090907@redhat.com> <20090511182050.GA3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Alexander Shishkin <alexander.shishckin@gmail.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51116 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbZEKSoU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 May 2009 14:44:20 -0400
In-Reply-To: <20090511182050.GA3209@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:

> The reason that the journal is zeroed is because there is some chance
> that old (valid at the time) transaction headers and commit blocks might
> be in the journal and could accidentally be "recovered" and cause bad
> corruption of the filesystem.

But I guess the question is, why isn't a normal internal log zeroed?

If I'm reading it right only external logs get this treatment, and I
think that's what generated the original question from Alexander.

-Eric
