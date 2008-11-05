From: Cryptooctoploid <cryptooctoploid@gmail.com>
Subject: Re: data corruption with ext4 (from 2.6.27.4) exposed by rtorrent
Date: Wed, 5 Nov 2008 21:13:30 +0100
Message-ID: <319012f0811051213g1f2ed31blf2b4bede3dd9535@mail.gmail.com>
References: <3d3ce57e0811030442o377cf2bet212eefba79d714bb@mail.gmail.com>
	 <20081103134008.GE29102@mit.edu>
	 <319012f0811050534i27b7dce1t8120b3a343844adc@mail.gmail.com>
	 <20081105172553.GA29880@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Roc Valles" <vallesroc@gmail.com>, linux-ext4@vger.kernel.org
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:23367 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbYKEUNa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 15:13:30 -0500
Received: by wf-out-1314.google.com with SMTP id 27so187412wfd.4
        for <linux-ext4@vger.kernel.org>; Wed, 05 Nov 2008 12:13:30 -0800 (PST)
In-Reply-To: <20081105172553.GA29880@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 5, 2008 at 6:25 PM, Theodore Tso <tytso@mit.edu> wrote:
> Cryptooctoploid,
>
> Based on some reflection and further discussion on #ext4, I have a
> theory which we need to try to prove/disprove that it may be related
> to memory pressure combined with the delayed allocation code.
>
> If you've already dismantled your ext4 setup, maybe you can't test
> this, but it would be interesting to know mounting with the -o
> nodelalloc makes the problem go away.

Yes, -o nodelalloc resolves the issue here.

>Also, how much memory do you
> have in your system and is your system often under memory pressure?
> (i.e., your system often uses swap, and where the amount of free
> memory is often near the low water mark where it is trying to evict
> memory either by dropping clean pages or writing dirty pages back to
> the filesystem and/or swap).

I have 2GB of memory and my machine is not under any kind of
memory pressure normally.
