From: Adrian Hunter <adrian.hunter@nokia.com>
Subject: Re: [PATCH 2/2] HACK: do I/O read requests while ext3 journal	recovers
Date: Wed, 15 Jul 2009 18:35:41 +0300
Message-ID: <4A5DF74D.7010100@nokia.com>
References: <20090714140253.25993.64525.sendpatchset@ahunter-tower> <20090714140307.25993.26360.sendpatchset@ahunter-tower> <20090714212625.GE4829@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Andrew.Morton.akpm@linux-foundation.org"
	<Andrew.Morton.akpm@linux-foundation.org>,
	"Andreas.Dilger.adilger@sun.com" <Andreas.Dilger.adilger@sun.com>,
	"Stephen.Tweedie.sct@redhat.com" <Stephen.Tweedie.sct@redhat.com>,
	"Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:25775 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbZGOPgA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jul 2009 11:36:00 -0400
In-Reply-To: <20090714212625.GE4829@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Jul 14, 2009  17:03 +0300, Adrian Hunter wrote:
>> The ext3 journal can take a long time to recover at mount
>> time.  That was partially fixed by placing a barrier into
>> the I/O queue and then not waiting for the actual I/O to
>> complete.
> 
> Note that you can also reduce the journal recovery time by
> reducing the size of the journal.  Having a large journal
> is needed for getting good performance with lots of updates
> at high speeds.  If you aren't doing a large amount of
> filesystem IO (which I'd guess for an embedded device, assuming
> you are using it for that), then you could reduce the size of
> the journal to the minimum (1000 blocks) and this will also
> reduce the recovery time correspondingly.

Yes that may help, although the number of blocks involved is
fairly small.


