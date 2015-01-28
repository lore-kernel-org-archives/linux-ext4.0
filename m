From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH] mke2fs: Fix German translation of mke2fs
Date: Wed, 28 Jan 2015 13:45:12 +0100
Message-ID: <54C8D9D8.1090200@fastmail.fm>
References: <1422350355-21997-1-git-send-email-jack@suse.cz> <54C78526.9070502@fastmail.fm> <20150127162619.GB29567@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34946 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755213AbbA1UYc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Jan 2015 15:24:32 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id 2331B206DE
	for <linux-ext4@vger.kernel.org>; Wed, 28 Jan 2015 07:45:13 -0500 (EST)
In-Reply-To: <20150127162619.GB29567@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 01/27/2015 05:26 PM, Jan Kara wrote:
> On Tue 27-01-15 13:31:34, Bernd Schubert wrote:
>> On 01/27/2015 10:19 AM, Jan Kara wrote:
>>> When a device mke2fs should work on already contains an ext? filesy=
stem,
>>> mke2fs prints a warning. In German translation the warning doesn't =
end
>>> with a date string (which is terminated by a newline) and thus the
>>> output comes out mangled like:
>>>
>>> mke2fs 1.42.12 (29-Aug-2014)
>>> /dev/disk/by-label/WD20_SL12 hat ein ext3-Dateisystem mit Namen
>>> =E2=80=9EWD20_SL12=E2=80=9C
>>>         zuletzt auf /WD20_SL12 auf Tue Jan 27 09:01:44 2015
>>>  eingeh=C3=A4ngtTrotzdem fortfahren? (j,n)
>>> ^^^^^^^^^^^^^ here
>>>
>>> Fix the translation to end the printed string with a newline and av=
oid
>>> superfluous space at the beginning of the line.
>>>
>>> Signed-off-by: Jan Kara <jack@suse.cz>
>>> ---
>>>  po/de.po | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/po/de.po b/po/de.po
>>> index fd96bb17f712..cf34daf428f2 100644
>>> --- a/po/de.po
>>> +++ b/po/de.po
>>> @@ -5778,9 +5778,11 @@ msgid "Proceed anyway? (y,n) "
>>>  msgstr "Trotzdem fortfahren? (j,n) "
>>> =20
>>>  #: misc/util.c:132
>>> +# The second %s refers to a date string ending with a newline. Mak=
e the
>>> +# translated string end with a newline as well to maintain output =
compatibility.
>>>  #, c-format
>>>  msgid "\tlast mounted on %s on %s"
>>> -msgstr "\tzuletzt auf %s auf %s eingeh=C3=A4ngt"
>>> +msgstr "\tzuletzt auf %s auf %seingeh=C3=A4ngt.\n"
>>
>> I never checked translation before, but if you already change that,
>> could you please change it to "am %s eingeh=C3=A4ngt"? So
>>
>> -msgstr "\tzuletzt auf %s auf %s eingeh=C3=A4ngt"
>> +msgstr "\tzuletzt auf %s am %seingeh=C3=A4ngt.\n"
>   OK, no problem.
>=20
>> Now does the date string always end with a white space, or should th=
at
>> better be
>   ctime() always ends the date string with '\n'. That's why I removed=
 ' '
> from the German format string.

Ah, I see it now in the man page of ctime.

>=20
>> +msgstr "\tzuletzt auf %s am %s eingeh=C3=A4ngt.\n"
>>
>> Also, the date string is in English, shouldn't that be localized eit=
her?
>   I'd expect that output of ctime() is localized (LC_TIME?). If it's =
not,
> I don't think it's a job of e2fsprogs to fix that...

I wonder if ctime is the right function for that. I don't have any
experience with localization, but as far as I can see from the man page
ctime outputs the string in English, according/relative to the local
time zone.
If I see it right strftime might be a better function, although that
would be out of scope for this patch.

>=20
>   New patch attached.

Thank you, if required you could add
Reviewed-by: Bernd Schubert <bernd.schubert@fastmail.fm>

Bernd
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
