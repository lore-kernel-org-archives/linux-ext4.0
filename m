From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH RFC 07/13] charsets: utf8: Hook-up utf-8 code to charsets library
Date: Tue, 23 Jan 2018 01:33:06 -0200
Message-ID: <87bmhl8d1p.fsf@collabora.co.uk>
References: <20180112071234.29470-1-krisman@collabora.co.uk>
        <20180112071234.29470-8-krisman@collabora.co.uk>
        <DF4PR8401MB0812A452CD9D28F218A731D685170@DF4PR8401MB0812.NAMPRD84.PROD.OUTLOOK.COM>
        <874lnlzr1i.fsf@collabora.co.uk>
        <DF4PR8401MB0812536DFB46D5F762D5D75585EA0@DF4PR8401MB0812.NAMPRD84.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "tytso\@mit.edu" <tytso@mit.edu>,
        "david\@fromorbit.com" <david@fromorbit.com>,
        "linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "kernel\@lists.collabora.co.uk" <kernel@lists.collabora.co.uk>,
        "alvaro.soliverez\@collabora.co.uk"
        <alvaro.soliverez@collabora.co.uk>
To: "Weber\, Olaf \(HPC Data Management & Storage\)" <olaf.weber@hpe.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <DF4PR8401MB0812536DFB46D5F762D5D75585EA0@DF4PR8401MB0812.NAMPRD84.PROD.OUTLOOK.COM>
        (Olaf Weber's message of "Tue, 16 Jan 2018 22:19:24 +0000")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

"Weber, Olaf (HPC Data Management & Storage)" <olaf.weber@hpe.com>
writes:


>> One question that I have, on the other hand: Take the version you
>> shared, I want to avoid the -EINVAL for the case when strings s1
>> and s2 should match as equal, but strlen(s1) < strlen (s2).  In this
>> case:
>> 
>> strncmp (s1, s2, strlen (s2)) => Returns 0.  Matches Ok
>> strncmp (s1, s2, strlen (s1)) => Returns -EINVAL
>> 
>> I know -EINVAL doesn't mean they don't match, but this case seems too
>> error prone.
>
> If I understand your question correctly, the case of interest is
>
> 	strncmp(s1, s2, len), where len <= strlen(s1) and len <= strlen(s2)
>
> As far as I can tell the code I sketched above handles that case in the
> way you expect/want, when taking the complications introduced by
> Unicode into account. Using utf8ncursor() ensures we do get an -EINVAL
> if, and only if, we read beyond the end (len) of the source string as part of
> the normalization process. But if we are at an acceptable boundary in the
> source string when we see the end of the string, utf8byte() returns 0,
> indicating a normal/non-error end of the scan.

Hey Olaf,

Sorry for the delay.

It is not quite that scenario.  The version that requires only 1 length
fails when utf8ncursor receives a len that is smaller than one of the
strings, which is a common case when something decomposes to a larger
string:

Take this case, for instance:

s1 = {0xc2, 0xbc, 0x00},   /* 'VULGAR FRACTION ONE QUARTER' decomposes to */
s2 = {0x31, 0xe2, 0x81, 0x84, 0x34, 0x00},  /* 'NUMBER 1' + 'FRACTION SLASH' + 'NUMBER 4' */

If we do strncmp(s1, s2, strlen(s2)), it works fine.  But if we use
strlen(s1) on the third parameter, it fails.  As far as I understand,
the issue happens because utf8lookup will read to the maximum of len
characters, aborting the lookup in the middle of a sequence. Since we
don't hit a leaf for that code-point, it assumes an invalid sequence and
utf8byte aborts.

The easiest way to solve it is by receiving the two lens in strncmp.

> I think it may be worth to write some tests to (hopefully) confirm that
> the code really does what I intended it to do. The most likely case to
> fail would be where you hit the len-imposed end after a codepoint
> with CCC != 0.

The only test I had for this scenario happened to have strlen(s1) ==
strlen(s2).  I added the following, which I think catches this scenario:

/* 'LATIN SMALL LETTER A WITH DIAERESIS' + 'COMBINING OGONEK'  decomposes to */
/* 'LETTER A' + 'COMBINING  OGONEK' + 'COMBINING DIAERESIS' */
  s1 = {0xc3, 0xa4, 0xCC, 0xA8, 0x00},
  s2 = {0x61, 0xCC, 0xA8, 0xcc, 0x88, 0x00},

I tested your version, and it works correctly for this scenario too, as
long as we set the len parameter to use the largest string, s2, instead
of s1.

>> I suppose we just could:
>> 
>>  (1) let the caller deal with it, which is error prone.  Or,
>
> The caller does have to do something when it gets -EINVAL. You have to
> define the desired semantics of that case.
>
> In the original XFS-filesystem code my choice was to treat invalid UTF-8
> sequences as binary blobs for the sake of comparisons.
>
>>  (2) Require two lens on strncmp, one for each string, Or,
>
> As a general rule this is certainly correct: each string has its
> own associated maximum length within which it should have
> been null-terminated.  So whether you need one len per
> string depends on the sources of the strings. In the original
> XFS-based code there are some tricks related to this.

I've applied this solution and it is solving every test case correctly,
including those I mentioned above.  Since it looks like the best
approach, I applied the other things you commented, and modified the
comparison functions code to receive 2 lens.  I should submit a v2
shortly, once I'm done with dealing with some changes to the fs part.

Thanks!

-- 
Gabriel Krisman Bertazi
