From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/2] HACK: ext3: mount fast even when recovering
Date: Tue, 14 Jul 2009 18:36:49 -0400
Message-ID: <20090714223649.GJ10131@mit.edu>
References: <20090714140548.26116.2919.sendpatchset@ahunter-tower> <20090714140554.26116.54779.sendpatchset@ahunter-tower> <20090714143449.cae624c8.akpm@linux-foundation.org> <4A5CFCBD.70305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Adrian Hunter <adrian.hunter@nokia.com>, sct@redhat.com,
	adilger@sun.com, linux-ext4@vger.kernel.org,
	artem.bityutskiy@nokia.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45568 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683AbZGNWhQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Jul 2009 18:37:16 -0400
Content-Disposition: inline
In-Reply-To: <4A5CFCBD.70305@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 14, 2009 at 04:46:37PM -0500, Eric Sandeen wrote:
> 
> (whoa, can barriers make something faster?  who woulda thunk it)

I sent this reply in response to the first Adrian's first e-mail, that
had bogus e-mail addresses for akpm and sct, so resending it here:


Have you actually benchmarked these patches, ideally with a fixed
filesystem image so the two runs are done requiring exactly the same
number of blocks to recover?  We implement ordered I/O in terms of
doing a flush, so it would be surprising to see that a significant
difference in times.  Also, it would be useful to do a blktrace before
and after your patches, again with a fixed filesystem image so the
experiment can be carefully controlled.

Regards,

                                                - Ted
