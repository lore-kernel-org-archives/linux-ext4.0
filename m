From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 4/5] ext4: flush journal when switching from journal data mode
Date: Fri, 30 Dec 2011 22:43:53 +0800
Message-ID: <CAGBYx2aeRMZqXop5v6kjb06_DHMOn=sUCYQkZUTYdh=ffiJ4ng@mail.gmail.com>
References: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
	<1321344474-14707-4-git-send-email-xiaoqiangnk@gmail.com>
	<20111228185643.GD12370@thunk.org>
	<20111229210153.GN8233@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:52625 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751701Ab1L3Ony convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Dec 2011 09:43:54 -0500
Received: by obcwo16 with SMTP id wo16so10197829obc.19
        for <linux-ext4@vger.kernel.org>; Fri, 30 Dec 2011 06:43:53 -0800 (PST)
In-Reply-To: <20111229210153.GN8233@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 30, 2011 at 5:01 AM, Darrick J. Wong <djwong@us.ibm.com> wr=
ote:
> On Wed, Dec 28, 2011 at 01:56:43PM -0500, Ted Ts'o wrote:
>> On Tue, Nov 15, 2011 at 04:07:53PM +0800, Yongqiang Yang wrote:
>> > When switching from journal data mode, the data blocks
>> > in journal will have no revoke record. =A0Thus, data could be
>> > corrupted during replay. =A0However, there is no such problem in
>> > switching to journal data mode. =A0So we flush journal only in
>> > the case that swithes from journal data mode.
>> >
>> > Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>>
>> Applied, with a slightly different (and more explanatory commit
>> message):
>>
>> ext4: flush journal when switching from data=3Djournal mode
>>
>> From: Yongqiang Yang <xiaoqiangnk@gmail.com>
>>
>> It's necessary to flush the journal when switching away from
>> data=3Djournal mode. =A0This is because there are no revoke records =
when
>> we are data blocks are journalled,
>
> Minor nit, but did you mean "when data blocks are journalled" ?
Yes!  chattr +j can change journal mode of a file to data mode.

Yongqiang.
>
> --D
>> which are required in the other journal modes.
>>
>> However, it is not necessary to flush the journal when switching int=
o
>> data=3Djournal mode, and flushing the journal is expensive. =A0So le=
t's
>> avoid it in that case.
>>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 - Ted
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
