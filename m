From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available [ver #2]
Date: Wed, 30 Jun 2010 11:31:37 +0200
Message-ID: <201006301131.37241.arnd@arndb.de>
References: <201006301030.52235.arnd@arndb.de> <20100630011712.18960.3723.stgit@warthog.procyon.org.uk> <25470.1277888151@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: viro@zeniv.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
	mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
	sjayaraman@suse.de, linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <25470.1277888151@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wednesday 30 June 2010 10:55:51 David Howells wrote:
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > I think it would be better to leave the structure as write-only from
> > the kernel
> 
> Why?

Consistency mostly. stat and stat64 don't read it, so I think xstat
also shouldn't if we can easily avoid it.

It also makes things like strace more complicated.

> > and pass the query_flags and struct_version as syscall arguments, though it
> > makes sense to store them in the result as well.
> 
> The problem with that is that the number of syscall arguments is limited, and
> there is no SYSCALL_DEFINE7.
> 
> On the other hand, I could make a separate argument block struct and pass a
> pointer to it...

No, I think that would be worse than the current version. But if you remove
the structure version in favor of the flags, you only need six arguments
anyway.

You can also go further and fold the structure length into flags, because
the length is just a function of the data you are passing.

Having a system call with flags, size and version is like wearing a belt,
braces and suspenders. An unsigned long flags argument should be enough to
hold up your pants[1].

	Arnd

[1] I hope I managed to make this sound wrong in both American and proper
English.
