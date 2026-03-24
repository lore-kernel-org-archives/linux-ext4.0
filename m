Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D763DF017
	for <linux-ext4@vger.kernel.org>; Tue, 24 Mar 2026 14:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774361873; cv=none; b=dePssDP10cn3D3UJFLLVnaU6CcAquuBMYDG9EREN5HNGbeNPXhXz8oL7fXh8cf8JYMSsoghfZLu3S6YJgDFWVi66iVrF1PWSJz/JFE0cKBIQkFrTnIXDK7xs/j8EuhxX7Zi8fmk8raqeoFo/e/t5DE2PfFLhGTkURZY45sI6ElE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774361873; c=relaxed/simple;
	bh=WkCXLvp0Y+kynq7zJTJrT3ZPnljrBtgdb+eZYQLgpig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=geIdwHzfD8aGDlD1LVIUXhFu7YnfhHIaVWxu6B6BxVPlIUJ6iqJZNVX1OTSns3kOaNllAw6mtkrXru9+aoVPGVRfblPIMkmPbq+9g/l5R+g+mnYb7sa0vdBO900JNWS85ygDHZuoEXPrCP7ay+wJX7Oz+BQVq8Cb1/KRJdnJWbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=jUP/XXYI; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="jUP/XXYI"
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62OEHMaq001426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Mar 2026 10:17:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774361849; bh=mSzgvwReQH7ZlPpjVxcHpEMpCCM0Y9LMGuF4Bg/YgG8=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=jUP/XXYIhnV37x6g34UVAoaA2CeZald96089TWCWoKJFPXb53I7I1QS6WMNc72Sva
	 ulQ0FhO5+T+5UOJkzkX4XjHIcwCiz3tad+/4e/CxSL+0zl2O8dIRkjVCpJQAuUxDL7
	 vteMoum/3C5TmLQYeleQViDkT57aBfQ1Pa4uz3ipscuteoariYogdfLogq6hy+4amc
	 kU5uqq0POr3mY5GCNBx3y0byZd11i/McI+OubX0BjlHDQ85RI2ZWG8KIerrayZ1GO6
	 CCv6ne1IKNu2IELSrHr3xuTjY3xWMIGA5ceL4Wi+P5BHfYnTZ52fv7T8x0+BWpkeGs
	 1Xheg2zlsUsRA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id E8E5E5F0EB50; Tue, 24 Mar 2026 09:17:21 -0500 (CDT)
Date: Tue, 24 Mar 2026 09:17:21 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: Yi Zhang <yi.zhang@redhat.com>, linux-ext4@vger.kernel.org,
        linux-block <linux-block@vger.kernel.org>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [bug report] e2fsprogs 1.47.4: mke2fs creates oversized orphan
 file for 1k blocksize (breaks mount)
Message-ID: <20260324141721.GA61656@mac.lan>
References: <CAHj4cs8o5HExeOX2YCYrWH86iz4xwL52YtsJNV2YOyDPbyEffg@mail.gmail.com>
 <d7a82737-a293-4e72-b5e4-1c8492d06e8c@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7a82737-a293-4e72-b5e4-1c8492d06e8c@linux.alibaba.com>

I will be releasing an updated e2fsprogs 1.47.5 in the next day or two
to address this issue.  Our apologies for the inconvenience.

   	   		    	      	  - Ted
