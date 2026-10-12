Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5833B0AF3
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 18:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791831298; cv=none; b=pqaS2I6eqk7FAqbQqai9VW0g0W0ExtRSarbkVKmsHv3I93GtAdjDoZXwBB0W4uli/Z6pAYQ/Hiy6vytjKwRwfeyHsyA1p7dLBelpjqLV0C6a4CatIDaWSoaDQerDpy36avZ4dYKoTP2N/Sdx1nRNW4rU+2tnB6l645h87WV9fho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791831298; c=relaxed/simple;
	bh=uSsj3domjqDPkTGaE1zINnP2Iko0kvQk5J+sqA8q0sg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CpdJIizzIDj+bdkX1LYhm7OqIICDo4f31kaUQxLUoDa9/s7Y26mflrVYTF2iIN71Nxo9xYwVAi9hQ5+/viJplcFpu/NzYcSlhVzb5pt9N+9YSh8ZKRGYAodr53gEwboTPP6I7pBG2QX9lanLjy2MRfYXecUu5qRv/vMiuPgCirk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=JEFnbdFH; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="JEFnbdFH"
Received: from macsyma.thunk.org (pool-173-48-111-204.bstnma.fios.verizon.net [173.48.111.204])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 69CIsjEk032717
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Oct 2026 14:54:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1791831286; bh=v4dNfEL5eAGeTEQ847I6fsZ2V1kZb4cUrrSFYhIHZLQ=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=JEFnbdFHJwjdhhHSKKFw5qqE2H9Lmzf29CKsblwGn3Vspb7nEfOW/aFpBCDUn3DCQ
	 IBub4Z0NQiPZQbPfjnf77+2zoM4kw40rZfzQ2ZI7gQ4tezeHkwQZbslMlLatGAcxpE
	 3MSHzbSuZdO4p/mvw88a7a+cvDRysr4S3BKiXdgltaM0JxN5uh+5eqOFu1psXH3B0p
	 +vU4oUAZ2zYHZZh8QLNWB1zbUTLNxlpzNXYUpunzAYgqQz7TBRTmi1h5wNhb1OkDSk
	 kxvEbmx39ZJJHTww5XehVaHSIw/z+WinlrAiiM7OiMp6A/gDIdmfFYjoRLREKHC/Rx
	 uRVzT6CW0tphA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id D0B5B1FF9771; Mon, 12 Oct 2026 14:53:44 -0400 (EDT)
Date: Mon, 12 Oct 2026 14:53:44 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Gabriele Moabiti <gabmoa@gmail.com>
Cc: linux-ext4@vger.kernel.org
Subject: Re: ext4 data=journal deprecation: long-standing industrial use case
Message-ID: <as0U-lfet5slrD8o@mit.edu>
References: <CAAbJaeALOrZwWs++mz9Wv0pfvyDoHmfzPKyVHR0v6TwnzLkYGw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAbJaeALOrZwWs++mz9Wv0pfvyDoHmfzPKyVHR0v6TwnzLkYGw@mail.gmail.com>

On Mon, Oct 12, 2026 at 03:41:29PM -0500, Gabriele Moabiti wrote:
> 
> In these deployments, we have not experienced problems with this
> configuration over those 15 years. It has been a reliable solution for our
> operating conditions.
> I understand that data=journal is deprecated and scheduled for removal in
> January 2028. Given this established industrial use case, could the
> decision be reconsidered, perhaps retaining full data journaling as an
> optional feature?

The challenge with data=journal is that it adds a lot of complexity,
and more and more of the advanced featuers are simply "turned off" and
the original code path is used for data=journal --- and the "original
code path" is only used by the data=journal case.  This has the
following of undesireable outcomes:

   * Extra code paths == extra maintenance overhead
   * The data=journal specific codepaths are getting much less testing
   * There are known test failures with data=journal which are not
     getting addressed.  (n.b.  If paying customers were supporting with $$$
     the SWE investment of data=journal this could be better addressed, but
     at the moment data=journal is essentially best efforts by volunteers.)

> If removal goes ahead, will ext4 provide an alternative with equivalent
> protection against interrupted data writes and abrupt power loss? In
> particular, I would appreciate clarification on how users relying on full
> data journaling are expected to preserve comparable guarantees within ext4.

The phrase "comparable guarantees" is not particularly well defined, because...

> I understand that data=journal does not make application-level updates
> atomic or preserve data still buffered in userspace. Nevertheless, its
> protection beyond metadata-only journaling is valuable for our deployments.

Given that there is no guarantees of what writes will be persisted
with respect to program execution, it's unclear exactly what your
deployments are requiring or assuming.

That being said, I *suspect* that this should cover most, if not all
of your deployments' requirements.

echo 500 > /proc/sys/vm/dirty_expire_centisecs
echo 100 > /proc/sys/vm/dirty_writeback_centisecs

To make these changes persistent after a reboot, put the following in
/etc/sysctl.conf, or in a file in /etc/sysctl.d/

vm.dirty_expire_centisecs = 500
vm.dirty_writeback_centisecs = 100

What these changes will do is if there are any dirty pages, writeback
will be initiated after 5 seconds (vm.dirty_expire_centisecs) and the
writeback flusher kernel threads will wake up once a second
(vm.dirty_writeback_centisecs).

The default values of these two settings are 30 seconds (3000) and 5
seconds (500), respectively.  By default, ext4 uses a commit time of 5
seconds (mount option commit=300).  In data=journal mode, when we
close an jbd2 journal commit, we effectively force data to be
persisted after a crash.  So by setting vm.dirty_expire_centisecs to
500, this will have roughly the same effect --- which is to say, after
a write first dirties a page, that page will be persisted after 5
seconds.

If the application wants a guarantee that a write is persisted, it
should use fsync(2).  But if you don't want to modify the application,
the window between when the application writes a file to when the data
is persisted can be reduced from 30 seconds to 5 seconds either by
using data=journal *or* setting dirty_expire_centisecs.

There will be some slight differences in behavior, but given that
data=journal doesn't have any real guarantees ---- if you want those
guarantees, using fsync(2) or fdatasync(2), hopefully it should be
good enough.  You may also find that performance may be improved by
using dirty_expire_centisecs if you are bottlenecked by the storage
device's I/O throughput limits, and it will also reduce flash write
endurance impacts (and hence improve SSD lifetime) if you are using
flash storage.

Can you give it a try and see if it works for you?

> We would prefer to continue using a normally writable ext4 filesystem,
> without introducing an overlay or migrating to another filesystem.

Note that no other file system has anything like data=journal, so
introducing an overlay (not sure what you mean by that) or migrating
to another file system is not likely to help you.

Cheers,

   	   	       	      	     	     - Ted
