From: =?UTF-8?B?8J+RviBXYWRl?= <wadetregaskis@google.com>
Subject: Re: Patch adding e2p_feature_to_string
Date: Thu, 18 Dec 2014 10:23:15 -0800
Message-ID: <CAC80aejg3USDDeaVQ-F72aWoAk1daqdpTRCOiOac=GjVsqj6Pg@mail.gmail.com>
References: <CAC80aehVQyWfkd6X339n2bhkDU574hTMWEKXcxzeJrwP4K8E+A@mail.gmail.com>
	<7EB7C92E-036C-4460-A132-344C06F83336@dilger.ca>
	<CAC80aeigBG9vdbG-RY9wV7vezd6uw+XcdnFQ81A7Bkq3pdSWxw@mail.gmail.com>
	<40442828-1968-444E-AA4E-F0A1D28EC057@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f181.google.com ([209.85.220.181]:55069 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaLRSXQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Dec 2014 13:23:16 -0500
Received: by mail-vc0-f181.google.com with SMTP id le20so505901vcb.26
        for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2014 10:23:15 -0800 (PST)
In-Reply-To: <40442828-1968-444E-AA4E-F0A1D28EC057@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I see that now.  That said, your version now does this for _every_ caller
> of e2p_feature2string(), while the original code only did it in the rare
> case of an unsupported feature bit set on on a filesystem.  I don't see
> that as an improvement over the original.

I do - the existing code is causing data corruption in my use.

I'm unsure why the string copy is problematic - this doesn't seem to
be performance-sensitive code.  As far as I could find, all uses of
this function in the e2fsprogs codebase are just printfing the result,
in human-readable format.  Or for debugging.  ?

> One option, maybe not very pretty but not fatally ugly, is to just
> initialize all of the "unknown" features as static strings.  That ends
> up being 23 extra "FEATURE_Cnn" strings, 21 extra "FEATURE_Rnn" strings,
> and 17 extra "FEATURE_Inn" strings.
>
> That ends up being less than 1KB of static text, which isn't bad at all.
>
> This could potentially speed up e2p_feature2string(), since it could
> index directly into three different arrays instead of having to scan all
> of them to find the right f_compat type first.  I'm not sure if it really
> makes a noticeable difference in the end though.

I can do either, if you insist.  What would you prefer:

a) Statically defining the various FEATURE_foo strings, as you describe.
b) Duplicating the implementation of the two functions so that
e2p_feature2string() can retain its prior behaviour of returning a
string constant in the common cases.

Or alternatively, I suppose:

c) Use a thread-local internal buffer to return the results, so it's
at least thread-safe (though still not really safe, since multiple
calls on one line - e.g. as printf arguments - could still evaluate to
incorrect results).
