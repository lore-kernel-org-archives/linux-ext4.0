Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BE13BC680
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 11:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775217264; cv=none; b=PAeXulLoaG4vsXhrN7binUPewaItZQEIPKx5UvZFKEfTwirYlK3GsNHxa9xadg0P3A6O0PN2bM8wVaRrivx43NvjvS5bU/XzMaOwOJGT6Cq5vn5XPjInejLiiboLEIMHNWldqvkqI/1Lyin704VTTmDkZYrrd42vVskImNZ6mnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775217264; c=relaxed/simple;
	bh=UwqKyLWLziEgV+1hrGCsLI6mKeWnvVXjKwYl6Ea7jQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NeRy68wuWFRyOrpoQC2hHMbILVhUuK7wrN5WWWRy6jCtilOzAmdjtiTn4ToBiwQUGv7D9X9IaKkgCY6Q1VXQonWggXrCn6B+mnV3BaTkRg1JEtxjL6aC7AeuUo10HAzQqJ31JLspm2uS/8qNiGCKcYqShj4Xl8wwj1AYOhsXz8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=FMqqk10s; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="FMqqk10s"
Received: from macsyma.thunk.org (pool-173-48-112-174.bstnma.fios.verizon.net [173.48.112.174])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 633BsETk002779
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 3 Apr 2026 07:54:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775217255; bh=xILsTs+8T0FrGTJASkQ0wa4ZlXpCbhRtexlPlzFgvOA=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=FMqqk10s7yoZNgpT/QIATBg9znV5W/85ucm3PMdkdjpfLdNtymFDozpAazAV7K6N4
	 BcEFga/61q3pBn/6XAc2WDqpLRIBCCGxvtVWhc4h3BKgfI9qsrWBDS2YoZKt04nXxy
	 895ABSVSJsvCoZrrNX4pz8Q+6jYNZW+hO9x33vOrSpFk6l20lz9EEXUhoO+hr5Df4v
	 KFiPlPl5kBjRIvRQzee40Hd6OXY6RV+viW5+cwt3/zD4Zg9OXSJtzZuZJAnZT49X8+
	 aDUo5sM7dh9nT1UQpUEQ1byZ3x7FSgdeKgJ46mjoJBS9eNk/pUppJv/FrPiYOcPUJT
	 1A8x4T1ETS6hQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 94F1160FF991; Fri,  3 Apr 2026 07:53:13 -0400 (EDT)
Date: Fri, 3 Apr 2026 07:53:13 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 1/3] libsupport: fix portability issues with the bthread.c
Message-ID: <20260403115313.GA12260@macsyma-wired.lan>
References: <20260403040328.2385083-1-tytso@mit.edu>
 <20260403040328.2385083-2-tytso@mit.edu>
 <20260403041624.GD6254@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403041624.GD6254@frogsfrogsfrogs>

On Thu, Apr 02, 2026 at 09:16:24PM -0700, Darrick J. Wong wrote:
> > -/* Define to 1 if fuse supports cache_readdir */
> > -#undef HAVE_FUSE_CACHE_READDIR
> 
> Huh, there's a lot of churn in this file.  Do you have a magic script
> somewhere that regenerates config.h.in?

It's "autoheader".  Whenver you add or remove tests to configure.ac,
you need to run "autoconf ; autoheader".  If you don't run
"autoheader", then even if the autoconf's feature test enables some
new feature test, say HAVE_PR_SET_IO_FLUSHER, the feature won't
actually be enabled in the #ifdef.

Cheers,

							- Ted
