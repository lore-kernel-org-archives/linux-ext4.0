Return-Path: <SRS0=8lV0=QP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE883C169C4
	for <linux-ext4@archiver.kernel.org>; Fri,  8 Feb 2019 19:10:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EAE02083B
	for <linux-ext4@archiver.kernel.org>; Fri,  8 Feb 2019 19:10:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="JZGFoQhe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfBHTKM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 8 Feb 2019 14:10:12 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40014 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726852AbfBHTKM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Feb 2019 14:10:12 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 3E3418EE2FF;
        Fri,  8 Feb 2019 11:10:11 -0800 (PST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XA0A-owRV2hu; Fri,  8 Feb 2019 11:10:11 -0800 (PST)
Received: from host186.65.213.217 (unknown [65.213.217.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 0BF108EE0BF;
        Fri,  8 Feb 2019 11:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1549653010;
        bh=uLzudsj4YHBucBtNYGrMyVjcz9OyfJKmKZANTao8uhU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JZGFoQhe0NfbF/XQVNp18RwovB2Mb1JMx6IzD4KNnejBPth4fTg9u473yX1ziVT+/
         lJ6QuP4kF5aLKLzSpcnu5eimQlLRivlw+1JXQB0I/Xq6o/OtlsAIIjFmEnKyyfAHif
         P9WokOGKwUc3JTFT1TJIPxp1jV0Vx4pFjcuYLV40=
Message-ID: <1549653008.3647.8.camel@HansenPartnership.com>
Subject: Re: Proposal: Yet another possible fs-verity interface
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Mimi Zohar <zohar@linux.ibm.com>
Date:   Fri, 08 Feb 2019 14:10:08 -0500
In-Reply-To: <20190207031101.GA7387@mit.edu>
References: <20190207031101.GA7387@mit.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, 2019-02-06 at 22:11 -0500, Theodore Y. Ts'o wrote:
> After doing a lot of thinking and conferring with the other fs-verity
> developers, our current thinking is to simply move the Merkle tree
> creation into the kernel.  The upside of doing this is it completely
> bypasses all of the complaints about how to transfer the Merkle tree
> from userspace to the kernel.  It avoids the complexities of
> redesigning the xattr interface, or creating a magic fd which could
> be lseek'ed, mmap'ed, read, written, etc. to transfer the Merkle
> tree, etc.  Calculating the Merkle tree from a code complexity is
> going to be simpler.

I'm happy with this but, as I asked before when something like this was
proposed: can this now become part of IMA?  We simply write an IMA hash
or signature which is a possibly signed top of merkle tree hash (we'll
need a new IMA hash format for this).  The act of writing the xattr
triggers the merkle tree build, how (or indeed whether) the kernel
caches the tree is a fs dependent detail and if the fs can't cache it,
the tree would be reconstructed on first use after a reboot.

> The downside of this approach is that it can take a lot of CPU time
> in the kernel (it would have to do be done in a kernel thread).  An
> extra bit of complication is worrying about how to handle the
> situationwhere if the kernel crashes.

I think this would be up to the fs, but the semantic expectation could
be that the whole thing gets erased and we retry on next use, or the fs
uses a fs dependent mechanism to cache the partially constructed tree
and completes the construction on next use.

>   The current thinking is that the ioctl which enable fs-verity
> protection on the file will make sure that the file descriptor is not
> otherwise opened for writing, and then set the immutable bit. 

If you simply use standard IMA xattrs, you don't need an ioctl ... you
actually now don't need the file to be immutable (although you could
additionally make it so if you wanted): IMA signed files are
effectively immutable because you must update both the contents and the
signature for the file to verify.

James

> Once the Merkle tree is written and finalized,
> the fs-verity flag would be set and the immutable bit would be
> cleared. The exact mechanisms of crash recovery would be file-system
> dependent, and TBD, but would probably rely on the journalling
> mechanisms available (e.g., ext4 might rely on the orphan list; f2fs
> might use copy-on-write semantics; etc.)

I think all that is per-fs semantics that don't need to be specified
for the generic implementation.  I'd be happy with a write to the file
causing a halt to the construction and a reconstruction not starting
until the xattr is updated.

> This effectively moves the complexity from the interface (which is
> where we seem to be getting hung up) to the implementation, but as
> stated above, the actual code to create a Merkle tree is fairly
> simple.
> 
> Hopefully this will cut through the current complaints of the
> fs-verity API.




