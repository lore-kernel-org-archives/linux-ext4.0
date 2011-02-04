From: Matt <jackdachef@gmail.com>
Subject: Re: ext4: Fix data corruption with multi-block writepages support
Date: Fri, 4 Feb 2011 22:40:47 +0000
Message-ID: <AANLkTi=gcf=A_6Kp6h7s2+OkxR4YUb6gqzc43asn-wfK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37495 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1BDWkt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Feb 2011 17:40:49 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>Thanks, added to the ext4 patch queue.

>I modified the commit description slightly to give credit to Jon
>Nelson, who reported the bug and really helped by devising a
>reproduceable test case.  Many thanks, Jon!!

>							- Ted

So that means that the file-corruption which existed until 2.6.37-rc6
and got triggered (for me) more easily via "dm crypt: scale to
multiple CPUs"
is fixed now ?

That should give ext4 a nice speedup for >=2.6.38 :)

Could you also please add an ?

Reported-by: Matthias Bayer <jackdachef <at> gmail <dot> com >

I mainly found it through testing with the mentioned dm-crypt scaling
patch and >=2.6.36-git*

Thanks & Regards !

Matt
