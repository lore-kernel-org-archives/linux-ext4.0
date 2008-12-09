From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Getting direct support for fallocate(2) into glibc
Date: Tue, 09 Dec 2008 12:03:55 -0600
Message-ID: <493EB30B.8090300@redhat.com>
References: <E1L9wQt-0003dz-DE@closure.thunk.org> <493EA3AB.2080308@redhat.com> <20081209173128.GA19214@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35639 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbYLISET (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Dec 2008 13:04:19 -0500
In-Reply-To: <20081209173128.GA19214@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, Dec 09, 2008 at 10:58:19AM -0600, Eric Sandeen wrote:
>> ... oh, ok, but plain old fallocate() isn't yet hooked up, odd.
>>
>> # gcc -o test-fallocate test-fallocate.c
>> /tmp/ccQTk6an.o: In function `main':
>> test-fallocate.c:(.text+0x3e): undefined reference to `fallocate'
>>
>> Especially odd because we have a man page shipping, but no actual
>> implemented interface  :)  OK, I'll go bug people.
> 
> Yep, that was what I was referring to.  We have the fallocate(2) man
> page because Michael Kerrisk has documented the userspace/kernel
> interface.  But that doesn't necessarily mean that glibc has wired up
> the interface.  (Sigh, we had been able to push this issue *before*
> glibc 2.9 shipped last month, but we were all too busy....)

Ok.  yeah, I honestly didn't realize that the bare interface wasn't
there.  :(

-Eric
