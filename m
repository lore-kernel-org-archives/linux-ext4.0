From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Thu, 18 Dec 2008 19:34:14 -0600
Message-ID: <494AFA16.2010004@redhat.com>
References: <4908C951.2000309@redhat.com> <20081103184426.GA31894@ajones-laptop.nbttech.com> <20081103113318.35b0c266.akpm@linux-foundation.org> <20081103201428.GB30565@ajones-laptop.nbttech.com> <20081218231707.GB20092@atrey.karlin.mff.cuni.cz> <494ADEB3.8010109@redhat.com> <20081219002752.GE8424@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Arthur Jones <ajones@riverbed.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sct@redhat.com" <sct@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60438 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbYLSBeX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Dec 2008 20:34:23 -0500
In-Reply-To: <20081219002752.GE8424@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:

>> In looking at what we have today, I wonder if we can make things smarter
>> so that we don't commit empty transactions in any case?
>   Probably it does not make sence to commit such transactions and we might
> save some time in sync paths if we do so. So yes, I think skipping empty
> transaction commit might be worthwhile and it shouldn't be hard to do
> either. But I'd give it serious testing just in case some unexpectedly
> relies on this behaviour - wouldn't this interfere e.g. with sync
> transaction batching autotuning code? Untested patch below...
> 								Honza


Cool, thanks!  This's stop:

# sync

from spinning up disks under idle filesystems too, I think.

I was looking at something similar but was still working out how many
things to check before deciding if the transaction was in fact empty.  :)

-Eric
