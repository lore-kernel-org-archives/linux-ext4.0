From: "Weber, Olaf (HPC Data Management & Storage)" <olaf.weber@hpe.com>
Subject: RE: [PATCH RFC 07/13] charsets: utf8: Hook-up utf-8 code to charsets
 library
Date: Tue, 16 Jan 2018 22:19:24 +0000
Message-ID: <DF4PR8401MB0812536DFB46D5F762D5D75585EA0@DF4PR8401MB0812.NAMPRD84.PROD.OUTLOOK.COM>
References: <20180112071234.29470-1-krisman@collabora.co.uk>
        <20180112071234.29470-8-krisman@collabora.co.uk>
        <DF4PR8401MB0812A452CD9D28F218A731D685170@DF4PR8401MB0812.NAMPRD84.PROD.OUTLOOK.COM>
 <874lnlzr1i.fsf@collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "kernel@lists.collabora.co.uk" <kernel@lists.collabora.co.uk>,
        "alvaro.soliverez@collabora.co.uk" <alvaro.soliverez@collabora.co.uk>
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g2t2354.austin.hpe.com ([15.233.44.27]:18492 "EHLO
        g2t2354.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbeAPWTn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Jan 2018 17:19:43 -0500
In-Reply-To: <874lnlzr1i.fsf@collabora.co.uk>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Gabriel,

Comments inline

> -----Original Message-----
> From: Gabriel Krisman Bertazi [mailto:krisman@collabora.co.uk]
> Sent: Tuesday, January 16, 2018 17:51
> To: Weber, Olaf (HPC Data Management & Storage) <olaf.weber@hpe.com>
> Cc: tytso@mit.edu; david@fromorbit.com; linux-ext4@vger.kernel.org;
> linux-fsdevel@vger.kernel.org; kernel@lists.collabora.co.uk;
> alvaro.soliverez@collabora.co.uk
> Subject: Re: [PATCH RFC 07/13] charsets: utf8: Hook-up utf-8 code to
> charsets library
> 
> "Weber, Olaf (HPC Data Management & Storage)" <olaf.weber@hpe.com> writes:
> 
> > But this is not the only problem. The 'len' limit applies to the input strings. So you need to tell
> > the utf8byte() routine that it applies. In other words, use utf8ncursor() which takes an additional
> > length parameter to set up the cursors.
> >
> > With this change, utf8byte() will return 0 when it hits the end of the input string due to seeing a
> > null byte or having consumed all characters, provided that it is not in the middle of a utf8 sequence
> > or a an incomplete sequence of Unicode characters.
> >
> > Finally, note that utf8byte() returns an int, not a char. It does this for the same reasons getc() does.
> >
> > So utf8_strncmp() becomes something like the following. I'm using EINVAL instead of EIO, and note
> > that -EINVAL does not imply that str1 and str2 are not equal when compared as a sequence of bytes.
> >
> > static int utf8_strncmp(const struct charset *charset,
> > 			const char *str1,
> > 			const char *str2,
> > 			int len)
> > {
> > 	const struct utf8data *data = utf8nfkdi(charset->version);
> > 	struct utf8cursor cur1;
> > 	struct utf8cursor cur2;
> > 	int c1;
> > 	int c2;
> >
> > 	if (utf8ncursor(&cur1, data, str1, len) < 0)
> > 		return -EINVAL;
> > 	if (utf8ncursor(&cur2, data, str2, len) < 0)
> > 		return -EINVAL;
> >
> > 	do {
> > 		c1 = utf8byte(&cur1);
> > 		c2 = utf8byte(&cur2);
> >
> > 		if (c1 < 0 || c2 < 0)
> > 			return -EINVAL;
> > 		if (c1 != c2)
> > 			return 1;
> > 	} while (c1);
> >
> > 	return 0;
> > }
> 
> Hi Olaf,
> 
> Thanks for your review and deep explanations.
> 
> I get your point and I've added a test case to trigger it in the
> test_ucd module.
> 
> One question that I have, on the other hand: Take the version you
> shared, I want to avoid the -EINVAL for the case when strings s1
> and s2 should match as equal, but strlen(s1) < strlen (s2).  In this
> case:
> 
> strncmp (s1, s2, strlen (s2)) => Returns 0.  Matches Ok
> strncmp (s1, s2, strlen (s1)) => Returns -EINVAL
> 
> I know -EINVAL doesn't mean they don't match, but this case seems too
> error prone.

If I understand your question correctly, the case of interest is

	strncmp(s1, s2, len), where len <= strlen(s1) and len <= strlen(s2)

As far as I can tell the code I sketched above handles that case in the
way you expect/want, when taking the complications introduced by
Unicode into account. Using utf8ncursor() ensures we do get an -EINVAL
if, and only if, we read beyond the end (len) of the source string as part of
the normalization process. But if we are at an acceptable boundary in the
source string when we see the end of the string, utf8byte() returns 0,
indicating a normal/non-error end of the scan.

I think it may be worth to write some tests to (hopefully) confirm that
the code really does what I intended it to do. The most likely case to
fail would be where you hit the len-imposed end after a codepoint
with CCC != 0.

> I suppose we just could:
> 
>  (1) let the caller deal with it, which is error prone.  Or,

The caller does have to do something when it gets -EINVAL. You have to
define the desired semantics of that case.

In the original XFS-filesystem code my choice was to treat invalid UTF-8
sequences as binary blobs for the sake of comparisons.

>  (2) Require two lens on strncmp, one for each string, Or,

As a general rule this is certainly correct: each string has its
own associated maximum length within which it should have
been null-terminated.  So whether you need one len per
string depends on the sources of the strings. In the original
XFS-based code there are some tricks related to this.

>  (3) use utf8cursor for the second string, which plays bad with non-null
>  terminated strings, which is important for filesystems.

I agree, if the string is not null-terminated, then utf8ncursor() is the only
Viable interface.

> Do you see an alternative? I'm pending towards option 2.  Are you ok
> with that?

I'd say the proposed XFS code did a variant of your option 2. It also used
the available interfaces in a way that attempted to avoid memory
allocation unless absolutely necessary.

At the time I worked under the assumptions that both allocating
memory and normalizing a string were expensive, but also that I
could not permanently or even semi-permanently store normalized
forms of directory entries.

So the XFS code as written made a copy of the normalized form of the entry
being worked on, but gets the normalized bytes of the on-disk directory
entries on the fly.

This also drove the design of utf8(n)cursor()/utf8byte(): I wanted to
avoid having to do memory management as much as possible, and also
needed to work with a limited (and fixed-size) stack footprint. Basically
these interfaces were written the way they are to make that (micro-)
optimization possible. Within those constraints I tried to make them
easy to use. I may not have succeeded.

Olaf
