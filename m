Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F319C23BD1D
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 03:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786678377; cv=none; b=BKIOx7lk7n+yaRyy8I9Itu6evoJjHsEBsr8/ckoCtirD/JZ6anBKHy53afuOB2IUwQ3bYLnXcsRE6ttdK/De3yg5c9azPy7vdxwP29t/2Dh3pUQoPEOL8G9MdNWQi7HcguCKQfSniAzdGRrIeHVrvy6s/ad3rY78bM0UjniS0pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786678377; c=relaxed/simple;
	bh=Z+qUZ2/QZfjQzbzkC1Nskeir3EHCBE9+fKO5fH9StUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QMYwYZkITQsoCLHyrilaEv4fCn+CzIC7bXMO6akHR2pADFVlKl5wrHxYS1xSVb1taRGr5GGE8ix7HiOvWNbakS3EGYFdQSckT1isL4xbVu+HI4pxbYYouTvocG2L05IRM1WcycvVWuhxUFDyRNlD5dHOyO20KRWXtqJnnrQGWX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=I/3VMxRb; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="I/3VMxRb"
Received: from macsyma.thunk.org (pool-173-48-113-153.bstnma.fios.verizon.net [173.48.113.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 67E3W4qX006489
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Aug 2026 23:32:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1786678327; bh=joqcp92gnPzEO1cqfgR/0QvWYSXaXn3+y5nF0VSOUnU=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=I/3VMxRblbSXA0YFieC8zALB4MXTA3tKu6xHcadg/zIshcW7qlCN9P1zVyxOOx2VB
	 NEZX6i3zLQk1+F5JZ2t7sLnPTH6OYQPVlRaPtZC4v1mzf+asvN2Iqo3SXc6SStfbtT
	 ocCjIAYfLEDFn4nEHN6ircw/X+FQ3RqE+ONCniaThLYNbg5AuVnelbYwaR1qpYhSXI
	 xi4GLqOL0hhOOJnjK4cgPbCi8i3kh0sKO9uQDMtkhkOciFf1a3ANU2MEfYEImo/Hf4
	 bPOmjgYQuN0jyQfG96Z+hKI3A1/G1H2sYXJRN2ISQMeFAl3dH5566HQErEeiqiq7h8
	 zLa5yQEsSomqA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id CB7ECEE8A1B; Thu, 13 Aug 2026 23:31:03 -0400 (EDT)
Date: Thu, 13 Aug 2026 23:31:03 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: pipishuo <1289151713@qq.com>
Cc: adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
Message-ID: <an5_shcksPF6uIaW@mit.edu>
References: <tencent_321031C6B9D5D092C8978B46D9F0BBA18607@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_321031C6B9D5D092C8978B46D9F0BBA18607@qq.com>

On Thu, Aug 13, 2026 at 04:33:57PM -0500, pipishuo wrote:
> After a failure in the route ext4_restore_inline_data ->
> ext4_create_inline_data -> ext4_mark_iloc_dirty, the inode will still
> be considered as having inline data.

How did you run across this?  Was this something that was actually
happening?  If so, what was triggering the error?

Or was this something that was found via AI?

I'm fairly sure this patch was created using AI.  This useless
inclusion was a bit of a tip-off:

> +#include <asm-generic/errno-base.h>

As far as the fix is concerned, there's a much better way of
implementing the functionality in ext4_restore_inline_data(), which is
to just capture a copy of the inode (since the inline data is stored
in the inode), and if we need to back out a failed conversion in
ext4_convert_inline_data_nolock(), we can just copy the old contents
of the inode back in place.

We can also do the conversion in a much safer way, by allocating the
data block first, and writing a copy of the data to the data block,
and only if that is successful, do we update the extent tree or
indirect block mapping in the inode.  Of course, this would require a
rewrite of ext4_convert_inline_data_nolock(), but this would allow us
to fix up the other aspects of the error handling which is not quite
right.

						- Ted
