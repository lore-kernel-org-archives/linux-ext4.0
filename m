Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80075175A70
	for <linux-ext4@vger.kernel.org>; Wed,  3 Jun 2026 13:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780494750; cv=none; b=DcvQHqU1ME2H3AI090wmIAfm7D6HZkvUYLWJdMPa3YeKJha/reWpn4bTLmcPOoGaDyHrXvxyXqFcTr6l3dMnbBqwRWV0nSXHaQ+aND1uRzxqfUqknYTe3aDDDu6hKARtHdQ7wVWTzzYl62Db+ixxlJRCBYZFZL0Ju8i22kbFSEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780494750; c=relaxed/simple;
	bh=IonJWp4e+rdj1pgt5uR3o6HNhhWGZ82gM+sFn8+HTDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dvxLTmdWimLvZvkirfBPl02Uyw8Q8YHJHlvto6D86RoH3/yTGzp2raj1RCVhZ2BIKA44cXsULLd+hQ0fI4u2U4BICQEAS+YZdhKMSQBBQCqDN2r/QJIz2mUYxWYUSe896UMYwrhyggv6IIiAVHWFgKgZWkraZsQekVF3SN8RojU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=eS/O96ha; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="eS/O96ha"
Received: from macsyma.thunk.org ([104.135.218.91])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 653DqHZs026988
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 3 Jun 2026 09:52:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1780494740; bh=C9egDyRQuCmmuYUzZxv3ARCVxDOyCyC/MWLWmcoeqGQ=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=eS/O96ha/pZKJdnjD1IjrhcAZ6EIzmlzroT6I/ytlfxb/FNO+hG6wFYG/VmrWDGJB
	 xxCIyykihk/GA1d1csCrBeP79F7gdoP3MHMsmjuRbZz6kdZCKBKf9S0KaR7txHsg+H
	 FROVuN06gMBm/WlJQSvJE5Dwczr6rP7Ley3t/wY5DuEQ4EVJfRzHXJSuQ3cQMTlatM
	 +wcokxlempkwS01JSMCWi2oLVkFT5K7TVTkzoyhTfkMWxLdPZnllaTjWTROXkKbxIB
	 ZmrHjnI6hGIsMRcabF1MDnqC1KCm1/IWEo0fNNL0pwXdH+udQr5zmpdCoDZmZuQDBc
	 Z4A4OpIII9tZg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id DA8F435DF02; Wed,  3 Jun 2026 09:52:16 -0400 (EDT)
Date: Wed, 3 Jun 2026 09:52:16 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/8] ext4: convert mballoc KUnit test to sget_fc()
Message-ID: <iujcj4lpvgmzlyzb6vs2m5tb2xhuqdkgpkkpzzgdogg3kburtz@igmkmk3avqqe>
References: <20260526-work-sget-v1-0-263f7025cedd@kernel.org>
 <20260526-work-sget-v1-2-263f7025cedd@kernel.org>
 <ny6ggedljk3celsnnaaczpehmgll6hqrglqc44ku53cmxrclx5@w4qby54x6mff>
 <20260528-pailletten-gitter-hiermit-5198ec556b28@brauner>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528-pailletten-gitter-hiermit-5198ec556b28@brauner>

On Thu, May 28, 2026 at 02:02:50PM +0200, Christian Brauner wrote:
> 
> In these two cases it's fine. Because you're just using the allocation
> and deallocation functions to get a fs_context that's basically just an
> empty vessel to get at a superblock via sget_fc() but you're not really
> doing anything with it.

If you're OK with, I have no objects, but...

I'm sure it's fine today.  But is this something which is documented
to be fine in the future?  It just seems a little fragile and is
contrary to the documentation.

Thanks,

						- Ted
