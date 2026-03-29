Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC3E37F8A2
	for <linux-ext4@vger.kernel.org>; Sun, 29 Mar 2026 17:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774804021; cv=none; b=Kx1YD6M8Bsbwo8eW5alFtc2XqGkVbwDj+/mcKAttYNNX2Rf/e1MQGlj2yNdyKuvUIqLw9KOSl+vab1gFHZGNjzEbhEu/WAEtBzu6S1OA64nOqtlRZ0U0U3ce2lCMMpfe1dUCPv9BbwuHPUP9Igotw0I8PXJo7AY2oVS4DwHijg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774804021; c=relaxed/simple;
	bh=UT7eYA1DAfyZ9kc0PKPVu99sXCkmWhn+btoKnOXosLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dP98IfFfa8vy1aQNNvUsFWM5VJSQEgCN2o6IxC07jG9m6NNoL621f7rCjkkTkuJnxE18vZEN4BqhghdcgAMi73OG3jabPzXDu9sevc/8Ck09eoySrJQ5BQdCj8ibitUwZ6Cj0Qj0eGUafKEbyMB/XduLAP2GEZiXgN+8ccrdUPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Bozc1XtX; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Bozc1XtX"
Received: from macsyma.thunk.org ([63.70.0.78])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62TH6mth011528
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 29 Mar 2026 13:06:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774804011; bh=yC0hGqqrUOinlM8lKjqHeq6W5zc6ZdOqXUQZICiRC3U=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=Bozc1XtXudFINihkWF00AOFaDpBmvZNFnWqYgnSqkktVkv5D4ucvhjfcnsDJoeZn+
	 qoxs+WGjxv3/7kZDSng1h3U8ZiZ0MLBwEIWTott/uJEtx7z6a9mtDVR+cbWPNPXBFw
	 WhI7kKxVUvcPXz+eM8S6f8aYq/TqgiUyhDNCGnv+BUc+ROXfTmXgAo86oI7zS7WOLS
	 +S7eK3Q8ZyvDcCym2XA3Xziqd0qF+o5UMz3S86NBTCWjD/Gq1j7h9KXZyFkEBE/wtM
	 pKRSOGsiEm40RczJ4RUr/HOffhWx9Wosxh+1qT62ocCGKt+gMpgygKsHfdSljBgcFX
	 2mX17VaQ/ck2w==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id EEC4E5FEC43B; Sun, 29 Mar 2026 12:06:17 -0500 (CDT)
Date: Sun, 29 Mar 2026 12:06:17 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com
Subject: Re: SYZKALLER BUG: messing with a mounted file system via loop
 ioctls (was: Re: [PATCH] ext4: add bounds check in ext4_xattr_ibody_get()
 to) prevent out-of-bounds access
Message-ID: <20260329170617.GA22278@macsyma.local>
References: <20260224231429.31361-1-kartikey406@gmail.com>
 <20260326054718.GC4383@macsyma.local>
 <CADhLXY5E_4Hi=Uzu3LPwg_YNgcFR+UcAbfY-XzwVnmFBaJqjkA@mail.gmail.com>
 <20260327163135.GE4383@macsyma.local>
 <CADhLXY6QjWHiyY2MkUutzJK8utKghMTxjG9C8X7e=WDL5xKvYQ@mail.gmail.com>
 <CACT4Y+ZzbnD_puTRMx4MpcACpp5m3aMhQYvH+1LAyTKOz6otEw@mail.gmail.com>
 <20260329134832.GA8782@Mac>
 <CADhLXY6uiBk1KTBH7M5Zjfy5RU3nPqaYaOD7FsQWGTwgfdi4Gg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADhLXY6uiBk1KTBH7M5Zjfy5RU3nPqaYaOD7FsQWGTwgfdi4Gg@mail.gmail.com>

On Sun, Mar 29, 2026 at 08:09:00PM +0530, Deepanshu Kartikey wrote:
> 
> Thanks for the sketch. I'll look into turning this into a proper
> patch, exporting bdev_writes_blocked() and fixing up the
> LOOP_SET_STATUS path.

Thank you!  Much appreciated!!

      	    				- Ted
