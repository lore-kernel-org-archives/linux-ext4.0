Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023EB2153EA;
	Wed, 18 Mar 2026 08:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773821413; cv=none; b=WWFDO3QhSNXPZP/8soHZn6IsdJjQmb3+AclxW6/8MBvYqZKUd8ToRxuF5OAIdT9oXE9yqglrnb2glJsWlNQMEw9LB9hXflBL8dAo2Kwlv0LRpcFJ++janFOWMkH/fJYnaeNwqmq7DVochZWadKJqvxBQHGe+9hc1YgIF5soWUGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773821413; c=relaxed/simple;
	bh=UqG7d1RST0Q7I/HU8gHmDVv9YpkY0BOvgkpQFs9lbw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=REuJhEehbyKV8Fj1m5iuIVqFQdvq5j7h5sIq/Yak6n1tkqbHlcYRs45r2hmh2GYUIsgxkYErepK+LkBLYadn69srqx6YxmLwZ3Z+mkvf6C666N6KRl2+F6ReIssoPYfvyPf0lOZJkIYE1liU3u8WP+Jh5RcofxdMwDZ+eShkoKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R4pDpzKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R4pDpzKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E9BC19421;
	Wed, 18 Mar 2026 08:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773821412;
	bh=UqG7d1RST0Q7I/HU8gHmDVv9YpkY0BOvgkpQFs9lbw4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R4pDpzKK4osg9IBwFBYFPbnSJEHe4p2mRIwa7tZ3OgeTUP5a8JeEG22OYlHq2CQ4R
	 h+8Vb/geNuADV8I3fm+Wf7puKN2n9ZNT0C3YMJf1fj4WI/SYhtns3LclAFHnLW/4tl
	 kW8y46NlUCGxjH8fHXgNja/ruuiPHZfT3BtMAI6c=
Date: Wed, 18 Mar 2026 09:09:52 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, tahsin@google.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] ext4: xattr: fix out-of-bounds access in
 ext4_xattr_set_entry
Message-ID: <2026031838-knoll-clammy-6446@gregkh>
References: <20260318075842.3341370-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318075842.3341370-1-gality369@gmail.com>

On Wed, Mar 18, 2026 at 03:58:42PM +0800, ZhengYuan Huang wrote:
> [BUG]
> KASAN reports show out-of-bounds and use-after-free memory accesses when
> ext4_xattr_set_entry() processes corrupted on-disk xattr entries:

Does runing fsck on the disk image before mounting it catch this error?

thanks,

greg k-h
