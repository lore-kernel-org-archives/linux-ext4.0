Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017153F58D6
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2026 16:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784563499; cv=none; b=Fqo4+TscB7Yk1AwUUict+k//9ZWGK9hXK5BvNwqrrmJXRswvG9q5ndSjS+AQCy/p13sb9EfnO1sF93A/chnNQYk6MviqWkzD6mIUQocWslaXe9C/h96HLLUesILyFof+xc+/Npas4IG1BmWSCHg4vnzNDxGdwgmpoW9plJ7QJqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784563499; c=relaxed/simple;
	bh=6eFeKshaQIHFu9mtGd+HAxze/gXMsuiRv7Z76jC7LMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F3O5fbx46MVObU3M9u6tDZYR9NAAH1dNkcAt37weJT03MjDrkyhQnNbLUeXL3bdDcmdzENxMTQuDMqwd1exOsizb7wS1C12kxPcyXECY0VuPv8AVppcBUcgYoHfG2KQPFYHU6QCP8qUQtIfEQR3b7ep5uRyez7SHrLoB4XzjcMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=IJbNURBT; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="IJbNURBT"
Received: from macsyma.thunk.org (pool-108-49-65-18.bstnma.fios.verizon.net [108.49.65.18])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66KG4lOB024710
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jul 2026 12:04:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784563489; bh=4zxPTCLaR5zr/GZ5J3IbzWGepPkERqVcFRkCzcUgiHQ=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=IJbNURBTW5lYq02yyxHi2VsoiwMx7P85O4PBZ/aq5bw2Mhph5Bxv2akhGyqFaUmG5
	 wjbDIL+ulCsOTLHsILVQgrX3QLGo6hFvuGFFTPoabLLyfeh8NzkW810rcVRH6RO5OG
	 5pM1dauWcn52ajtKO2gwJktcR98ucGBqPRTJJw6SQkDLd9FWmyxHLdCXztq+bnE4kW
	 yQJnKUUkW/ACejumZHX8oHlkNJy1z1zTHOYITUkf+Ir192G3/WIkrxgEMShksiTSkE
	 cudYXwPMv6/3P/I+1o/6hL6XKAfLHmxx19zK7LoYjyGINemsKtYjVcbkZWDHaPrAqJ
	 8jTeKtPsgcSiA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id A945BB68545; Mon, 20 Jul 2026 12:03:46 -0400 (EDT)
Date: Mon, 20 Jul 2026 12:03:46 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH -v2] ext4: enable scoped NOFS when starting a handle in
 nojournal mode
Message-ID: <al5FynB8Lc9YqB8p@mit.edu>
References: <20260716144831.41290-1-tytso@mit.edu>
 <F1DF796F-992C-439F-B889-9F62DD22ED9E@dilger.ca>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F1DF796F-992C-439F-B889-9F62DD22ED9E@dilger.ca>

On Thu, Jul 16, 2026 at 01:45:51PM -0500, Andreas Dilger wrote:
> If you wanted to avoid an allocation for each nojournal handle on 64-bit
> systems, you could put a magic number in the high 32 bits of the handle
> pointer (which is unlikely to conflict with real memory addresses),
> and the PF_* flags in the low 32 bits.

That's an optimization we could do later, if we think the complexity
overhead is worth it.

> > @@ -513,6 +513,7 @@ struct jbd2_journal_handle
> >  	unsigned int h_sync: 1;
> >  	unsigned int h_reserved: 1;
> >  	unsigned int h_aborted: 1;
> > +	unsigned int h_invalid: 1;
> >  	unsigned int h_type: 8;
> >  	unsigned int h_line_no: 16;
> 
> Not sure if it makes much difference, but should h_line_no be aligned on a
> 16-bit offset and h_type aligned on an 8-bit offset by adding an
> "unsigned int h_unused:4" field before h_type, or reorder them so the 1-bit
> fields are at the end?  That would allow the integer fields to be accessed
> directly rather than also having to shift them.

Both gcc and clang support the extension of supporting bitfields on
char and shorts, so we can do this:

-       unsigned int    h_sync:         1;
-       unsigned int    h_reserved:     1;
-       unsigned int    h_aborted:      1;
-       unsigned int    h_invalid:      1;
-       unsigned int    h_type:         8;
-       unsigned int    h_line_no:      16;
+       unsigned char   h_sync:         1;
+       unsigned char   h_reserved:     1;
+       unsigned char   h_aborted:      1;
+       unsigned char   h_invalid:      1;
+       unsigned char   h_type;
+       unsigned short  h_line_no;

						- Ted
