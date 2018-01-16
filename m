From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH RFC 07/13] charsets: utf8: Hook-up utf-8 code to charsets library
Date: Tue, 16 Jan 2018 14:50:33 -0200
Message-ID: <874lnlzr1i.fsf@collabora.co.uk>
References: <20180112071234.29470-1-krisman@collabora.co.uk>
        <20180112071234.29470-8-krisman@collabora.co.uk>
        <DF4PR8401MB0812A452CD9D28F218A731D685170@DF4PR8401MB0812.NAMPRD84.PROD.OUTLOOK.COM>
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
In-Reply-To: <DF4PR8401MB0812A452CD9D28F218A731D685170@DF4PR8401MB0812.NAMPRD84.PROD.OUTLOOK.COM>
        (Olaf Weber's message of "Fri, 12 Jan 2018 10:38:25 +0000")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

"Weber, Olaf (HPC Data Management & Storage)" <olaf.weber@hpe.com>
writes:

> But this is not the only problem. The 'len' limit applies to the input strings. So you need to tell
> the utf8byte() routine that it applies. In other words, use utf8ncursor() which takes an additional
> length parameter to set up the cursors.
>
> With this change, utf8byte() will return 0 when it hits the end of the input string due to seeing a
> null byte or having consumed all characters, provided that it is not in the middle of a utf8 sequence
> or a an incomplete sequence of Unicode characters.
>
> Finally, note that utf8byte() returns an int, not a char. It does this for the same reasons getc() does.
>
> So utf8_strncmp() becomes something like the following. I'm using EINVAL instead of EIO, and note
> that -EINVAL does not imply that str1 and str2 are not equal when compared as a sequence of bytes.
>
> static int utf8_strncmp(const struct charset *charset,
> 			const char *str1,
> 			const char *str2,
> 			int len)
> {
> 	const struct utf8data *data = utf8nfkdi(charset->version);
> 	struct utf8cursor cur1;
> 	struct utf8cursor cur2;
> 	int c1;
> 	int c2;
>
> 	if (utf8ncursor(&cur1, data, str1, len) < 0)
> 		return -EINVAL;
> 	if (utf8ncursor(&cur2, data, str2, len) < 0)
> 		return -EINVAL;
>
> 	do {
> 		c1 = utf8byte(&cur1);
> 		c2 = utf8byte(&cur2);
>
> 		if (c1 < 0 || c2 < 0)
> 			return -EINVAL;
> 		if (c1 != c2)
> 			return 1;
> 	} while (c1);
>
> 	return 0;
> }

Hi Olaf,

Thanks for your review and deep explanations.

I get your point and I've added a test case to trigger it in the
test_ucd module.

One question that I have, on the other hand: Take the version you
shared, I want to avoid the -EINVAL for the case when strings s1
and s2 should match as equal, but strlen(s1) < strlen (s2).  In this
case:

strncmp (s1, s2, strlen (s2)) => Returns 0.  Matches Ok
strncmp (s1, s2, strlen (s1)) => Returns -EINVAL

I know -EINVAL doesn't mean they don't match, but this case seems too
error prone.

I suppose we just could:

 (1) let the caller deal with it, which is error prone.  Or,

 (2) Require two lens on strncmp, one for each string, Or,

 (3) use utf8cursor for the second string, which plays bad with non-null
 terminated strings, which is important for filesystems.

Do you see an alternative? I'm pending towards option 2.  Are you ok
with that?

-- 
Gabriel Krisman Bertazi
