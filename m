From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Sat, 25 Dec 2010 11:41:46 +0100
Message-ID: <AANLkTi=TWjKMfLG0nGGjxvGR87PwNm5NkKYPnsFsLgfZ@mail.gmail.com>
References: <1292710543.17128.14.camel@nayuki>
	<AANLkTimbkstru_nUxnd7R8Zg=ioB3skTntedq_dLxpZm@mail.gmail.com>
	<AANLkTi=BW85d6VpGAt0KaGES+4dRQmsvRyFamE=ChEXE@mail.gmail.com>
	<20101224085126.2a7ff187@notabene.brown>
	<20101223222206.GD12763@thunk.org>
	<4D13E98D.8070105@ontolinux.com>
	<20101224004825.GF12763@thunk.org>
	<4D13F09D.4010703@ontolinux.com>
	<20101224095105.GG12763@thunk.org>
	<AANLkTimPZ_Hq2Ye4mc60WKTWZNU4Zz3yZaPzfARYa6jh@mail.gmail.com>
	<20101225031529.GA2595@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55823 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab0LYKls (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Dec 2010 05:41:48 -0500
In-Reply-To: <20101225031529.GA2595@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 25, 2010 at 4:15 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Dec 24, 2010 at 12:14:21PM +0100, Olaf van der Spek wrote:
>>
>> Thanks for taking the time to answer. The thread was started due to
>> the dpkg issue.
>
> I've talked to the dpkg folks and I believe they are squared away; for
> their use case sync_file_range() combined with fsync() should solve
> their reliability and performance problem.

It's not just about dpkg, I'm still very interested in answers to my
original questions.

Olaf
