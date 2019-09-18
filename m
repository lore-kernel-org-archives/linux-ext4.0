Return-Path: <SRS0=iZ5A=XN=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFBE6C4CEC4
	for <linux-ext4@archiver.kernel.org>; Wed, 18 Sep 2019 19:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3EF2222D2
	for <linux-ext4@archiver.kernel.org>; Wed, 18 Sep 2019 19:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388962AbfIRT4e convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 18 Sep 2019 15:56:34 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34184 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388954AbfIRT4d (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Sep 2019 15:56:33 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1iAg3t-0002w3-EA; Wed, 18 Sep 2019 13:56:25 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1iAg3r-0004Pl-25; Wed, 18 Sep 2019 13:56:25 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Lennart Poettering <mzxreary@0pointer.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        zhangjs <zachary@baishancloud.com>, linux-ext4@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
References: <CAHk-=wgs65hez6ctK7J2k46BdQzvKU5avExPOTTJsZu6iqA-ow@mail.gmail.com>
        <C4F7DC65-50B9-4D70-8E9B-0A6FF5C1070A@srcf.ucam.org>
        <20190917052438.GA26923@1wt.eu> <2508489.jOnZlRuxVn@merkaba>
        <20190917121156.GC6762@mit.edu>
        <20190917123015.sirlkvy335crozmj@debian-stretch-darwi.lab.linutronix.de>
        <20190917160844.GC31567@gardel-login>
        <CAHk-=wgsWTCZ=LPHi7BXzFCoWbyp3Ey-zZbaKzWixO91Ryr9=A@mail.gmail.com>
        <20190917174219.GD31798@gardel-login>
Date:   Wed, 18 Sep 2019 14:56:00 -0500
In-Reply-To: <20190917174219.GD31798@gardel-login> (Lennart Poettering's
        message of "Tue, 17 Sep 2019 19:42:19 +0200")
Message-ID: <87zhj15qgf.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1iAg3r-0004Pl-25;;;mid=<87zhj15qgf.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+wHfph00kxbMVDYzFA0Q6fsNypo8aTwNk=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: Linux 5.3-rc8
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Lennart Poettering <mzxreary@0pointer.de> writes:

> On Di, 17.09.19 09:23, Linus Torvalds (torvalds@linux-foundation.org) wrote:
>
>> On Tue, Sep 17, 2019 at 9:08 AM Lennart Poettering <mzxreary@0pointer.de> wrote:
>> >
>> > Here's what I'd propose:
>>
>> So I think this is ok, but I have another proposal. Before I post that
>> one, though, I just wanted to point out:
>>
>> > 1) Add GRND_INSECURE to get those users of getrandom() who do not need
>> >    high quality entropy off its use (systemd has uses for this, for
>> >    seeding hash tables for example), thus reducing the places where
>> >    things might block.
>>
>> I really think that trhe logic should be the other way around.
>>
>> The getrandom() users that don't need high quality entropy are the
>> ones that don't really think about this, and so _they_ shouldn't be
>> the ones that have to explicitly state anything. To those users,
>> "random is random". By definition they don't much care, and quite
>> possibly they don't even know what "entropy" really means in that
>> context.
>
> So I think people nowadays prefer getrandom() over /dev/urandom
> primarily because of the noisy logging the kernel does when you use
> the latter on a non-initialized pool. If that'd be dropped then I am
> pretty sure that the porting from /dev/urandom to getrandom() you see
> in various projects (such as gdm/x11) would probably not take place.
>
> In fact, speaking for systemd: the noisy logging in the kernel is the
> primary (actually: only) reason that we prefer using RDRAND (if
> available) over /dev/urandom if we need "medium quality" random
> numbers, for example to seed hash tables and such. If the log message
> wasn't there we wouldn't be tempted to bother with RDRAND and would
> just use /dev/urandom like we used to for that.
>
>> > 2) Add a kernel log message if a getrandom(0) client hung for 15s or
>> >    more, explaining the situation briefly, but not otherwise changing
>> >    behaviour.
>>
>> The problem is that when you have some graphical boot, you'll not even
>> see the kernel messages ;(
>
> Well, but as mentioned, there's infrastructure for this, that's why I
> suggested changing systemd-random-seed.service.
>
> We can make boot hang in "sane", discoverable way.
>
> The reason why I think this should also be logged by the kernel since
> people use netconsole and pstore and whatnot and they should see this
> there. If systemd with its infrastructure brings this to screen via
> plymouth then this wouldn't help people who debug much more low-level.
>
> (I mean, there have been requests to add a logic to systemd that
> refuses booting — or delays it — if the system has a battery and it is
> nearly empty. I am pretty sure adding a cleanm discoverable concept of
> "uh, i can't boot for a good reason which is this" wouldn't be the
> worst of ideas)

As I understand it the deep problem is that sometimes we have not
observed enough random activity early in boot.

The cheap solution appears to be copying a random seed from a previous
boot, and I think that will take care of many many cases, and has
already been implemented.  Which reduces this to a system first
boot issue.

So for first system boot can we take some special actions to make
it possible to see randomness sooner.  An unconditional filesystem check
of the filesystem perhaps.  Something that will initiate disk activity
or other hardware activity that will generate interrupts and allow
us to capture randomness.

For many systems we could even have the installer capture some random
data as a final stage of the installation, and use that to seed
randomness on the first boot.

Somewhere in installing the random seed we need to be careful about
people just copying disk images from one system to another, and a
replicated seed probably can not be considered very random.

My sense is that by copying a random seed from one boot to the next
and by initiating system activity to hurry along the process of
having enough randomness we can have systems where we can almost
always have good random numbers available.

And if we almost always have good random numbers available we won't
have to worry about people getting this wrong.

Am I wrong or can we just solve random number availablity is practically
all cases?

Eric
