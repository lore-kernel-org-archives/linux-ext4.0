From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/3] Extended file stat functions
Date: Tue, 29 Jun 2010 22:28:12 +0100
Message-ID: <24882.1277846892@redhat.com>
References: <201006292324.32765.bernd.schubert@fastmail.fm> <201006292307.42440.bernd.schubert@fastmail.fm> <20100629200259.23196.81509.stgit@warthog.procyon.org.uk> <24517.1277845879@redhat.com>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, smfrench@gmail.com,
	jlayton@redhat.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201006292324.32765.bernd.schubert@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Bernd Schubert <bernd.schubert@fastmail.fm> wrote:

> Ah, great, so already there :) I was looking for st_gen, as it is called
> that way on BSD. And as BSD already has it for a long time, shouldn't linux
> use the BSD identifier?

Sure.  I guess you'd also want it to be a u64?

David
