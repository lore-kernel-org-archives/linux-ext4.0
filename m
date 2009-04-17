From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] blkid: add --disable-libblkid (v2)
Date: Fri, 17 Apr 2009 15:36:45 +0200
Message-ID: <ac3eb2510904170636u15992e6axfba3e672f37aba4@mail.gmail.com>
References: <20090224084434.GF6020@nb.net.home> <20090324121147.GA22386@zelda.netsplit.com>
	<20090416102241.GA3290@nb.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Scott James Remnant <scott@ubuntu.com>
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:57987 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbZDQNhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Apr 2009 09:37:01 -0400
Received: by fg-out-1718.google.com with SMTP id 16so99104fgg.17
        for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2009 06:37:00 -0700 (PDT)
In-Reply-To: <20090416102241.GA3290@nb.net.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 16, 2009 at 12:22, Karel Zak <kzak@redhat.com> wrote:
> On Tue, Mar 24, 2009 at 12:11:47PM +0000, Scott James Remnant wrote:
>> Karel Zak wrote:
>>
>> > I found some bugs in my previous patches. Please, use the patch
>> > below. This patch includes all necessary changes. Sorry.
>> >
>> When putting together an Ubuntu package with this patch, I found tha=
t it
>> ends up putting the pkg-config output into the make dependency varia=
bles
>> and thus fails because it can't make the "-L/lib" target.
>>
>> The attached patch fixes that, and includes your previous patch.
>
> =C2=A0Ted, ping ping ping... :-) Please, we need your feedback.

Ted? Please make sure we get this in.

You will save people not using Fedora, SUSE, Ubuntu, finding out why
recent tools they try to build/install will stop working for them,
when they don't have these patches. We are going to introduce hard
dependencies on the the new libblkid from util-linux-ng for a bunch of
upstream projects.

Thanks,
Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
