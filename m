From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: Zero length files - an alternative approach?
Date: Sun, 29 Mar 2009 13:10:23 +0100
Message-ID: <yw1x1vsg4jio.fsf@thrashbarg.mansr.com>
References: <87bprka9sg.fsf@newton.gmurray.org.uk>
	<yw1xab744lqi.fsf@thrashbarg.mansr.com>
	<49CF636A.3030400@ursus.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agrajag.mansr.com ([78.86.181.102]:58303 "EHLO mail.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbZC2MSc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Mar 2009 08:18:32 -0400
In-Reply-To: <49CF636A.3030400@ursus.ath.cx> (Andreas T. Auer's message of "Sun, 29 Mar 2009 14:02:50 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx> writes:

> On 29.03.2009 13:22 M=E5ns Rullg=E5rd wrote:
>> Consider this scenario:
>>
>> 1. Create/write/close newfile
>> 2. Rename newfile to oldfile
>> 3. Open/read oldfile.  This must return the new contents.
>> 4. System crash and reboot before delayed allocation/flush complete
>> 5. Open/read oldfile.  Old contents now returned.
>>
>> This rollback isn't obviously, to me at least, without problems of i=
ts
>> own.
>>  =20
> Having the old data in 5) is far better than having no data in 5).

Of course having old data is better than no data.  However, fsync()
and similar approaches make a rollback to old data after new data has
been visible impossible or far less likely than the suggested one.
I'm not saying it's necessarily a problem, only that it is a
difference that should be taken into account.

--=20
M=E5ns Rullg=E5rd
mans@mansr.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
