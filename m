Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853213C2E
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 23:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775257899; cv=none; b=q25i+BjoxGldjFhVKyjLvU/WtGRusLQCH4gDlQ21QuJ9is600Pf8e/n7NbdbR2Z6btRNLQYP4tbTzzpI0SCMlOg+sjesP8wjO1SNPm+4Ot/50SOJX4cT1YS5aNCETD3jWGH8C7c/HlZOTSjSsXYQ9GKVbBhLzpMQNXWAtl/x0hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775257899; c=relaxed/simple;
	bh=p97Iwps1zHYtHEZhKSPzWbE+xeNtlICxY7S3kiLvzZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OY5Izi2JIzYmUhpZSiGMMZKfch8UQYF0fBFm4az0gFBtRLzleqcIyCurQlYwvWIhRqp3XGsFa7usjfJwdJGqOXZk2xePBbnCQme+m8rWb0P9tfy+2FKqohNF4GXC1UymRLhAOUG+vPWyWfkC144TBk5g99K6YfEmQskIOO1pKjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=cJKLhcsf; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="cJKLhcsf"
Received: from macsyma.thunk.org (pool-173-48-112-174.bstnma.fios.verizon.net [173.48.112.174])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 633NBOGY010923
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 3 Apr 2026 19:11:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775257886; bh=UPW0HEv0TObU+6pjE5tbDZRyAksTgUI8B46RMzCu88c=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=cJKLhcsfoCcbu3ZP7IGvG0DQVXlJ8UJRJBVJhTXobKya1yzJF/GGSKM81mlSgidP4
	 3fTbfizj05vYFOhlhJmfoihNolppBfqEidYQqDuIgdywO2i93aL4Xx/7fSf7MiH2Fx
	 Go3WPeUBGivOAVgNmNuOom2ynrgjbL/EodxthkY4GFp6VYAOyU1YX9EJ9iZeJIw2hR
	 b4LltXTuplbLBm6+cm0DcdQah3m0LZDaK2jFQxN2ESQqa3D9NGbcUSeHhAFvdVHMsP
	 vG2G7rwJjtFbvhkxo5CKnmzzMAF3WPcFzP8NzQ6lOdJvXCSaRvSNitBrcPAjsKELFJ
	 MQxAlE5MLq4Yw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 8EF6D611069D; Fri,  3 Apr 2026 19:11:24 -0400 (EDT)
Date: Fri, 3 Apr 2026 19:11:24 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Andreas Dilger <adilger@dilger.ca>
Cc: 4fqr <4fqr@proton.me>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [SECURITY] e2fsprogs =?utf-8?Q?v1=2E47?=
 =?utf-8?Q?=2E4_Vulnerabilities_=E2=80=94?= Orphan File & Extent Handling
Message-ID: <20260403231124.GE16311@macsyma-wired.lan>
References: <DJq7WqGAG9HBnpd-DVD5sVNGDUoSoP2sJ5RAXlucoYhtbqxJXFNUUfhFETwaDeDr6Q8a5xp0hVJb0yIt8EucI-F-PQ28zg8i0Y9HmF8qk5Q=@proton.me>
 <0778B5AC-16ED-4736-AE64-849541629466@dilger.ca>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0778B5AC-16ED-4736-AE64-849541629466@dilger.ca>

On Fri, Apr 03, 2026 at 10:17:38AM -0600, Andreas Dilger wrote:
> 
> I don't see how this exposes any kind of security vulnerability if it
> requires that the image be specially modified in the first place?
> At that point the "attacker" can directly modify the image in any way
> they want, regardless of how e2fsprogs behaves.

After taking a closer look the "vulnerabilities", I understand where
Andreas is coming from.  If the threat model is "the attacker can
modify the file system, then the fact that you can craft the orphan to
"force" the the file system to release an inode isn't interesting ---
because the attacker could just simply overwrite the inode and mark
the blocks as not in use in the block allocation directly.

If there was a way an attempt to pass an inode number which is very
large to release_orphan_inode() could result in a buffer overrun, then
that might be interesting.  But the oh, nooes!  You might be able to
force the file system to release the resize inode is not interesting;
the attacker could just stomp on the resize inode directly.

Should we add some better bounds checking?  Sure, so that we can give
a more user-friendly error message, and reduce the chance of
accidentally making things worse if the file system is corrupted by
chance and metadata checksum is not enabled.  But is it a "security
vulnerability"?  No.

No, if you could actually force a malicious payload to run due to a
stack overrun attack, that would be interesting.  And I was expecting
to find *something* like that in your analysis, only to be
disappointed.

Cheers,

					- Ted
