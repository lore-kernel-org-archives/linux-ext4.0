From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available
Date: Wed, 30 Jun 2010 09:59:41 +0100
Message-ID: <25553.1277888381@redhat.com>
References: <201006301020.53978.arnd@arndb.de> <20100629200259.23196.81509.stgit@warthog.procyon.org.uk> <20100629200315.23196.68742.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, smfrench@gmail.com,
	jlayton@redhat.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <201006301020.53978.arnd@arndb.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> Do we actually need the fxstat variant? IIRC, some *at syscalls just
> operate on dfd when filename==NULL, which would be trivial to do here.

user_path_at() doesn't seem to work like that, so fstatat() doesn't.  It's a
possibility though.

David
