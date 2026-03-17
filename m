Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28DC3CD8AC;
	Tue, 17 Mar 2026 13:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773755643; cv=none; b=gZXG5tXIioFMD/jFq+LNb0HhQhCPX2UOqPI2x2kthSWiHtjC+yozhxR/pEUM2nl0dhZ8b9lcbZWRf6KNHRjfNOgqTZsMwnAaDqd1n3rjpumkt7h2Xmj3TtdakPrJeN3eEmFfRfapOYWRmtMG0oIQdFzZ8Np1B8F8OkP5VZJNeL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773755643; c=relaxed/simple;
	bh=LJ9TJsHzw3L9Xu55TCPkqfykOgJsXXURBVYZvyFKx7E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H5n23YkyeQtSrAVZJwwVrlYtOsnp/kQ7rXrx9LLbUn4xqSmxSLABiI+F6rZgtTC5Uzc0CkyoQhr8AZ4+uhtJFXjS/GX0rYhK0C9TrU/RozF28g5yc4RkI0+TWxgAqi8LfBN4XXS5dcOI+pg5C3/DZc2a30o/ETLbTrBTwE5dYFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=bqVDSwkM; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="bqVDSwkM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=8DzbUUpiltHLtFn+rbiARRaD8w+RtKX12xhZlS2MWNo=; b=bqVDSwkMZFbXT4jvVzyEO73eJg
	YP1ViDNkNts9OBUIpYunzSOoFUkLkfagftPpj7+VGx/vGEdZ6B/Tap4pQ6n2oViBgPTOUuXey8UXn
	TR5VpyB3vOLafvbcmlPrNBE22legHEUm9KQxmqmKd2S2VD8gaRfzc7H1tEXnuC6ZvHiVGOEdwKeSj
	8DTVg4Y1Wnmd668h/VhDlSrtGkun8urfgvCFZWN3D3OkjqhveL5tP/9ECpBRLg/USrU2PxmIvqIXj
	Za5o4wxObHsyKbrlyzr2U99L3/nSljG6OkzjOEwo9dXHXhWQ4/gix01P28b8Zh0a1RGmcpg1MpC/I
	VqeAlztg==;
Received: from [189.115.10.45] (helo=[192.168.68.133])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1w2Urp-002IgB-Fk; Tue, 17 Mar 2026 14:53:53 +0100
Message-ID: <1bab1298-7814-41a1-8741-b60999aeae42@igalia.com>
Date: Tue, 17 Mar 2026 10:53:49 -0300
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: fix bigalloc cluster arithmetic when
 s_first_data_block != 0
To: Theodore Tso <tytso@mit.edu>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-dev@igalia.com, syzbot+b73703b873a33d8eb8f6@syzkaller.appspotmail.com
References: <20260313151835.1248953-1-koike@igalia.com>
 <20260314012930.GB38016@macsyma-wired.lan>
Content-Language: en-US
From: Helen Koike <koike@igalia.com>
In-Reply-To: <20260314012930.GB38016@macsyma-wired.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ted,


On 3/13/26 10:29 PM, Theodore Tso wrote:
> On Fri, Mar 13, 2026 at 12:18:30PM -0300, Helen Koike wrote:
>> On filesystems with bigalloc enabled and s_first_data_block != 0,
> 
> This is never supposed to happen; fsck already checks for this.  From
> e2fsck/super.c:
> 
> 	should_be = (sb->s_log_block_size == 0 &&
> 		     EXT2FS_CLUSTER_RATIO(fs) == 1) ? 1 : 0;
> 	if (sb->s_first_data_block != should_be) {
> 		pctx.blk = sb->s_first_data_block;
> 		pctx.blk2 = should_be;
> 		fix_problem(ctx, PR_0_FIRST_DATA_BLOCK, &pctx);
> 		ctx->flags |= E2F_FLAG_ABORT;
> 		return;
> 	}
> 
> You can also see evidence of this code path getting trigger by
> clicking on "corrupt_fs" in the Syzkaller dashboard.

I see, thanks for the pointers.

> 
>> Introduce four macros that subtract s_first_data_block before
>> operating, matching the coordinate system used by mballoc:
> 
> This is *way* more complicated than it needs to be.  All you need to
> do is just reject the mount if the file system is this insanely
> corrupted.  For example:
> 
> 	if (ext4_has_feature_bigalloc(sb) &&
> 	    es->s_first_data_block) {
> 		ext4_msg(sb, KERN_WARNING, "bad geometry: bigalloc "
> 			 "file system with non-zero first_data_block");
> 		return -EINVAL;
> 	}

Agreed. I thought it should be supported from [1] but I missed [2].

[1] https://lore.kernel.org/all/20130221134943.GA3818@gmail.com/
[2] https://lore.kernel.org/all/20130222030327.GB3421@gmail.com/

> 
>> Regarding the issue reported by syzbot...
> 
> Yeah, this is why I generally don't pay that much attention to syzbot
> reports that mount a corrupted file system.  Users are supposed to run
> fsck on a file system before they blindly mount it.  If they don't, I
> don't consider it a security vulnerability; it's just a stupid system
> administrator trick, and he or she deserves everything that happens to
> them.  Hence, such issues are not a security issue, but just a quality
> of implementation issue.  I'll accept patches to addrese sorts of
> things, but it doesn't rate a CVE or high priority processing.

Make sense.

I think I'll submit this patch as per your suggestion since I'm already 
looking at this, but I won't bother you further with these sorts of 
low-priority issues.

> 
> Furthermore, any fix needs to as simple as possible, and avoids adding
> extra overhead especially on hot paths.  In this particular case,
> rejecting the mount is the simplest fix, since the file system
> corruption is *easy* to detect.

Ack, and thanks for your reply!

Helen,
Cheers
