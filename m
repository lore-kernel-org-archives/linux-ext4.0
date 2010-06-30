From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available [ver #2]
Date: Wed, 30 Jun 2010 09:55:51 +0100
Message-ID: <25470.1277888151@redhat.com>
References: <201006301030.52235.arnd@arndb.de> <20100630011656.18960.4255.stgit@warthog.procyon.org.uk> <20100630011712.18960.3723.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, smfrench@gmail.com,
	jlayton@redhat.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab0F3I4P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jun 2010 04:56:15 -0400
In-Reply-To: <201006301030.52235.arnd@arndb.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:

> I think it would be better to leave the structure as write-only from
> the kernel

Why?

> and pass the query_flags and struct_version as syscall arguments, though it
> makes sense to store them in the result as well.

The problem with that is that the number of syscall arguments is limited, and
there is no SYSCALL_DEFINE7.

On the other hand, I could make a separate argument block struct and pass a
pointer to it...

David
