From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: 2.6.33.1: ext4 disk free weirdness
Date: Mon, 29 Mar 2010 10:43:09 -0700
Message-ID: <150c16851003291043l2fa17795o3b8339b2e04514ba@mail.gmail.com>
References: <20100329045748.GR2657@zip.com.au> <4BB0BDD2.3080100@redhat.com>
	 <20100329145311.GA4671@thunk.org> <4BB0C0D2.1080303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36718 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab0C2RnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Mar 2010 13:43:10 -0400
Received: by gwaa18 with SMTP id a18so4173562gwa.19
        for <linux-ext4@vger.kernel.org>; Mon, 29 Mar 2010 10:43:10 -0700 (PDT)
In-Reply-To: <4BB0C0D2.1080303@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 29, 2010 at 8:01 AM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
> tytso@mit.edu wrote:
>> On Mon, Mar 29, 2010 at 09:48:50AM -0500, Eric Sandeen wrote:
>>> CaT wrote:
>>>> Using kernel 2.6.33.1. Am rsyncing from /data/mirror (a raid0 moun=
t) to
>>>> /dev/sda1 (a usb HD). Both filesystems formatted as ext3 but mount=
ed as
>>>> ext4. /mnt filesystem is only being added to and currently large f=
iles
>>>> (iso files 700MB-4.4GB) are being copied. When I remounted /mnt as=
 ext3
>>>> I could not duplicate the issue and the amount of disk used stabil=
ised
>>>> at 182G. The df results, whilst /mnt is mounted as ext4, are below=
:
>>> I would say this is likely speculative allocation due to delalloc
>>> (ext4 has to reserve worst-case metadata amounts to prepare for
>>> delalloc writeback). =A0When the file data actually gets written ou=
t,
>>> the worst-case reservation is freed up again. =A0We also flush and
>>> switch to nodelalloc when the filesystem is pretty close to full.
>>> see ext4_nonda_switch() for example.
>>>
>>> This looks pretty severe though, more than I would expect
>>> from that behavior.
>>
>> This is fixed in commit d330a5bef, which which got merged post
>> 2.6.34-rc2, and which we need to get into 2.6.33 stable. =A0If you
>> cherry-pick that commit, I think you'll see that it fixes this
>> problem.
>
> Oh, right, spaced that one. =A0Thanks for the reminder Ted. =A0:)
>
> And from now on ext3-mounted-as-ext4 is special-cased so you won't ge=
t
> delalloc, and you won't get this behavior at all (nor will you get
> any delalloc benefits, FWIW).
>

Out of curiosity, when you say ext3-mounted-as-ext4, are you referring
to filesystems without ext4 features mounted -t ext4, or filesystems
mounted -t ext3 when CONFIG_EXT4_USE_FOR_EXT23 is defined?

-Justin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
