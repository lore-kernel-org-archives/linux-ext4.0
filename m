From: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH 0/3] Extended file stat functions
Date: Tue, 29 Jun 2010 23:59:57 +0100 (BST)
Message-ID: <alpine.LFD.2.00.1006292356360.13070@eddie.linux-mips.org>
References: <201006292324.32765.bernd.schubert@fastmail.fm> <201006292307.42440.bernd.schubert@fastmail.fm> <20100629200259.23196.81509.stgit@warthog.procyon.org.uk> <24517.1277845879@redhat.com> <24882.1277846892@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>,
	viro@zeniv.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
	mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
	sjayaraman@suse.de, linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Received: from localhost.localdomain ([127.0.0.1]:51824 "EHLO
        localhost.localdomain" rhost-flags-OK-OK-OK-OK)
        by eddie.linux-mips.org with ESMTP id S1492321Ab0F2W75 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org> + 3 others);
        Wed, 30 Jun 2010 00:59:57 +0200
In-Reply-To: <24882.1277846892@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 29 Jun 2010, David Howells wrote:

> > Ah, great, so already there :) I was looking for st_gen, as it is called
> > that way on BSD. And as BSD already has it for a long time, shouldn't linux
> > use the BSD identifier?
> 
> Sure.  I guess you'd also want it to be a u64?

 Note the Alpha port has had an st_gen member reserved in its struct stat 
for many years now ;) -- which could have been DEC OSF/1 legacy.  I'm glad 
to see this member seriously considered after these many years and 
previously rejected proposals.

  Maciej
