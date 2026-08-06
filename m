Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28994570DC
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 14:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786027815; cv=none; b=koEXbD8Y4HWb7NGl7TtEOPQ6m6tAAvw0MyHs1+Su5yCNt4hxN7fbPgjk/3e2GOi9I0CfLaQ6OSIInRLcH0/qXxSA5J3/Cd141QzHbv8a/RDQNTaKtNlc03f1/JBElQIhBkxAlmGNcKZDde+JW3F9DQPDCarA+t2ExXRqKO2nmsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786027815; c=relaxed/simple;
	bh=dXZhymFdLV6f9U6vCMNmyvNWYgBrR8XoBqRIbYUq6P8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AuROzej3dfM3kVFNV7hWjaRF5b/RyA2e9G/nJ13HCf6aJY0dk7ECAdRCgrbmF4zJbyrv0x1elTXyBx+gW9bqXL+VFIhoS/QYMONKoBYgA5vWSmPFYzYTWjscHs66K0EUNaiqUWBDudeqIK8WmGix5G5SZqoqJHdHW2Aqhy/lKwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=PQO/g/+7; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="PQO/g/+7"
Received: from macsyma.thunk.org (pool-173-48-113-153.bstnma.fios.verizon.net [173.48.113.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 676Enlb6005621
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 6 Aug 2026 10:49:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1786027790; bh=Wg+x9ugAtVNnxI6tJIxGWRDqavJRSNTa7fDhGsAtJ04=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=PQO/g/+71CdsFxh/f1goi6GoakN0LVebIfqdNmkT9NtzC7elK4N61mbWhKFkwnyDJ
	 ynF9DX4R4fk89dCibL5RMPXJu2fW3JX7HA0Qqg30Ys17U6IyYbavEB1wnoV/GNQdAS
	 ck3iU6DBJcSLGgjsIqiUQPQlxwcUusCcQyZ9BjOslUMa4h8VHMQkELlCkTEScQb2NO
	 dZaucZG4zwCCKGKCoOvUdykBNPnmPEYysF/2VPvnUv3fAA7I0GohmhGoiVLpUg7Yuk
	 vZcnuL5OKaIM3+j1dQ3GY2bMrVvNIRepFKRmjZgE0X6x52SnzKDmX+1L2weoLHMZMj
	 04wGExZLbkDRg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 9D223DC4480; Thu,  6 Aug 2026 10:48:47 -0400 (EDT)
Date: Thu, 6 Aug 2026 10:48:47 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>, linux-ext4@vger.kernel.org,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: [PATCH] ext4: Avoid entering writeback paths during fastcommit
 replay
Message-ID: <anSeKuPHikw2UxRt@mit.edu>
References: <20260804104112.93202-2-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804104112.93202-2-jack@suse.cz>

On Tue, Aug 04, 2026 at 12:41:13PM -0500, Jan Kara wrote:
> Fastcommit replay effectively happens in nojournal mode. This results in
> ext4_mark_iloc_dirty() setting I_METADATA_WRITEBACK flag and as a result
> we end up entering filesystem writeback functions. However during
> fastcommit replay s_writepages_rwsem isn't initialized yet and hence we
> crash.
> 
> Fix the problem by avoiding setting I_METADATA_WRITEBACK during
> fastcommit replay. Journal replay flushes the whole block device after
> replay anyway so all metadata is properly persisted and replay is faster

It looks like this patch is only applicable if the patch series "fs:
Fix missed inode write during fsync" is applied, and in fact appears
to fix a problem introduced in "[PATCH v5 17/20] ext4: Fix data
integrity writeout issues in nojournal mode"?

						- Ted
