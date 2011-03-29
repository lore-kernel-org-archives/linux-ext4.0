From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: breaking ext4 to test recovery
Date: Tue, 29 Mar 2011 17:33:11 -0500
Message-ID: <4D925E27.6010309@redhat.com>
References: <25B374CC0D9DFB4698BB331F82CD0CF20D61B8@wdscexbe08.sc.wdc.com> <4D91E39A.3000800@redhat.com> <20110329143305.GA6057@bitwizard.nl> <AANLkTinJ4-PPTi0q76fThmq9a_qe1PadVueObPtRLruY@mail.gmail.com> <25B374CC0D9DFB4698BB331F82CD0CF20D61BC@wdscexbe08.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Daniel Taylor <Daniel.Taylor@wdc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab1C2WdN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Mar 2011 18:33:13 -0400
In-Reply-To: <25B374CC0D9DFB4698BB331F82CD0CF20D61BC@wdscexbe08.sc.wdc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/29/11 5:26 PM, Daniel Taylor wrote:
> Thanks for the suggestions.  Tao Ma's got me started, but doing some
> of the more "devious" tests is on my list, too.
> 
> The original issue was that during component stress testing, we were
> seeing instances of the ext4 file system becoming "read-only" (showing
> in /proc/mounts, but not "mount").  Looking back through the logs, we
> saw that at mount time, there was a complaint about a corrupted journal.

So, did it go "read-only" right at mount time due to a journal replay
failure? Or ...

> Some writing had occurred before the change to read-only, however.

That makes it sound like it did get mounted ok... and then something
went wrong?  What did the logs say?
 
> The original mount script didn't check for any "mount" return value, so
> we theorized that ext4 just got to a point where it couldn't sensibly
> handle any more changes.

I'm not sure what that means, TBH :)

Just want to make sure you're barking up the right tree, here ...

-Eric

> It seemed that the right answer was to check the return value from mount
> and, if non-0, umount the file system, fix it, and try again.  To test
> the return value from mount, I need to be able to corrupt, but not
> destroy the journal, since the component tests were taking days to show
> the failure.
> 
> Running an "fsck -f" every time on a 3TB file system with an embedded
> PPC was just taking too much time to impose on a consumer-level customer.

