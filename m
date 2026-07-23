Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C8248BD40
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 12:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784811234; cv=none; b=JT03wSGqG3knbeBE581bZpC6nZZUxxRsqNThb8qMmRgtDVv2eXYomnH51L+GnKNt55GztWuY2o0Nm4ijXw0eZt32zH7UzVyKQ1dVtnN9gEHuoeikmrelZLXpx9YQu3PkleuNzsCAsLc/jiVUXbvozgsZNuPe85yXfmtnR/AJ2+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784811234; c=relaxed/simple;
	bh=mdvIJyphpkMoBuFU0J7jr5FLKehwGpW5kcxncNFT7Kg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=anjnTg6xsLmwq9+KNZ4j9UQG86cg31OzgJvXrVFGYBwbRqiusYqYm10qD/6cv2PYTAaVScYh7ih9nL6nUO8mmJHnE0eDp42cqGGznjeJefgPWCzT46TyaDan05KKo+AY7lJ3rVDoSFEBZRotpFf+B5R/ASyJRn8yXRIFNJNoy8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=HktgEj4t; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="HktgEj4t"
Received: from macsyma.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66NCrKSb009183
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 08:53:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784811203; bh=JVdBHLslBf9jtlnGE2nWXmRTXf3fZbv2Tztzz0T0XvA=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=HktgEj4tPioB6pc+bizXKMBIJitvxDdUpjsOZAI4AGTx5/YbP2t97JpDa7x/gmUp4
	 eYxLjb/NXR74/NNMI68ctLen20gwrPjVO/moIgttF/J6Fcs7WrOILUnxLZGiMpiWPn
	 AqHdS0SiYki91CilZAbf820aEaacJE8N6Mrk6QQaOAELLjMvScMMTWndcighcDl4nw
	 LHEUWUQ5NebDR0WciFNgDXh3t59OecyBwtT7QD2Ru13OqPH2ML8W48HEheH0UWveyR
	 U+WkTXzRFYkEyPzTZs8Khk5A0hFb81NXtYLuZ4OLJnAZ2S36O+7eHUswCeBb0ZKJiV
	 c8LZB7ZNs7JxA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id CAE0ABC1DF4; Thu, 23 Jul 2026 08:52:19 -0400 (EDT)
Date: Thu, 23 Jul 2026 08:52:19 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+293a57918b36cfae3d48@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: defend against inline-to-block conversion race in
 write completion
Message-ID: <amIOFYmb6DlCxfMQ@mit.edu>
References: <20260718061238.50827-1-kartikey406@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260718061238.50827-1-kartikey406@gmail.com>

On Sat, Jul 18, 2026 at 11:42:38AM -0500, Deepanshu Kartikey wrote:
> Replace BUG_ON(!ext4_has_inline_data(inode)) with defensive error handling
> in ext4_write_inline_data_end(). A file can be converted from inline to block
> storage by concurrent paths while a write completion is in flight.

Thanks for this proposed change.  It's covered, as part of Aditya
Prakash Srivastava change, "ext4: use fsdata to track inline data
write state and fix race"[1] which is being tested in my tree.

[1] https://patch.msgid.link/20260703045414.1768-1-aditya.ansh182@gmail.com

						- Ted
