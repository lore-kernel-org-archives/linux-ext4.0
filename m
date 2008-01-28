From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Integrating patches in SLES10 e2fsprogs
Date: Mon, 28 Jan 2008 10:54:45 -0600
Message-ID: <479E08D5.3040609@redhat.com>
References: <20080124211728.GA24900@webber.adilger.int> <n7xir1iq69b.fsf@sor.suse.de> <20080127050543.GC24842@mit.edu> <n7x1w82nf7m.fsf@sor.suse.de> <20080128153802.GB17752@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Matthias Koenig <mkoenig@suse.de>, linux-ext4@vger.kernel.org,
	hvogel@suse.de, Girish Shilamkar <Girish.Shilamkar@Sun.COM>,
	Eric Sandeen <esandeen@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbYA1QzL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 11:55:11 -0500
In-Reply-To: <20080128153802.GB17752@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Mon, Jan 28, 2008 at 04:26:53PM +0100, Matthias Koenig wrote:
>>> Patch6:         e2fsprogs-mdraid.patch
>>>
>>> This apparently adds a new environment variable,
>>> BLKID_SKIP_CHECK_MDRAID, which forces blkid to not detect mdraid
>>> devices.  I'm not sure why.
>> Workaround for people having stale RAID signature on their disk:
>> https://bugzilla.novell.com/show_bug.cgi?id=100530
> 
> Hmm... there's got to be a better way around this.

Won't help existing block devices, but it'd be nice to have a common
library which could be called @ mkfs time to wipe out all known
signatures...

mkfs.xfs tries to do this, but it'd be silly to duplicate in every mkfs.

> On my "one of these days" list is to get another cheap/used laptop so
> I can try out the latest Fedora Core Rawhide without having to fire up
> a huge (noisy) x86_64 box....

Just partition... ;)

-Eric
