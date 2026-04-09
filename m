Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112CB2EC0A1
	for <linux-ext4@vger.kernel.org>; Thu,  9 Apr 2026 14:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775743932; cv=none; b=A2tW2ASh2OQ5DoYqgVcJorqXOYh6sk6fTDiCd4APSLtt3cE6V5Di3kn/qiw5QYkct01z0v3iyDmcKFBOb+K7vfYBjCpiIB278oJusKkjIyDwILWLrt0GnUUuwGIKd4Dz55zKZKQuOAOen8qtjK5W/r9GSq9mprjckRbGccmkkDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775743932; c=relaxed/simple;
	bh=WfFOtlPs2NfDXPqb4oR2cN3XOdTSzWo3zgeHbGy5nsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dBA3A8YzAouqyJYhK7Cdnd208zOwY8aPZMV987/N9NbdoO9qil5GwK4mZNoEGyFl9glqr2o6Se2lT2/HE7Q5Q8K67xeN+/rUCo1GM5fCaybVyZpbbQgDGC9Q4P97Dr5i924LWAJzgikEs3qnyxEvTUXFIhSsTDomrEU3sECfDk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=IH+kJqSd; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="IH+kJqSd"
Received: from macsyma.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 639EBpC3008558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 9 Apr 2026 10:11:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775743915; bh=uxJLWPeeGFUiniSNpii4WFinjORBHMr3fYalQpg8VpA=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=IH+kJqSdmb9YrThN9ofBQzR+aiHqCBThJM48culO1NYZFJsa/ddqFG+erokjFQOwb
	 lkhFuHKQ4XvtYpj/aUSSS/lXEadAz9ZzpLZG95VF7yR978iFNQ68XTzGQqwPR+6pZ+
	 FLfmGHv8BtambhyanvYs4D+asH0LeWKzf8zXtftdTY44P85D82bJF0onrGeFjpKdTy
	 y6eq5NhUFdBmWtd4X/DmKiM+gSGVA6gvFsTJnh/y9JaTnD2tCy1G8uZUEIeNwbtcCM
	 IrcmFjq8iSC6fMTRXq6HpXDWdpgf/MDFfQs7NcuAc3aGdUmmHYDe9eJfL6CaJ1EDEs
	 QG2Ui5bZSVTvg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id DC98262647EF; Thu,  9 Apr 2026 10:10:50 -0400 (EDT)
Date: Thu, 9 Apr 2026 10:10:50 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, visitorckw@gmail.com,
        david.laight.linux@gmail.com
Subject: Re: [PATCH v2] ext4: improve str2hashbuf by processing 4-byte chunks
 and removing function pointers
Message-ID: <20260409141050.GA59468@macsyma-wired.lan>
References: <20251122043929.1908643-1-409411716@gms.tku.edu.tw>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122043929.1908643-1-409411716@gms.tku.edu.tw>

On Sat, Nov 22, 2025 at 12:39:29PM +0800, Guan-Chun Wu wrote:
> The original byte-by-byte implementation with modulo checks is less
> efficient. Refactor str2hashbuf_unsigned() and str2hashbuf_signed()
> to process input in explicit 4-byte chunks instead of using a
> modulus-based loop to emit words byte by byte.
> 
> Additionally, the use of function pointers for selecting the appropriate
> str2hashbuf implementation has been removed. Instead, the functions are
> directly invoked based on the hash type, eliminating the overhead of
> dynamic function calls.
> 
> Performance test (x86_64, Intel Core i7-10700 @ 2.90GHz, average over 10000
> runs, using kernel module for testing):
> 
>     len | orig_s | new_s | orig_u | new_u
>     ----+--------+-------+--------+-------
>       1 |   70   |   71  |   63   |   63
>       8 |   68   |   64  |   64   |   62
>      32 |   75   |   70  |   75   |   63
>      64 |   96   |   71  |  100   |   68
>     255 |  192   |  108  |  187   |   84
> 
> This change improves performance, especially for larger input sizes.
> 
> Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>

Apologies for the delay in looking at this.  It fell through the
cracks on my end.

Because of how I'm a bit late with reviewing patches before the merge
window, I'm going to be very conservative in which patches I'm going
to land.  So this is going to be deferred until the next cycle, but I
wanted to let you know that I haven't forgotten about it.

If this was a comprehensive set of Kunit tests for fs/ext4/hash.c, I
might have taken it.  And that's something that I would look at adding
for the next cycle, but if you'd be interested in creating the kunit
tests for hash.c, that would be great.

						- Ted
