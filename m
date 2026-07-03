Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40D83CAE68
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jul 2026 11:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783079324; cv=none; b=mWguu8iuk8eRlE51GEwpOHwnEGht4eJ0V2U4GO5E7FnfjsEThcRAWApOG++XBrsUUvZa/CBfZbbLpqF2Xa2bsQYrRi5w7BK6+G1ZbGqD1ZQrGbc77y6RG2yrVz2OCCT966WCKuBi54zPIwFeCZaiKV86xJ+8fEkjf/1kB5p+22A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783079324; c=relaxed/simple;
	bh=5JqLuEiREk8klCaoqV+K5aWMLAGYc2iXBg4rGhZbat4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fVClYoPXTLuMvRDvn6exbHefpo+bMxFFLhQ7z5VbEMwHIiF2OpjZTG3cvSxdDGNyhEokSw73nQfKmWupTiQ3ef9I07EiUqNIpR+ttdHwZ4hV6FkQcxQfRUacFGEtbH82ABVFUA/t9wvP8VWvl4L8evQcYOX0XS8i+3SKuXQYv2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from macsyma.thunk.org (syn-072-043-125-131.biz.spectrum.com [72.43.125.131])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 663Bm81Q002631
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 3 Jul 2026 07:48:10 -0400
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id CD31589CE68; Fri,  3 Jul 2026 07:48:08 -0400 (EDT)
Date: Fri, 3 Jul 2026 07:48:08 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Jiayuan Chen <jiayuan.chen@linux.dev>, Wang Jun <1742789905@qq.com>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        25125332@bjtu.edu.cn, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [PATCH] ext4: get rid of ppath in get_ext_path()
Message-ID: <akehR1wEgK23wFp4@mit.edu>
References: <tencent_C982B0201FE8F041BD5B4FC1ED7D646A740A@qq.com>
 <2026062643-tamer-limes-a320@gregkh>
 <rrsgndgpxyrmu6okb43u6wkdaibbidlbyqgugeeijd2b44sf4y@6lzmm4v4xvdp>
 <2026070210-catty-grape-2568@gregkh>
 <b93095c6-0717-4616-9702-570b2927429b@linux.alibaba.com>
 <2026070315-crescent-factoid-616d@gregkh>
 <2904d1db-11fa-450a-89ea-20fe133fa268@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2904d1db-11fa-450a-89ea-20fe133fa268@linux.alibaba.com>

On Fri, Jul 03, 2026 at 04:44:32PM -0500, Baokun Li wrote:
> >> Either applying this fix patchset or reverting the incorrectly merged
> >> commit should resolve the issue.
> > How about submitting a revert so that we can start fresh and work from
> > there?
> 
> Alright, I can help review the patches.

Can you also double check whether your patchset actually fixes a bug
in 6.6?  As near as I can tell, it wasn't needed for 6.1 at all.

Thanks,

						- Ted
