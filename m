From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH 0/3] Extended file stat functions
Date: Tue, 29 Jun 2010 23:53:02 +0200
Message-ID: <201006292353.02990.bernd.schubert@fastmail.fm>
References: <201006292324.32765.bernd.schubert@fastmail.fm> <24517.1277845879@redhat.com> <24882.1277846892@redhat.com>
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46507 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755842Ab0F2VxF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jun 2010 17:53:05 -0400
In-Reply-To: <24882.1277846892@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday, June 29, 2010, David Howells wrote:
> Bernd Schubert <bernd.schubert@fastmail.fm> wrote:
> > Ah, great, so already there :) I was looking for st_gen, as it is called
> > that way on BSD. And as BSD already has it for a long time, shouldn't
> > linux use the BSD identifier?
> 
> Sure.  I guess you'd also want it to be a u64?

Hmm, as far as I can see, BSD has u32. I only need it to verify for recycled 
inodes and at least for me the probability of a recyled inode + 32 bit 
generation number that overflew to exactly the same value as the previous 
inode had would be sufficiently small.


Thanks a lot for your work on this,
Bernd
