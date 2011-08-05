From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH] ext4: make quota as first class supported feature
Date: Fri, 5 Aug 2011 10:32:25 -0700
Message-ID: <CAGr1F2HoEU+L8HziGZ46xXqzC7ibeeq4Yak_LM6zAXB=XD31wA@mail.gmail.com>
References: <1311187218-30798-1-git-send-email-adityakali@google.com>
 <20110801140034.GC21388@thunk.org> <20110801164457.GE21388@thunk.org> <CAGr1F2F5Je=LFVm0Z9N3+ThstvEf5XiWPYMqjemri6F5aHossQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:12438 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1HERcr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Aug 2011 13:32:47 -0400
Received: from wpaz9.hot.corp.google.com (wpaz9.hot.corp.google.com [172.24.198.73])
	by smtp-out.google.com with ESMTP id p75HWk85014652
	for <linux-ext4@vger.kernel.org>; Fri, 5 Aug 2011 10:32:46 -0700
Received: from pzk36 (pzk36.prod.google.com [10.243.19.164])
	by wpaz9.hot.corp.google.com with ESMTP id p75HWXwX030204
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Fri, 5 Aug 2011 10:32:45 -0700
Received: by pzk36 with SMTP id 36so3880309pzk.3
        for <linux-ext4@vger.kernel.org>; Fri, 05 Aug 2011 10:32:45 -0700 (PDT)
In-Reply-To: <CAGr1F2F5Je=LFVm0Z9N3+ThstvEf5XiWPYMqjemri6F5aHossQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Yes. As I had mentioned in my comment earlier, this would change the
current quota behavior (old quota tools wont work). I will make a
backward compatible patch and resend this. Sorry for the trouble.

Thanks,
--
Aditya


On Fri, Aug 5, 2011 at 10:27 AM, Aditya Kali <adityakali@google.com> wr=
ote:
>
> Yes. As I had mentioned in my comment earlier, this would change the =
current quota behavior (old quota tools wont work). I will make a=C2=A0=
backward=C2=A0compatible patch and resend this.
>
> --
> Aditya
>
>
> On Mon, Aug 1, 2011 at 9:44 AM, Ted Ts'o <tytso@mit.edu> wrote:
>>
>> On Mon, Aug 01, 2011 at 10:00:34AM -0400, Ted Ts'o wrote:
>> > On Wed, Jul 20, 2011 at 11:40:18AM -0700, Aditya Kali wrote:
>> > > This patch is an attempt towards supporting quotas as first clas=
s
>> > > feature in ext4. It is based on the proposal at:
>> > > https://ext4.wiki.kernel.org/index.php/Design_For_1st_Class_Quot=
a_in_Ext4
>> > > ...
>> > >
>> > > Signed-off-by: Aditya Kali <adityakali@google.com>
>> >
>> > Thanks, added to the ext4 tree.
>>
>> Hmm, this caused a bunch of quota test failures that shouldn't be
>> happening....
>>
>> Ran: 001 002 005 006 007 011 013 014 053 069 070 074 075 076 077 088=
 089 100 105 112 113 123 124 125 126 127 128 129 130 131 132 133 135 14=
1 169 184 193 198 204 207 208 209 210 211 212 213 214 215 219 221 223 2=
24 225 226 228 230 231 232 233 234 235 236 237 239 240 243
>> Failures: 219 230 231 232 233 235
>>
>> It looks like the backwards compatibility with traditional quota
>> setups isn't quite working correctly:
>>
>> 230 21s ... - output mismatch (see 230.out.bad)
>>
>> --- 230.out 2011-07-21 19:27:10.000000000 -0400
>> +++ 230.out.bad =C2=A0 =C2=A0 =C2=A0 =C2=A02011-08-01 10:46:59.47096=
4400 -0400
>> @@ -7,14 +7,10 @@
>> =C2=A0Write 900k...
>> =C2=A0Rewrite 1001k...
>> =C2=A0Write 1000k...
>> -pwrite64: Disk quota exceeded
>> =C2=A0Write 4096...
>> -pwrite64: Disk quota exceeded
>> =C2=A0Touch 3+4
>> =C2=A0Touch 5+6
>> -touch: cannot touch `SCRATCH_MNT/file6': Disk quota exceeded
>> =C2=A0Touch 5
>> -touch: cannot touch `SCRATCH_MNT/file5': Disk quota exceeded
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0...
>>
>> I may end up putting this off until the next merge window, unless we
>> can fix this quickly.
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-=
 Ted
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
