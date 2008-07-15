From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: ext4 64bit (disk >16TB) question
Date: Tue, 15 Jul 2008 07:42:01 +0200
Message-ID: <87y743vh3q.fsf@frosties.localdomain>
References: <87bq10w8gv.fsf@frosties.localdomain>
	<20080714234616.GD3382@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:40437 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbYGOFmE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jul 2008 01:42:04 -0400
Received: from smtp05.web.de (fmsmtp05.dlan.cinetic.de [172.20.4.166])
	by fmmailgate02.web.de (Postfix) with ESMTP id 61D8FE5CA41B
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 07:42:02 +0200 (CEST)
Received: from [85.216.73.182] (helo=frosties.localdomain)
	by smtp05.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.109 #226)
	id 1KIdIY-0005og-00
	for linux-ext4@vger.kernel.org; Tue, 15 Jul 2008 07:42:02 +0200
Received: from mrvn by frosties.localdomain with local (Exim 4.69)
	(envelope-from <goswin-v-b@web.de>)
	id 1KIdIX-0007WL-PE
	for linux-ext4@vger.kernel.org; Tue, 15 Jul 2008 07:42:01 +0200
In-Reply-To: <20080714234616.GD3382@mit.edu> (Theodore Tso's message of "Mon,
	14 Jul 2008 19:46:16 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@mit.edu> writes:

> On Mon, Jul 14, 2008 at 09:50:56PM +0200, Goswin von Brederlow wrote:
>> I found ext4 64bit patches for e2fsprogs 1.39 that fix at least
>> mkfs. Does anyone know if there is an updated patch set for 1.41
>> anywhere? And when will that be added to e2fsprogs upstream?
>
> Yes, this is correct.  The 1.39 64-bit patches break the shared
> library ABI, and also there were some long-term problems with having
> super-large bitmaps taking huge amounts of memory without some kind of
> run-length encoding or other compression technique.  I decided to
> reject the 1.39 approach because it would have caused short- and
> long-term maintenance issues.

Is that a problem for the kernel or for the user space? I notices that
mke2fs 1.39 used over a gigabyte memory to format a >16TiB disk. While
being a lot that is not really a problem here.

> At the moment 1.41 does not support > 32 bit block numbers.  The
> priority was to get something which supported all of the other ext4
> features out the door, since that would allow much better testing of
> the ext4 code base.  We are now working on 64-bit support in
> e2fsprogs, with mke2fs coming first, and the other tools coming later.
> But yeah, good quality 64-bit e2fsprogs support is going to lag for a
> bit.  Sorry, we're working as fast as we can, given the resources we
> have.

Will there be filesystem changes as well? The above mentioned
run-length encoding sounds a bit like a new bitmap format or is that
only supposed to be the in memory format in userspace?

What is the plan of how to add 64-bit support to the shared lib now?
Will you introduce a do_foo64() function in parallel to do_foo() to
maintain abi compatibility? Will you add versioned symbols? Or will
there be an abi break at some point?

The reason I ask all this is because I'm willing to spend some time
patching and testing. A single >16TiB filesystem instead of multiple
smaller ones would be a great benefit for us.

> Regards,
>
> 						- Ted

MfG
        Goswin
