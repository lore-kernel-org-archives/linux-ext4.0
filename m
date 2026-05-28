Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2348A2E7360
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2026 14:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779980266; cv=none; b=nYTaFpoQzK9qJjaQBpuOEtiNWtpf3HoJcRuu5CHHwjzVhpPr8HdASvk2mG24/wexZ7odouoCjl+hlD2QRs3mov5KQ8Wcy2oywTIHdc6plMbHmBtQWu/Aws3XvaVM3jRMpd2FSd76uWpptiB4/D31/ShUW6WIe0e1bxFFu+ymFh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779980266; c=relaxed/simple;
	bh=xPqOgVgYGPTJ6C4KNZOo2bJJEjldBGZAb8uJ3RyJDwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UGrIjDm9yR2vWmwA0ZdCds6PtD+wgBZWyvCJp5QSCxtvEfXQcjDO6Bs14BsPAYX8TouQhnv1slgizi+EVhZJSSsiN6yWy83YQhZSwB5bbR9WcO7Qp+CrUPe4KsXh28o9BGZP1NcNg+7FOGVOegjrhLNkaZayyxvxGY7pB1IKBEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=QGpZd9wz; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="QGpZd9wz"
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 64SEubRc017388
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 May 2026 10:56:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1779980200; bh=iqKteAK984FjwrM5PUMtor5r+Y3QTmrXtVrkLQwwr/4=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=QGpZd9wzqCbV7xQH0w76CblTqieXM7kUoSXGpxAjVPSbj1/Ypa5DYfskjVMGOk1lL
	 UOMZoB8JI1dTstXcJNcUCLR93e/lr9X2x86cZEkeMNiY1RfXMGaqFLSeobMNftFnCY
	 bR1bbRXL/+LefT26bWZVRa2mH5PVGu+jkSgWFZ26rURVEss6rUU2HpVXSyDyHlPYw8
	 WaKruws0uRJ8H8rlCVbUMzbq88EEGrEa4YaURnPD6LZcBztWBjNIbAeuQJmcQ7z76V
	 f0NSzZZyOR6t3k19wK8wcBEpc++pSnvGVq6C6Ug6GbHBu2EWVlLUaQHsc8YOvgUhHC
	 TLIBHlcdOMD0w==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id D7F236B6C0A3; Thu, 28 May 2026 09:56:36 -0500 (CDT)
Date: Thu, 28 May 2026 09:56:36 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Abdellah Ouhbi <abdououhbi1@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, me@brighamcampbell.com,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] ext4: Use %pe to print PTR_ERR() in namei.c
Message-ID: <3ogsm2rbiyacwos6i3han5lwkuobxjjggpwfmkjbv45hrhqwh7@6d5mxzdvidbq>
References: <20260424152245.142308-1-abdououhbi1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424152245.142308-1-abdououhbi1@gmail.com>

On Fri, Apr 24, 2026 at 04:22:45PM +0100, Abdellah Ouhbi wrote:
> Fix coccicheck warning
> ./namei.c:150:25-32: WARNING: Consider using %pe to print PTR_ERR()
> 
> Replace %ld with %pe and PTR_ERR(bh) with bh pointer.
> The %pe specifier automatically converts error pointers to
> human-readable error names instead of raw error codes.
> 
> Signed-off-by: Abdellah Ouhbi <abdououhbi1@gmail.com>

I've folded the three patches you had sent into a single commit.  For
this kind of cleanup, there's no reason to have separate patches for
each file.

Thanks,

						- Ted
