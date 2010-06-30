From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available [ver #2]
Date: Wed, 30 Jun 2010 11:01:08 +0100
Message-ID: <29346.1277892068@redhat.com>
References: <201006301131.37241.arnd@arndb.de> <201006301030.52235.arnd@arndb.de> <20100630011712.18960.3723.stgit@warthog.procyon.org.uk> <25470.1277888151@redhat.com>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, smfrench@gmail.com,
	jlayton@redhat.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab0F3KBd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jun 2010 06:01:33 -0400
In-Reply-To: <201006301131.37241.arnd@arndb.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:

> It also makes things like strace more complicated.

That's the most compelling argument.

> No, I think that would be worse than the current version. But if you remove
> the structure version in favor of the flags, you only need six arguments
> anyway.

I want to keep the structure version, just in case we need to expand fields in
the stat struct in future.  Otherwise we may need to create yet another stat
syscall.

> You can also go further and fold the structure length into flags, because
> the length is just a function of the data you are passing.

The potential problem with passing the flags as a syscall argument is that
we're then limited to a single 32-bit integer.  It might be enough, but if I
do as at least one person has suggested and assign each field in the struct
its own bit, that uses up half right there, plus I'd like to add at least one
operational flag (to force synchronisation with the server).

> Having a system call with flags, size and version is like wearing a belt,
> braces and suspenders. An unsigned long flags argument should be enough to
> hold up your pants[1].

I would like the size argument for two reasons: firstly, to prevent buffer
overruns and, secondly, because I can see some scope for variable-size fields
(such as for volume IDs or security labels), though the latter might be better
handled through getxattr() (which would mean extra overhead).

David
