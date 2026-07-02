Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1CE370D47
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 22:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783032103; cv=none; b=omaKUMFbsPm0PfXPz/wBHjJ/Tx/jnkAYCVGzoBy9tRswneg3IzlnjjTlncQPenkrD8Qx0yewUj+lKDS2Z0azfkc/ZBuKWn8qqsbiRqXV6LsbbRJId1we7Q2ONV5ewaabzhl5vC3P4sM6c08OGyDXFJnS2X1krpAwomDdDHXlkLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783032103; c=relaxed/simple;
	bh=jmymH8zFE169gpjDhcVVH3GrM5H+fK3kENKES5/LB6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cUHsNaqlIEtEO8xK0dbPbHrj0/gy0GtnsvKChZwQE+x6tfB6FQCRIgYbEmKTZsRzWEYV2/i5Nec/WTk6OSxALWWVjjUSKuRmnklhQDPCTfXJ+KJygHG0WrK8YArzgCIHfuB8l36h5BYvKxCBb8BZGwT8QcO/dsszwJob5SQRF4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from macsyma.thunk.org (syn-072-043-125-131.biz.spectrum.com [72.43.125.131])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 662Mf7jQ000562
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 2 Jul 2026 18:41:08 -0400
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 9C34686B4B1; Thu,  2 Jul 2026 18:41:07 -0400 (EDT)
Date: Thu, 2 Jul 2026 18:41:07 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: Jan Kara <jack@suse.cz>, Mateusz Guzik <mjguzik@gmail.com>,
        adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, xiaowu.417@qq.com
Subject: Re: [PATCH v11 1/5] fs: add iput_if_not_last() helper
Message-ID: <akbouO1usgN6burE@mit.edu>
References: <20260629110848.3085662-1-yun.zhou@windriver.com>
 <20260629110848.3085662-2-yun.zhou@windriver.com>
 <4k4crl4oobz4xtmvjoqwoefrd6in46xf725z3ewme3smgh5ide@6dmywcnp6o6y>
 <txvgbvn77wjgfz4ywdb25v7ol4ecszqh5yg3p4g56sbxq6prlo@rpfwveotnfvz>
 <6c4e9256-5727-44b2-b63c-e18fe1b95194@windriver.com>
 <mqchxi74vrsmsitr46gtnw5w7tooj7go2tm2jadg4mktppjafc@5uplsind6ooq>
 <12a0d660-2794-4dc0-910a-3c63155624ba@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12a0d660-2794-4dc0-910a-3c63155624ba@windriver.com>

On Thu, Jul 02, 2026 at 10:55:31PM -0500, Zhou, Yun wrote:
> > I think there will be no more feedback to this series. So just
> > include this suggested change (keeping current Reviewed-by tags -
> > the change is minimal) and submit one more version. Mention in the
> > cover letter that there's only minor adjustment to this one patch,
> > everything is reviewed and ready to be merged so that Ted knows.

No worries, I've been paying attention.  :-)

Christian, I assume you have no objectoins to my taking this first
patch through the ext4 tree, since you've reviewed it.

      	      	       	     	   	  - Ted
					  
