From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent cache
Date: Fri, 13 Apr 2012 10:42:10 -0700
Message-ID: <CA+55aFx8UsBEqK2KA_7D4YNGYrtcNaduvuEUcLfbRRjSXS_Xeg@mail.gmail.com>
References: <20120323221715.GA6712@tassilo.jf.intel.com> <A3DE1F37-C0AB-4ACE-8D13-22DC8A21ED3C@dilger.ca>
 <20120324031357.GA5690@tassilo.jf.intel.com> <CAMQXfUcH-0Krg811msFVbC25qY1mPTdrMi8Rg-qJST=6B-s_5w@mail.gmail.com>
 <4F70F51F.8030405@linux.intel.com> <20120326235707.GC19489@thunk.org> <m2zkaiyzjl.fsf@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Ted Ts'o" <tytso@mit.edu>, Vivek Haldar <haldar@google.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	tim.c.chen@linux.intel.com
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61168 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab2DMRmc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Apr 2012 13:42:32 -0400
Received: by wgbdr13 with SMTP id dr13so3270265wgb.1
        for <linux-ext4@vger.kernel.org>; Fri, 13 Apr 2012 10:42:31 -0700 (PDT)
In-Reply-To: <m2zkaiyzjl.fsf@firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 11, 2012 at 9:59 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Ping. This scalability problem is still in 3.4-rc* and causes
> major slowdowns.

Do you have numbers?

> Can we please revert fix it or revert
> 556b27abf73833923d5cd4be80006292e1b31662 before release.

That commit ID doesn't make any sense, and doesn't seem to have
anything to do with any statistics counters that your email talks
about. So regardless, you'd need to explain why that commit causes the
problems you talk about, I'm not going to revert a random commit that
doesn't even look what you describe.

Ted?

                Linus
