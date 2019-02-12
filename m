Return-Path: <SRS0=DlHj=QT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C0D5C282C4
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 18:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AD21222C4
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 18:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549996934;
	bh=kKcocbyVyY68xTUZWEtX9pqotXV9dItn896oHjRWliM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=hIX4MLKi2rItva8tD9BHx0m69DTCENCGyI51H13/RrYilhu2vL7VeuEMdwnIqW05Q
	 4U4tzz9nbpeQ17TgzHl/GzN7f+MpSJuvmPxkcSdQ+bXtH7OHOVaptNThz97DpzAfXr
	 OdjRSfi5qdS1ZFRXRHf3R3V5N6O6gwCNT7yYgFeE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731975AbfBLSmN (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 12 Feb 2019 13:42:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:41684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730958AbfBLSmN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 12 Feb 2019 13:42:13 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 601E02190B;
        Tue, 12 Feb 2019 18:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549996932;
        bh=kKcocbyVyY68xTUZWEtX9pqotXV9dItn896oHjRWliM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UcT0DK8eU2v3314NRQ+6Uuqso+0Yf4RYHkh5q5pH8VTtvpXv1EG5oXVo/ZI6QA1fL
         yDvv/oU96KvoNvaubIQ6j6AmrtdqNlR0kbFOO34Swm55iu0j/qcdiQZEBNoAlGs7vk
         atmqXS53rtXGHf3sVIhP5RCqy6mLCkPI9MI3xqiM=
Date:   Tue, 12 Feb 2019 10:42:10 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Christoph Hellwig <hch@infradead.org>,
        linux-fscrypt@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-ext4@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [f2fs-dev] Proposal: Yet another possible fs-verity interface
Message-ID: <20190212184209.GA3373@gmail.com>
References: <20190207031101.GA7387@mit.edu>
 <CAHk-=wh2j+Yy28H_QxEdsP=k9xcHxjCG1PqKAF2Uv=ckK8oPug@mail.gmail.com>
 <1549807615.12743.109.camel@linux.ibm.com>
 <20190212053123.GR23000@mit.edu>
 <1549976812.12743.225.camel@linux.ibm.com>
 <20190212172433.GT23000@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190212172433.GT23000@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Feb 12, 2019 at 12:24:33PM -0500, Theodore Y. Ts'o wrote:
> 
> > > > The existing file hashes included in the measurement list and the
> > > > audit log, are currently being used for remote attestation, forensics
> > > > and security analytics.
> > 
> > Again, the context for this comment was Linus' suggestion "each level
> > of the merkle tree needs to have a hash seeding thing or whatever."
> > Up to this point, I had assumed the Merkle tree file root hash could
> > be used as an identifier, similar to the file hash.  With his
> > suggestion, it sounds like the Merkle tree file root hash would be
> > system dependent, making it useless for the above usages.
> 
> Yeah, I have no idea what Linus was talking about there.  The only
> thing that really makes sense is that if you don't have any
> file-system place to store a seed, you don't use a seed for the Merkle
> tree, and for a given set of bytes, the Merkle root hash is the same.
> So it's basically an expensive to calculate crypto checksum, as I said.
> 

I think there's confusion due to the use of the phrase "Merkle tree root hash".
Linus's point was:

> Now, since I assume that only the merkle tree root hash would be
> returned by the "enable merkle tree" operation (so that the code
> enabling it can verify that the hash matches the expected value), you
> do have to worry about the preimage attack, and make sure that you
> can't fool the hashing by making the (bad) file contents themselves be
> just the hashes of the (good) blocks. So each level of the merkle tree
> needs to have a hash seeding thing or whatever.

This is already taken into account in the original design.  The file hash
reported by fs-verity is *not* the Merkle tree root hash directly, but rather a
hash of the Merkle tree root hash and additional metadata in the
fsverity_descriptor including the file size in bytes.  This resulting hash is
referred to in the code, documentation, etc. as the "fs-verity file measurement".

Thus you can't fool the hashing in the way that Linus mentioned, because the
file size is included in the hash too.  And I don't expect this part of the
design should change, even if we change the API.

It's been difficult to get people to start saying "fs-verity file measurement"
rather than "Merkle tree root hash", though, so if anyone has a suggestion for a
better name it would be appreciated.  An earlier name was "fs-verity root hash",
but I thought that would too easily be confused with the Merkle tree root hash.

fs-verity does support a salt as well, but it's optional and isn't needed to
prevent preimage attacks, assuming the user chose a strong cryptographic hash
function such as SHA-256 or SHA-512.

- Eric
