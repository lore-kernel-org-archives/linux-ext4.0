Received: from out203-205-221-236.mail.qq.com (out203-205-221-236.mail.qq.com [203.205.221.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFC65452BE
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 11:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788953435; cv=none; b=mnO/3ISkDo4495xQst1ngltg1rQp0zQKFuG9Kx2aMNsl+j1IVnmJTrkbq08RfCwEdZK5Ac+AiuL6C68JnOq5qPEE+JgQ2X3qKDEP2sbBtxGxWYeUAxpabI1grLjbMOO8/WSv4cr/BtKkwqDcorkJpCXbMyBlietRfQ8RmRX870Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788953435; c=relaxed/simple;
	bh=DnWsisQZ0I2jhiybr0omoIi4HE792mUI+notvcTMRns=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RKcTiqEBiSSr5ACUeljPSyvmjIYRZS4jqAz7SQXveIMgRZ5wrxVFZDoaO/xQS/c2jSYcIPepyU54v2ftnX+5sUv26YciYRnQv11ZMryorH9EogCCz6CJlUoG0XdOvUVbAtcmor1tbQCTa8hzMXELujgAbgqtfByT1rK+GYal+sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=Yh7RaSfw; arc=none smtp.client-ip=203.205.221.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="Yh7RaSfw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1788953428; bh=U4l5lNruRWNxs09yrcip4KY3ukhrmCuR566aGp5teXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Yh7RaSfw2QWp2rjzH3BslMu9iD37qATZZgtV8vy2tjh4GqD80lcum6+EYvILRbkhx
	 DIvilgPwAAhNO1zQBqiZPArI3wdIgZu+iZPqjVD+wlU5UswWf87/fPoMhO9ct3hx6+
	 6JmmSeto0V0zQf7yDz6Gwp+JVYAOzLFuhNDxOICA=
Received: from DESKTOP-AT5F202.localdomain ([223.70.85.160])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 79A2044E; Wed, 09 Sep 2026 19:30:26 +0800
X-QQ-mid: xmsmtpt1788953426tcqbd3e75
Message-ID: <tencent_853282AC6E9460BD1035B287B70CD5852C0A@qq.com>
X-QQ-XMAILINFO: Od8VqZhFMB3NFF3qt0I6AuBaxDmFaDvs0Z/fyAjVWjWDA74838TtfT2I8v6R92
	 tV7QVwpmPLFFC+xeKZRUCXKb2LMG6/klpU2oQ9h22LMRZpE0ExiEuR8HfQQ3L5F+3De9ChpAeNn1
	 iCyNIuqVB9CboM2mCQHcm4MAF/rSO7imjplIJTNKLD9WTJ/Uum/OhHxZfmBJYOe+QTkRAO/Ips+g
	 ndBQ0HYR4ItUqhldruXb9YBTzKvqdDNEsNMoQ6J5Jloj+w8Q/FLK0Yp6h9pwxT8S0a3cgv7BhVu1
	 bnfvc0j/2xI+rmNQXdYKhlXy68WFJL5TEKaRNAdGOdpDgBsL9iRLL5W472Pw60l8Yunxxc76Oc1k
	 tFmnI5aK6VRE4H8A8FuuOsPUKBi6u2ooTNfBzV+R59aQ2vGJG8nA5yHq5g32Dhpy1L7CwhfSh59v
	 ojo5VoEbKe4GWF9ujHPTLJI3q1LrURQSe6bl+0RhsOwH1/BI5t8oq6FjHw5MS/RhA7XU6cSl8oA5
	 827Ep5L2smi+4tGpqQjEWoDM+Rc3QTwzOUvPOgyVskYGbGt74xvsmxHUBZX97zivIozAqu2LbbUX
	 mro+Ev5qPZN9tCgIXx110TuGreOEP0oeUHHxwHnpdO743uVD3letymDt2qdT1JTZs5w7PQQoUCQw
	 r0daqSlk6/2yTBla17m0svsZcl4OTAjcS3a9NZ9/rxQtJhpH/WHKU31QLYnpZAmBL4JJpHmDaxHY
	 cIEVi4fi7vdQZHTjkGzZe0mFw02eS2a5fUzMDW6frPoo1gCzKj02+YUrYfkqxcKeUCUUQIMY8K9p
	 Py5efKTnky3U3V5Wdx1/heFDVuqV9oPfd3HENTkn9OnXK+1EIqnyeXXd6fRro0omEFN1BV3sh5HY
	 6xDUF2+9wxXvUXaSg3jzwL3sEyz7CDT2+lrGzYO5NhegpmVhmu0hsqwj7nU99C2OWGZ22zZj8Tnr
	 g8MGpOzBgNlaIQvhAB4AzAVIHjuxBNSlxPVCUpHcU6so0Sx24Cw2EXUpfNEmrladqkPC/sdQ3grV
	 8nD5dx7qaL94NqSsoumqfopmfnJzc4Xm6//gTnNg==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
Date: Wed, 9 Sep 2026 19:30:24 +0800
From: shuo chen <1289151713@qq.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4:Fix the initial value of not_found in
 ext4_destroy_inline_data_nolock
X-OQ-MSGID: <aqFDUESf20XcC37J@DESKTOP-AT5F202.localdomain>
References: <tencent_CD1AF9C3A7875C42F2187B57D74A1C5EE609@qq.com>
 <r7cnmruhhypvxk32ilopf47mbx4qd6dcdsbari6zwovaerp7gz@a27v6irfx6hl>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <r7cnmruhhypvxk32ilopf47mbx4qd6dcdsbari6zwovaerp7gz@a27v6irfx6hl>

On Wed, Sep 09, 2026 at 12:37:50PM +0200, Jan Kara wrote:
> On Wed 09-09-26 09:12:35, shuo chen wrote:
> > If a file has EXT4_INODE_INLINE_DATA set but lacks the
> > EXT4_STATE_XATTR flag,
> 
> But how can this happen? Inline data is stored in xattrs so it shouldn't be
> possible...
Thank you for your guidance.
when finding xattr, there is no space left. Can this happen?
int ext4_xattr_ibody_find(struct inode *inode, struct ext4_xattr_info *i,
			  struct ext4_xattr_ibody_find *is)
{
......
	if (!EXT4_INODE_HAS_XATTR_SPACE(inode))
		return 0;
......
}
If this can happen, it makes sense to fix the initial value.

