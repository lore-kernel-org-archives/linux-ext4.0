From: =?UTF-8?B?8J+RviBXYWRl?= <wadetregaskis@google.com>
Subject: Re: Patch adding e2p_feature_to_string
Date: Wed, 17 Dec 2014 16:03:45 -0800
Message-ID: <CAC80aeigBG9vdbG-RY9wV7vezd6uw+XcdnFQ81A7Bkq3pdSWxw@mail.gmail.com>
References: <CAC80aehVQyWfkd6X339n2bhkDU574hTMWEKXcxzeJrwP4K8E+A@mail.gmail.com>
	<7EB7C92E-036C-4460-A132-344C06F83336@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:40447 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaLRADr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Dec 2014 19:03:47 -0500
Received: by mail-vc0-f176.google.com with SMTP id hq12so39881vcb.35
        for <linux-ext4@vger.kernel.org>; Wed, 17 Dec 2014 16:03:46 -0800 (PST)
In-Reply-To: <7EB7C92E-036C-4460-A132-344C06F83336@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> What's wrong with a pointer to a static string?  Since the strings are
>
> static, none of the callers can change them.  Since they are just pointers,
> they can be shared by any number of callers.

The existing code doesn't always return a static string - sometimes it
sprintfs one up...

> > +const char *e2p_feature2string(int compat, unsigned int mask)
> > +{
> > +       static char buf[20];
> > +       e2p_feature_to_string(compat, mask, buf, sizeof(buf) / sizeof(buf[0]));
>
> This is copying into a single shared buffer for all callers, which is
> not thread safe.

... exactly.
