From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Wed, 08 Jun 2011 09:41:33 -0500
Message-ID: <4DEF8A1D.2080707@redhat.com>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>	<alpine.LFD.2.00.1106071735100.11385@dhcp-27-109.brq.redhat.com>	<BANLkTikAB-RDDS8PMMrFK-OuY6PuavBixA@mail.gmail.com>	<alpine.LFD.2.00.1106081114240.5026@dhcp-27-109.brq.redhat.com> <BANLkTi=T1OtyRSWNTA6xhkTy5uaHWqA_XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, linux-kernel@vger.kernel.org
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084Ab1FHOlp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jun 2011 10:41:45 -0400
In-Reply-To: <BANLkTi=T1OtyRSWNTA6xhkTy5uaHWqA_XA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/8/11 9:04 AM, Amir G. wrote:
>> And one last note, I also think that the snapshot format change in the
>> > future, when we'll have snpashots with 64bit feature compatible seems
>> > just wrong to me. Adding some features or changing the implementation a
>> > bit is ok, but format change is different. When the code is upstream and
>> > stable it is just wrong.
> What can I say, I understand why it looks bad, but is 64bit code
> upstream and stable? Hell no! e2fsprogs 64bit is not out yet!
> There is no reason to call it 'format change'.
> It's going to be a new format used only for 64bit fs, which are not
> even out there yet. And when they are finally out there, they won't
> have
> snapshots until the new format is implemented.

Well, the on-disk format for 64-bit (48-bit?) ext4 is there & fixed; it's
just that there is no released userspace which can properly handle it, right?

I don't anticipate ext4 format changes for >16T, or am I missing something?

-Eric
