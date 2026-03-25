Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20EA3EAC88;
	Wed, 25 Mar 2026 15:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774451202; cv=none; b=t7Akrtu0bcd4zNozc2LT/a2RcBnIFNk6K3fccLrbmhPhrEG1LEH/r/C58N+tp7qaFuivzPbja9kZd3B+LHprCmJGV7yXj91o/nF9dT//vWlwfNgz4ct3ctqVksNI7LDcbfdrZgANwi+3wlcZykoOaWTQYMAxu5BHjIxXS+GpAO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774451202; c=relaxed/simple;
	bh=abjIJLR7w82rkCffSg5vDwCkeaoGvkn81T+GGKFIJeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DgkVfdfkqYqrjaMP0Ea4LqASK7xgQq4sz5xb9K+551HanIdS+z8cRCfUDBg40Ow1L9S4PSw7Mkas6qHadPOTf9PUjp9WMqW8Gc76u+/rVsVDwh2XdaWdR/Oa706NX+KQPCAyimo10egIgVO/q/MXSQDhKlvJHnI/TBspM72XLMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZZt0Yymr; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZZt0Yymr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cYXwyEMIc1ILNL2kDIuCLRrloFnkyAEPOIgK7nUnE1Q=; b=ZZt0YymrAGmGOAlCDew140Csby
	Sqro/tJ1OLbP+0eCHxcuBsYQLcChXM3MKErmu8pWHq3e6cRwelDRiiVEbe/qOrEd+lzp5XvGs6cJT
	NgnQCqOVoPkR4GWJhlzCOIZTar/5gg3Mo6kztithAhgAcbIEeThPm6IiKFzcrr2dMV3hV3dAxC1A1
	hsCnaj6JDcdfpDOi+9LobAF5PIpRY5gaV6IUqI2yYcLIAAGneQXbB3eXTKTcT01MmaZyhaDdM5Dqw
	/CFhoLcKrzZMWMYw3tWja4X2i/kSk12PeVu4sM27yu5JQzMgcY99A0mrIx8/KN+hUQTRFuMEmkDL0
	3h7pPLDQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5PoY-0000000G2du-1PBr;
	Wed, 25 Mar 2026 15:06:34 +0000
Date: Wed, 25 Mar 2026 15:06:34 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Diangang Li <diangangli@gmail.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, changfengnan@bytedance.com,
	Diangang Li <lidiangang@bytedance.com>
Subject: Re: [RFC 1/1] ext4: fail fast on repeated metadata reads after IO
 failure
Message-ID: <acP5-v85CwUQZlMB@casper.infradead.org>
References: <20260325093349.630193-1-diangangli@gmail.com>
 <20260325093349.630193-2-diangangli@gmail.com>
 <B53E253C-F314-4376-BD9D-58867FC8D3F6@dilger.ca>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B53E253C-F314-4376-BD9D-58867FC8D3F6@dilger.ca>

On Wed, Mar 25, 2026 at 04:15:42AM -0600, Andreas Dilger wrote:
> On Mar 25, 2026, at 03:33, Diangang Li <diangangli@gmail.com> wrote:
> > 
> > From: Diangang Li <lidiangang@bytedance.com>
> > 
> > ext4 metadata reads serialize on BH_Lock (lock_buffer). If the read fails,
> > the buffer remains !Uptodate. With concurrent callers, each waiter can
> > retry the same failing read after the previous holder drops BH_Lock. This
> > amplifies device retry latency and may trigger hung tasks.
> > 
> > In the normal read path the block driver already performs its own retries.
> > Once the retries keep failing, re-submitting the same metadata read from
> > the filesystem just amplifies the latency by serializing waiters on
> > BH_Lock.
> > 
> > Remember read failures on buffer_head and fail fast for ext4 metadata reads
> > once a buffer has already failed to read. Clear the flag on successful
> > read/write completion so the buffer can recover. ext4 read-ahead uses
> > ext4_read_bh_nowait(), so it does not set the failure flag and remains
> > best-effort.
> 
> Not that the patch is bad, but if the BH_Read_EIO flag is set on a buffer
> and it prevents other tasks from reading that block again, how would the
> buffer ever become Uptodate to clear the flag?  There isn't enough state
> in a 1-bit flag to have any kind of expiry and later retry.

I've been thinking about this problem too, albeit from a folio read
perspective, not from a buffer_head read perspective.  You're quite
right that one bit isn't enough.  The solution I was considering but
haven't implemented yet was to tell all the current waiters that
the IO has failed, but not set any kind of permanent error flag.

I was thinking about starting with this:

+++ b/include/linux/wait_bit.h
@@ -10,6 +10,7 @@
 struct wait_bit_key {
        unsigned long           *flags;
        int                     bit_nr;
+       int                     error;
        unsigned long           timeout;
 };


and then adding/changing various APIs to allow an error to be passed in
and noticed by the woken task.

With this change, the thundering herd all wake up, see the error and
return immediately instead of each submitting their own I/O.  New reads
will retry the read, but each will only be held up for a maximum of
their own timeout.
