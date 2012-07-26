From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: Re: one question about xfstests for ext4?
Date: Thu, 26 Jul 2012 19:48:21 +0800
Message-ID: <50112E85.7090006@gmail.com>
References: <5010AB10.9050701@gmail.com> <alpine.LFD.2.00.1207260951200.27130@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58889 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2GZLsm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Jul 2012 07:48:42 -0400
Received: by ghrr11 with SMTP id r11so1839621ghr.19
        for <linux-ext4@vger.kernel.org>; Thu, 26 Jul 2012 04:48:41 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1207260951200.27130@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012=E5=B9=B407=E6=9C=8826=E6=97=A5 16:01, Luk=C3=A1=C5=A1 Czerner w=
rote:
> On Thu, 26 Jul 2012, Wang Sheng-Hui wrote:
>=20
>> Date: Thu, 26 Jul 2012 10:27:28 +0800
>> From: Wang Sheng-Hui <shhuiw@gmail.com>
>> To: Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Ts'o <tytso@=
mit.edu>,
>>     ext4 development <linux-ext4@vger.kernel.org>
>> Subject: one question about xfstests for ext4?
>>
>> Dear all,
>>
>> I want to run xfstests on ext4.=20
>> I have tried the official xfstests git tree, but in my test, I got m=
any=20
>> 	"[not run] not suitable for this filesystem type: ext4".
>> -------------------------------------------------------------
>> 001	 6s
>> 002	 0s
>> 003	 [not run] not suitable for this filesystem type: ext4
>> 004	 [not run] not suitable for this filesystem type: ext4
>> 005	 0s
>> 006	 2s
>> 007	 3s
>> 008	 [not run] not suitable for this filesystem type: ext4
>> 009	 [not run] not suitable for this filesystem type: ext4
>> 010	 [not run] dbtest was not built for this platform
>> 011	 2s
>> 012	 [not run] not suitable for this filesystem type: ext4
>> ......
>>
>>
>> Is this expected? Or do I need to make some config changes?
>> I wonder if there is any xfstests for ex4 specific git tree?
>=20
> Hi,
>=20
> it actually is called XFStests for a reason :). Well historically it
> started off as a xfs test suite, but over time it got more and more
> generic tests and support for other file system. There are still lot
> of tests which are file system specific and if you look at the test
> itself, you'll see what it actually does.
>=20
> There might be some tests which maybe could be changed to generic
> tests, or more file systems can be supported. That said, if you find
> a test which you think would make sense for other file systems as
> well, then please by all means feel free to send a patch.
>=20
> So to answer your question, there is nothing wrong with your setup
> and there is no ext4 specific xfstests tree, we all share the same
> xfstests tree. Some tests simply makes sense only for some file
> systems, since they are supposed to be focused on certain
> functionality.
>=20
> Hope it helps
>=20

Got it. Thanks a lot, Lukas !

Regards,
Sheng-Hui

> Regards,
> -Lukas
>=20
>>
>> Regards,
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
