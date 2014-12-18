From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Patch adding e2p_feature_to_string
Date: Thu, 18 Dec 2014 14:58:38 -0700
Message-ID: <7F6D52D2-77D3-4F64-A1CB-DC43E3CD72D4@dilger.ca>
References: <CAC80aehVQyWfkd6X339n2bhkDU574hTMWEKXcxzeJrwP4K8E+A@mail.gmail.com> <7EB7C92E-036C-4460-A132-344C06F83336@dilger.ca> <CAC80aeigBG9vdbG-RY9wV7vezd6uw+XcdnFQ81A7Bkq3pdSWxw@mail.gmail.com> <40442828-1968-444E-AA4E-F0A1D28EC057@dilger.ca> <CAC80aejg3USDDeaVQ-F72aWoAk1daqdpTRCOiOac=GjVsqj6Pg@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?Q?=F0=9F=91=BE_Wade?= <wadetregaskis@google.com>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:42118 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaLRV6l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Dec 2014 16:58:41 -0500
Received: by mail-pd0-f176.google.com with SMTP id r10so2241505pdi.21
        for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2014 13:58:40 -0800 (PST)
In-Reply-To: <CAC80aejg3USDDeaVQ-F72aWoAk1daqdpTRCOiOac=GjVsqj6Pg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 18, 2014, at 11:23 AM, Wade <wadetregaskis@google.com> wrote:
>> I see that now.  That said, your version now does this for _every_ caller
>> of e2p_feature2string(), while the original code only did it in the rare
>> case of an unsupported feature bit set on on a filesystem.  I don't see
>> that as an improvement over the original.
> 
> I do - the existing code is causing data corruption in my use.



That you are hitting this problem is interesting in itself, since it
means either that your superblock is corrupt, or you are using some
filesystem features that e2fsprogs doesn't understand, since that is
the only case that a shared buffer is used.  It would make sense in
the latter case to patch lib/e2p/feature.c to add in a proper name
for your feature.

It is really a bad idea to be using a feature bit that isn't at least
_registered_ in e2fsprogs, even if the full support isn't there, since
you run a real risk of someone else using that feature bit for some
completely different feature, and mass problems may result (e.g. e2fsck
incorrectly thinking it understands the feature when it doesn't).

Ted has definitely accepted reservations of feature flags in the past
for features under development or not in the mainline kernel.

> I'm unsure why the string copy is problematic - this doesn't seem to
> be performance-sensitive code.  As far as I could find, all uses of
> this function in the e2fsprogs codebase are just printfing the result,
> in human-readable format.  Or for debugging.  ?

Sorry to not be clear earlier - my objection was that your patch is
making the common use cases (i.e. when only known features are used)
for e2p_feature2string() become non-thread safe and more likely to
hit corruption.  It wasn't about the string copy, nor am I against
fixing this code to be thread safe.  While the uses of this function
in e2fsprogs are all single-threaded, there is clearly external code
that is using this function (yours is proof positive of this), and
we don't want to break those while fixing your uncommon use.

>> One option, maybe not very pretty but not fatally ugly, is to just
>> initialize all of the "unknown" features as static strings.  That ends
>> up being 23 extra "FEATURE_Cnn" strings, 21 extra "FEATURE_Rnn" strings,
>> and 17 extra "FEATURE_Inn" strings.
>> 
>> That ends up being less than 1KB of static text, which isn't bad at all.
>> 
>> This could potentially speed up e2p_feature2string(), since it could
>> index directly into three different arrays instead of having to scan all
>> of them to find the right f_compat type first.  I'm not sure if it really
>> makes a noticeable difference in the end though.
> 
> I can do either, if you insist.  What would you prefer:
> 
> a) Statically defining the various FEATURE_foo strings, as you describe.
> b) Duplicating the implementation of the two functions so that
> e2p_feature2string() can retain its prior behaviour of returning a
> string constant in the common cases.

The (b) case could also extract the common code into helpers like:

static const char *known_feature2string(int compat, unsigned int mask)
{
	struct feature  *f;

	for (f = feature_list; f->string; f++) {
		if (compat == f->compat && mask == f->mask)
			return f->string;
	}

	return NULL;
}

and

static char *unknown_feature2string(int compat, unsigned int mask,
				    char *buf, int buf_len)
{
	char fchar;
	int fnum;

	switch (compat) {
	case E2P_FEATURE_COMPAT:
		fchar = 'C';
		break;
	case E2P_FEATURE_INCOMPAT:
		fchar = 'I';
		break;
        case E2P_FEATURE_RO_INCOMPAT:
		fchar = 'R';
		break;
        default:
		fchar = '?';
		break;
	}

	for (fnum = 0; mask >>= 1; fnum++);
	snprintf(buf, buf_len, "FEATURE_%c%d", fchar, fnum);

	return buf;
}

and these are used by both e2p_feature2string() (using a static buffer
for unknown_feature2string()) and e2p_feature_string_copy() (using the
caller supplied buffer), which avoids almost all of the code duplication.

It is worthwhile to have Ted weigh in on his preference for this.

> Or alternatively, I suppose:
> 
> c) Use a thread-local internal buffer to return the results, so it's
> at least thread-safe (though still not really safe, since multiple
> calls on one line - e.g. as printf arguments - could still evaluate to
> incorrect results).

Probably more complexity than needed, and doesn't really solve the problem.

Cheers, Andreas





