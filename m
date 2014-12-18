From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Patch adding e2p_feature_to_string
Date: Wed, 17 Dec 2014 22:24:07 -0700
Message-ID: <40442828-1968-444E-AA4E-F0A1D28EC057@dilger.ca>
References: <CAC80aehVQyWfkd6X339n2bhkDU574hTMWEKXcxzeJrwP4K8E+A@mail.gmail.com> <7EB7C92E-036C-4460-A132-344C06F83336@dilger.ca> <CAC80aeigBG9vdbG-RY9wV7vezd6uw+XcdnFQ81A7Bkq3pdSWxw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?Q?=F0=9F=91=BE_Wade?= <wadetregaskis@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:47032 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaLRFYK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Dec 2014 00:24:10 -0500
Received: by mail-pa0-f52.google.com with SMTP id eu11so657664pac.11
        for <linux-ext4@vger.kernel.org>; Wed, 17 Dec 2014 21:24:09 -0800 (PST)
In-Reply-To: <CAC80aeigBG9vdbG-RY9wV7vezd6uw+XcdnFQ81A7Bkq3pdSWxw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 17, 2014, at 5:03 PM, Wade <wadetregaskis@google.com> wrote:
> 
>> What's wrong with a pointer to a static string?  Since the strings are
>> 
>> static, none of the callers can change them.  Since they are just pointers, they can be shared by any number of callers.
> 
> The existing code doesn't always return a static string - sometimes it
> sprintfs one up...

I see that now.  That said, your version now does this for _every_ caller
of e2p_feature2string(), while the original code only did it in the rare
case of an unsupported feature bit set on on a filesystem.  I don't see
that as an improvement over the original.

One option, maybe not very pretty but not fatally ugly, is to just
initialize all of the "unknown" features as static strings.  That ends
up being 23 extra "FEATURE_Cnn" strings, 21 extra "FEATURE_Rnn" strings,
and 17 extra "FEATURE_Inn" strings.

That ends up being less than 1KB of static text, which isn't bad at all.

This could potentially speed up e2p_feature2string(), since it could
index directly into three different arrays instead of having to scan all
of them to find the right f_compat type first.  I'm not sure if it really
makes a noticeable difference in the end though.

>>> +const char *e2p_feature2string(int compat, unsigned int mask)
>>> +{
>>> +       static char buf[20];
>>> +       e2p_feature_to_string(compat, mask, buf, sizeof(buf) / sizeof(buf[0]));
>> 
>> This is copying into a single shared buffer for all callers, which is
>> not thread safe.
> 
> ... exactly.

So I'm not against your version, but not at the expense of making the
existing code worse.

Cheers, Andreas





