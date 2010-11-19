From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Fri, 19 Nov 2010 10:21:35 -0500
Message-ID: <4CE695FF.20601@teksavvy.com>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com> <20101118130630.GJ6178@parisc-linux.org> <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <4CE59C9E.6050902@teksavvy.com> <1290177488-sup-6540@think> <4CE68F80.7000607@teksavvy.com> <20101119145748.GB27919@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Chris Mason <chris.mason@oracle.com>,
	James Bottomley <james.bottomley@suse.de>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	sandeen <sandeen@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:44305 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754778Ab0KSPVh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Nov 2010 10:21:37 -0500
In-Reply-To: <20101119145748.GB27919@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10-11-19 09:57 AM, Christoph Hellwig wrote:
> On Fri, Nov 19, 2010 at 09:53:52AM -0500, Mark Lord wrote:
>> On 10-11-19 09:40 AM, Chris Mason wrote:
>>>
>>> We've been told that online and constant trimming is the default in
>>> windows7.   The ssds are most likely to just start ignoring the trims
>>> they can't service efficiently.
>>
>> Win7 collects multiple TRIM ranges over time and batches them as single TRIMs
>> (as reported to me by an SSD vendor who traced it with a SATA analyzer,
>>   and who also apparently has "inside info").
>
> I really hate to rely on this third party hearsay (from all sides), and
> have implement TRIM support in qemu now.  I'll soon install win7 and
> will check out the TRIM patters myself.

Excellent!
