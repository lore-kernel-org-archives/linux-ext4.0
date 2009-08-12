From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: >16TB issues
Date: Tue, 11 Aug 2009 22:35:56 -0700
Message-ID: <150c16850908112235o10970aefqa16f2e08490d74e7@mail.gmail.com>
References: <150c16850907021523p25ddae32v2eeea54418d2e6d5@mail.gmail.com>
	 <4A824364.20709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:28545 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbZHLFfz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Aug 2009 01:35:55 -0400
Received: by wa-out-1112.google.com with SMTP id j5so1046839wah.21
        for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2009 22:35:56 -0700 (PDT)
In-Reply-To: <4A824364.20709@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 11, 2009 at 9:21 PM, Eric Sandeen<sandeen@redhat.com> wrote=
:
>> - =A0Immediately running e2fsck on the volume before ever mounting i=
t
>> will not complete, and results in the following:
>> # e2fsck -n /dev/md2
>> e2fsck 1.41.7 (29-June-2009)
>> Error reading block 2435874816 (Attempt to read block from filesyste=
m
>> resulted in short read). =A0Ignore error? no
>
> This is roughly halfway through the filesystem; the journal is roughl=
y
> in the middle of the filesystem; this is just over 2^31 blocks. =A0I =
bet
> there are still ints or longs in the userspace journal code. =A0I'll =
take
> a look.

Thanks for looking into this.  That log message is from when I was
running a 32-bit kernel, and I was apparently running into page cache
index limitations.  That error went away when I switched to a x86_64
kernel, but there are still other errors, as posted in one of my more
recent messages.

-Justin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
