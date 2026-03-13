Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABE12DAFA1
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2026 14:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773412341; cv=none; b=MdOKKqXxvXy5r6QKKwPpsMy5IJwiHA+ANLertaz60Bno7yNnTa4HcfymXljIBG3Bf/8CmLL/HGqZ5WMWS7Qqri52aBjhA7zll7yf//rH+TUAywhvTVOHSSUVes0Qny7235jkuGDwRVQ+j1S1/rjquZJVRthND7Mch/QTeTcmdv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773412341; c=relaxed/simple;
	bh=x9PbsbschYPZsjhTcC/C1cw0uWC+2sVJY8spiTbt5+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=be/bFMuov0MKpA+y1VXoa3r+SHn4q7I4ZoAeJgZKuu59CIci1S7Mjx1Cmr+s/DF2oMcE7mc+BvvXhMiJBIyE5jsTWBnWSe9Hiuffpb2UdCnIBWJVAqTOCsHLK5Q1iVqf7TsxnbVjeO0I5FDBQjixY5DeioagtyKdBu11TgH6Xl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=HDx0wqXM; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="HDx0wqXM"
Received: from macsyma.thunk.org (pool-173-48-82-106.bstnma.fios.verizon.net [173.48.82.106])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62DEW11o013052
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Mar 2026 10:32:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1773412323; bh=zjdy1qdWJI9qZih14ZYU/jLdm5z/Sd8CdpTV1dlf9tc=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=HDx0wqXMRvcd+1M3vVXOWkdUthEEayXYsALytvzA6jZHwYQwGdiMVAMZq9a/x7iUi
	 XcqZhDGE0Sakz9q9BC2EQr2LxXxaodz/PSJQeRMNE0WKouwBRxpY/JPl99JHZSptEJ
	 e0kP2L4e+5r78x8qoYzgnAAkTy+BXf2Gfn//4N+sHluqo9BS5SlPKse4wV6wyPluGA
	 se0Sn7ibljH0m+IotsIO1rFxjNwLk82iOcsqdjoxnBSC+lFOcGMhx/plfhMzmxEhgM
	 pvf6frVrJFqO4cXVujpRBfNx4bRHsDFjTAMBSlthG0syqYOwGRYDC2u8lN6b3i10sn
	 nRbSsLpmlVbqQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 2A44B5D2E294; Fri, 13 Mar 2026 10:31:01 -0400 (EDT)
Date: Fri, 13 Mar 2026 10:31:01 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>, Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [RFC PATCH] ext4: handle wraparound when searching for blocks
 for indirect mapped blocks
Message-ID: <20260313143101.GA38016@macsyma-wired.lan>
References: <20260310122806.1277631-1-tytso@mit.edu>
 <5ce9dfe2-721e-4d20-9bd9-3560aa76888d@linux.alibaba.com>
 <20260312142345.GA4689@macsyma-wired.lan>
 <2a047aeb-6db8-4be9-8908-b12632d5e632@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a047aeb-6db8-4be9-8908-b12632d5e632@linux.alibaba.com>

On Fri, Mar 13, 2026 at 10:00:04AM +0800, Baokun Li wrote:
> IIUC, ngroups/end here only depend on filesystem size and whether the inode
> is extent-based, and both should stay unchanged during block allocation.
> So doing the check once at the beginning should be sufficient. Am I missing
> anything?

The problem here is that case where we use
ext4_get_allocation_groups_count as ngroups and end are different.  In
some places we do this:

        ext4_group_t ngroups = ext4_get_allocation_groups_count(ac);

and in others we do this:

        end = ext4_get_allocation_groups_count(ac);

Now, if start is zero, then these two are equivalent.  But if start is
not zero, but say, is 2**32 - 8, then where we use
ext4_allocaiton_groups_count() as the last block group to search, then
we only will search exactly 8 block groups, and if
there are free blocks in the first 8 block groups, then the scanning
function will fail.

Alternatively, if we just do the check at the beginning, then 2**32 -
8 is a valid starting point, but if we just search forward by ngroups,
then we may end up returning a block group which won't work for
indirect mapped inodes.

Hence, in *every* function where we call
ext4_get_allocaiton_groups_count(), if the goal is to search all block
groups that are valid for indirect mapped inodes, and start might be
greater than 0, we *have* to handle wraparound.

Does that make sense?

						- Ted
