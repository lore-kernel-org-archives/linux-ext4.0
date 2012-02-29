From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: mkfs.ext4 vs. e2fsck discard oddities
Date: Wed, 29 Feb 2012 10:01:53 -0600
Message-ID: <4F4E4BF1.1060503@redhat.com>
References: <4F4D1020.5060204@redhat.com> <alpine.LFD.2.00.1202290801510.4926@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758083Ab2B2QBz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Feb 2012 11:01:55 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q1TG1tWg008863
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 29 Feb 2012 11:01:55 -0500
In-Reply-To: <alpine.LFD.2.00.1202290801510.4926@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/29/12 1:12 AM, Lukas Czerner wrote:
> On Tue, 28 Feb 2012, Eric Sandeen wrote:
> 
>> I've been testing Lukas' last 2 patches for e2fsck discard, and noticed something a little odd.
>>
>> If I make a 512M file, loopback mount it, and mkfs.ext4 it with discard, it uses about 17M at that point.
>> If I then run fsstress on it with a known seed, then run e2fsck -E discard on it, it uses about 52M.
>>
>> If I repeat the above test telling mkfs.ext4 NOT to discard, I'm left with about 94M after the discarding e2fsck.
>>
>> So it seems that perhaps e2fsck is not discarding everything that it could; after a discarding fsck, we should be left with the same (minimal) nr. of blocks "in use" no?
> 
> The reason is (as I commented in the patch #2) that we will not discard
> BLOCK_UNINIT groups. We use BLOCK_UNINIT as a optimization measure to
> skip groups which are likely to be non-provisioned, because we have
> never written there anything since the mkfs.
> 
> If you create file system without discard, then obviously nothing is
> discarded, image is fully provisioned and e2fsck discard *only* initialized
> groups. So you'll end up with the bigger image, in case that your image was
> not sparse.
> 
> I hope that makes sense.

It does, sorry, I had been focusing too much on patch #1 ;)

-Eric

> Actually I want to make the same optimization for fitrim. We discussed
> it with Ted and Phillip (see the discussion under [RESEND] [PATCH 2/2
> v2] e2fsck: Do not forget to discard last block group. They did seem to
> be convinced by that, however I think it is right thing to do for the
> reasons I gave in that thread.
> 
> Thanks!
> -Lukas
> 
>>
>> I guess that's better than discarding _more_ than it should though.  ;)
>>
>> (I suppose it is possible that this is the underlying filesytem being selective about which discards it accepts, but it behaves the same way on ext4 and xfs backing filesystems)
>>
>> -Eric
>>
>> FWIW, sequence of events here, tested with and without "-K" on mkfs.ext4:
>>
>> dd if=/dev/zero of=fsfile bs=1M count=512
>> losetup /dev/loop0 fsfile
>> mkfs.ext4 -F /dev/loop0&>/dev/null
>> mount /dev/loop0 mnt/
>> /root/git/xfstests/ltp/fsstress -s 1 -d mnt/ -n 2000 -p 4
>> umount mnt/
>> e2fsck/e2fsck.static -fy -E discard /dev/loop0> fsck1.out || exit
>> du -hc fsfile
>> losetup -d /dev/loop0
>>
>>
> 

