From: Adrian Hunter <adrian.hunter@nokia.com>
Subject: Re: [PATCH 1/2] HACK: ext3: mount fast even when recovering
Date: Wed, 15 Jul 2009 18:35:38 +0300
Message-ID: <4A5DF74A.8090607@nokia.com>
References: <20090714140548.26116.2919.sendpatchset@ahunter-tower> <20090714140554.26116.54779.sendpatchset@ahunter-tower> <20090714143449.cae624c8.akpm@linux-foundation.org> <4A5CFCBD.70305@redhat.com> <20090714223649.GJ10131@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"sct@redhat.com" <sct@redhat.com>,
	"adilger@sun.com" <adilger@sun.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:25863 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518AbZGOPga (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jul 2009 11:36:30 -0400
In-Reply-To: <20090714223649.GJ10131@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, Jul 14, 2009 at 04:46:37PM -0500, Eric Sandeen wrote:
>> (whoa, can barriers make something faster?  who woulda thunk it)
> 
> I sent this reply in response to the first Adrian's first e-mail, that
> had bogus e-mail addresses for akpm and sct, so resending it here:

Sorry about that.

> Have you actually benchmarked these patches, ideally with a fixed
> filesystem image so the two runs are done requiring exactly the same
> number of blocks to recover?  We implement ordered I/O in terms of
> doing a flush, so it would be surprising to see that a significant
> difference in times.  Also, it would be useful to do a blktrace before
> and after your patches, again with a fixed filesystem image so the
> experiment can be carefully controlled.

Yes the I/O is no faster.

The hacks just make the file system available for reading while recovery I/O
is ongoing.

Attempts to write are likely to block (even buffered I/O must wait for
locked buffers).

I will send some examples.
