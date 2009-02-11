From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Filesystem still has errors
Date: Wed, 11 Feb 2009 16:36:15 -0600
Message-ID: <499352DF.3090701@redhat.com>
References: <loom.20090211T220951-175@post.gmane.org> <49934EC8.7040800@redhat.com> <loom.20090211T222920-494@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Raimund Andersen <anderse@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49523 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121AbZBKWgV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Feb 2009 17:36:21 -0500
In-Reply-To: <loom.20090211T222920-494@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Raimund Andersen wrote:
> Eric Sandeen <sandeen <at> redhat.com> writes:
> 
>> You should expect that checking a live filesystem will produce errors,
>> actually.  So don't worry about that.  The filesystem is not quiesced,
>> and it's not consistent.  That is to be expected, and it's why you see
>> the different behavior w/ forcefsck vs. e2fsck -n on the live fs.
>>
>> As for the spurious ENOSPC, I'm not certain.  Do you still get the error?
> 
> Thanks for your quick reply. No, at the moment, I don't get it. Yesterday, it
> occured once and a reboot let it vanish, and I got it some days before. Also
> then, a reboot let it disappear. So could it be of help if I collect any
> information in the case it might reappear? What exactly should I do then?

If you can, I'd test a 2.6.29-rc4 kernel, see if the very latest code is
behaving any better...

-Eric

> Thank you, once again.
> 
> rgds Raimund

