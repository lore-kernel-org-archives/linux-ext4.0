Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E427131716B
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 15:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774626167; cv=none; b=G9zHSV8RJ7/xBvYR/EFnYUxXNBQvw3XsXJ9insNPy2/fyXCZFhP/h91LkSnmKUWxi451KgaY0i3uQfKUI59r6va+T0cvGtQ629SeI9I9juXO8qXmOrcayDHOzDbYypjSW4BL31KBG0iJsxFQlBThxcs2VDSSrZLnwQpUSC9PgrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774626167; c=relaxed/simple;
	bh=/fsmBeV8mwd0xFPdQ6ufX1/kc/hVPzAFzEkHlcxBJgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YCf9/VNGRlN/8EoQIzMGnkV6e3pmXAP5fG0cKLPjpQKWXregOnghz2QCDJAaqtYDKZLQ3HEEWpS3b2pABPk2JemQMF2GgBCQvsvOl7t1eTI2RNsMY5vCbJ+VKzYhTOOPlNdgYHYbQDQSfDvwiMtM0y8eeSsPeSofvU3sa0c34q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=W3qP9m+b; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="W3qP9m+b"
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62RFgYcJ020418
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 11:42:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774626156; bh=1er/RskN0vgkHg8Op++rmdJAjd+Cw53EY//ShEnTlY0=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=W3qP9m+bSher5PBpmr8CVQhhP+6afTcWVB0HHt6g9inBAYqwLgGT6bifxBhR/tkf8
	 qsXidyR048qSHmPw9hvPzu8uuUj2XwetaeydBAaoSb1DtxXdsXxrollubN7Ojk/qVX
	 GTjXpLNOr+gVllpQ+b3KszSXH5/9d0nfA0MYlv8OuNJx6wTGDLuMqYoFPRM20679C0
	 +5nIhE/u9xshpZPvJaBdOFiSXd/wpiz1KsOP30fkx8b6aPc89/qiGzilxluUKqh9NJ
	 DzAjJ42mrhcCGptsj7hhgWBJEU19g2O0sSVgBxbfMSK/BkYSd6MAK0XUf2s9zwdReX
	 wimUtKhVFwrBw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 8FA625F9BCF1; Fri, 27 Mar 2026 10:42:33 -0500 (CDT)
Date: Fri, 27 Mar 2026 10:42:33 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Gerald Yang <gerald.yang@canonical.com>
Cc: Jan Kara <jack@suse.cz>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, gerald.yang.tw@gmail.com
Subject: Re: [PATCH] ext4: Fix call trace when remounting to read only in
 data=journal mode
Message-ID: <20260327154233.GD4383@macsyma.local>
References: <4u2l4huoj7zsfy2u37lgdzlmwwdntgqaer7wta7ud3kat7ox2n@oxhbcqryre3r>
 <CAMsNC+s1R-AUzhe80vjxYCSRu0X9Ybp33sSMHGHKpBL6=dG2_w@mail.gmail.com>
 <bycdopvwzfaskilhk3nsljuk3gkztvoa3is466a6utuj2lozmj@pxf44ulcnqup>
 <CAMsNC+ve3dRwT1xGWB0pvBJXqBpeksf7PgbEeihcnfs=AmwVRQ@mail.gmail.com>
 <gluj62pw5pu7ag2juf5ejwsr3ghvckag7wh4zunwyk57slcrmg@42of57gybigz>
 <tmtgzmvkfag4r6lbt4i2ej5ad3bfudezcm35l27ybit25r7l4d@5o2i4cuymh5j>
 <CAMsNC+svSX9AiZbs1dd4qigZqBuOjuCHOjpyXzgaO0sNLUHDYA@mail.gmail.com>
 <CAMsNC+vQceRaw9DkbQFo1p2piwcwDbTgohqt=Gtqj27n42kLTQ@mail.gmail.com>
 <si7uicc6vntron5s64lt5fzcubizryshxeafdeysqdid2xfmfx@mrjpfbddtdqk>
 <CAMsNC+u83HArYs1zjQ-YUHyADruros20LOB2m52=aeDXcpuJVQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMsNC+u83HArYs1zjQ-YUHyADruros20LOB2m52=aeDXcpuJVQ@mail.gmail.com>

On Fri, Mar 27, 2026 at 03:26:38PM +0800, Gerald Yang wrote:
> 
> Would this be merged into the next merge window?
> https://lore.kernel.org/linux-ext4/20260205092223.21287-2-jack@suse.cz/

Yes, it's in the ext4 git tree already and will be sent along with a
number of other bugfixes to Linus before 7.0 is released.

       	  		    	  	     - Ted
