From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Fri, 19 Nov 2010 09:50:16 -0500
Message-ID: <4CE68EA8.9020709@teksavvy.com>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com> <20101118130630.GJ6178@parisc-linux.org> <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com> <1290168976.2570.45.camel@dolmen> <4CE68155.50705@teksavvy.com> <20101119140203.GC10039@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>, Steven Whitehouse <swhiteho@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Christoph Hellwig <hch@infradead.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:24348 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753548Ab0KSOuU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Nov 2010 09:50:20 -0500
In-Reply-To: <20101119140203.GC10039@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10-11-19 09:02 AM, Ted Ts'o wrote:
> On Fri, Nov 19, 2010 at 08:53:25AM -0500, Mark Lord wrote:
>
>> Non-deterministic TRIM _should_ also try to ensure that the original data
>> is no longer there (for security reasons), so it _may_ have the same issues.
>
> Says who?  We've deleted files on hard drives for a long time without
> scrubbing data blocks.

"should" try, not "must" try.  :)

It's not mandatory, but I feel it is a Good Idea(tm).
That's why it "may" have the same issues.  Or not.

Thanks Ted.
