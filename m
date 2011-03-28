From: Oren Elrad <elrad@brandeis.edu>
Subject: Re: [PATCH] mke2fs reserved_ratio default value is nonsensical
Date: Mon, 28 Mar 2011 14:27:09 -0400
Message-ID: <AANLkTinZWJpV1tXvbrmUr740cSf5iyOOo7f=UCRb6ykK@mail.gmail.com>
References: <AANLkTi=7jMS=yq4-72_CvcyGHuWWV6ixEKtk501wnxUz@mail.gmail.com> <4D90CE41.4030209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43859 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab1C1S1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Mar 2011 14:27:50 -0400
Received: by vxi39 with SMTP id 39so2529615vxi.19
        for <linux-ext4@vger.kernel.org>; Mon, 28 Mar 2011 11:27:49 -0700 (PDT)
In-Reply-To: <4D90CE41.4030209@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 28, 2011 at 2:06 PM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
> On 3/28/11 1:02 PM, Oren Elrad wrote:
>> Undesired behavior; mke2fs defaults to reserving 5% of the volume fo=
r
>> the root user. 5% of a 2TB volume is 100GB. The rationale for root
>> reservation (syslogd, etc...) does not require 100GB. As volumes get
>> larger, this default makes less and less sense.
>>
>> Proposal; If the user does not specify their preferred reserve_ratio
>> on the command-line (-m), use the less of 5% or MAX_RSRV_SIZE. I
>> propose 10GiB as a sensible maximum default reservation for root.
>>
>> Patch: Follows and http://capsid.brandeis.edu/~elrad/e2fsprog.gitdif=
f
>>
>> Tested on the latest git+patch, RHEL5 (2.6.18-194.17.1.el5) with a
>> 12TB volume (which would reserve 600GB under the default!):
>
> There's been a bit of debate about this; is the space really saved
> for root, or is it to stop the allocator from going off the rails
> when the fs nears capacity? =A0Both, really.
>
> I don't really have a horse in the race, but the complaint has certai=
nly
> come up before... it's just important to realize that the space isn't
> only there for root's eventual use.
>
> No other fs that I know of enforces this "don't fill the fs to capaci=
ty"
> common sense programatically, though.
>
> -Eric
>

[SNIP]

Well, in my version you still get some reservation to prevent whatever
woes (fragmentation, allocator slow-down) that accompany a nearly-full
disk. If you think 25 or 50GiB is a more appropriate maximum default,
I have no objections.

Whatever the reason for reservation, more than 100GB is totally
nonsensical IMHO.

Oren Elrad
Dept. of Physics
Brandeis University
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
