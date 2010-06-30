From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available [ver #2]
Date: Wed, 30 Jun 2010 13:14:10 +0100
Message-ID: <26650.1277900050@redhat.com>
References: <201006301346.41902.arnd@arndb.de> <201006301131.37241.arnd@arndb.de> <25470.1277888151@redhat.com> <29346.1277892068@redhat.com>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, smfrench@gmail.com,
	jlayton@redhat.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181Ab0F3MOX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jun 2010 08:14:23 -0400
In-Reply-To: <201006301346.41902.arnd@arndb.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:

> Given a 64 bit flag word, you can start using bits for the version from
> the top and bits from the bottom for fields:

I suppose.  It's cleaner, though, to keep them separate.

> Alternatively, you can also make it a 64 bit argument everywhere, which has
> some other small disadvantages.

No, you can't.  32-bit systems can only pass 32-bit arguments.  If you're
suggesting passing a pointer to a 64-bit argument instead, how's that any
different from my suggestion of a separate parameter block?

> The idea of a syscall API with multiple fixed-length and variable-length
> fields in the same structure scares me. If you want to go this far,
> it may be better to base the interface on netlink and allow querying
> multiple files at once.

Urgh.  Netlink is way too much overhead and even scarier.  That's pretty much
a guarantee that people won't use it.  It also has to work if CONFIG_NET=n.

David
