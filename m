Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B373F789D;
	Wed,  1 Apr 2026 12:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.171.160.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775047853; cv=none; b=JRyxgez7TNwtXEzDMTsrBlA1qHEMWaidnGEWbM8ak+M62t+6vLn/5xhyzb3uKGthFBv6jGTW7vVs5l6P31sKeC3bbHKLUXaJJxFHLo9fXLLomit9ZcCkqfc3Ue+MLPtOaalM2D4FP3VkbE7traeGlpGGdfjoAhI8pGloot4Xfj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775047853; c=relaxed/simple;
	bh=BsLij+Inir+eVqCujpIoZfmvsH+pSeSH1zmE+upHFa8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hjOsBQOgfvBrXmNKSyj8XdBJTmVrhbFFlz4kbMKtqi1e/AJWS7eYfBlAdOZHEqio6wFwAzKQXOTYlAD0GEdLe/sD6NMnxul6ZkEaorJGLMbG00eSahl4RO/QF++EPzDh5/Tp5H/i8wRAEnR0kOg0/axbstAKEuUAZDwRDkinXEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp; spf=pass smtp.mailfrom=parknet.co.jp; dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b=dqJQ7ruY; dkim=permerror (0-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b=KdnBEHm+; arc=none smtp.client-ip=210.171.160.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b="dqJQ7ruY";
	dkim=permerror (0-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b="KdnBEHm+"
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
	by mail.parknet.co.jp (Postfix) with ESMTPSA id 24E7B26F7689;
	Wed,  1 Apr 2026 21:50:43 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114; t=1775047843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RPBKhpUGjbLqOjWvgyGXvIWOd2G5DG6+OKURw8r5aLw=;
	b=dqJQ7ruYdeTaqITPpRQwovMgoXJZ//3rBhfHEUSXZntxLfEOaeiYcGiQUlShaVrh+6Y/C1
	cXCtW+2x8iNBS+HhYDZf5uwKex/VghtmyYQIpNi3pnmPBCS/dHVsShuFLVen+q71uOPSHp
	BbuzlxZwTnPUo0xyp67UBqN++fojFVt+xCWgW3n4TYAx+ZFpJlmGZKSo4YAaWC5ln8nz/9
	dqoaw+wJ6rRfwxZbc1XkdN61C8TX5HXOH2vrM2FEutEOJuT9fNG+bM3dw2w8k5N42NXZ6p
	4dYp6/2f9q7dBNZOuR0Q/14mHKwaQiLCreBNi7hj8e1ukp4S4UU9Tu7tJ77pTA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114-ed25519; t=1775047843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RPBKhpUGjbLqOjWvgyGXvIWOd2G5DG6+OKURw8r5aLw=;
	b=KdnBEHm+ZL35BY6ZddX41t3UtdD8vFGWCtWTzqWFFxQfI/Z1PMRw16SdSTOVgUcbO7Yi/b
	nuCfjQXN3PMGuiAA==
Received: from devron.myhome.or.jp (devron.myhome.or.jp [192.168.0.3])
	by ibmpc.myhome.or.jp (Postfix) with ESMTPS id A77B4E004BB;
	Wed, 01 Apr 2026 21:50:42 +0900 (JST)
Received: by devron.myhome.or.jp (Postfix, from userid 1000)
	id 93D6622001D9; Wed, 01 Apr 2026 21:50:42 +0900 (JST)
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org,  linux-block@vger.kernel.org,  Christian
 Brauner <brauner@kernel.org>,  Al Viro <viro@zeniv.linux.org.uk>,
  linux-ext4@vger.kernel.org,  Ted Tso <tytso@mit.edu>,  "Tigran A.
 Aivazian" <aivazian.tigran@gmail.com>,  David Sterba <dsterba@suse.com>,
  Muchun Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,
  David Hildenbrand <david@kernel.org>,  linux-mm@kvack.org,
  linux-aio@kvack.org,  Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 15/42] fat: Sync and invalidate metadata buffers from
 fat_evict_inode()
In-Reply-To: <dvo2jvc6upmzrgqxx3n6er3e2gvujheongtzkihzmllwxqiyuq@h3qrrnwxlwo4>
References: <20260326082428.31660-1-jack@suse.cz>
	<20260326095354.16340-57-jack@suse.cz>
	<87ldfazqo2.fsf@mail.parknet.co.jp>
	<3oh5cbnm6dwz6rikc6laably5nvu4c4wtxjqzuu3wymzhpqrtw@skopu327hd7a>
	<87jyutwo6o.fsf@mail.parknet.co.jp>
	<mjraa5thsnzchejoomqgiahwajx4cs5ryqnmn7zsi3fylzhrrr@5ip65jcrlknn>
	<87wlyss2ny.fsf@mail.parknet.co.jp>
	<gkwyh4z45xglmq7jmam4yfvkecivipr23trzjkbyfolm6pdzre@d5huocjf55ew>
	<87tstvc90b.fsf@mail.parknet.co.jp>
	<dvo2jvc6upmzrgqxx3n6er3e2gvujheongtzkihzmllwxqiyuq@h3qrrnwxlwo4>
Date: Wed, 01 Apr 2026 21:50:42 +0900
Message-ID: <87pl4ideu5.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jan Kara <jack@suse.cz> writes:

>> Hm, metadata block is shared by several inodes. So earlier flush
>> makes fewer chance to combining multiple dirties.
>> 
>> For example,
>>   create dir-A
>>   reclaimed and flushed dir-A
>>   add new entries to dir-A
>>   lost chance to combining re-dirty of dir-A
>
> Yes, but for this to be possible you would have to:
> 1) stop using dir-A between dir create & file creates
> 2) create enough memory pressure to cycle the dentry of dir-A through the
> LRU and reclaim it
> 3) continue memory pressure to cycle the inode for dir-A through the LRU
> and reclaim it
>
> So the amount of work that already has to happen to trigger flushing of
> a single block is so large that IMHO that flush will be lost in the noise.
>  
>> >> Anyway, with it, reclaimed
>> >> inode metadata will be flushed forcibly and frequently (yeah, may not be
>> >> significant though. but I can't see the benefit for users from this
>> >> change.), and lost to chance combining multiple time of dirty while copy
>> >> many files.
>> >
>> > The benefit for users is 24 bytes saved for the majority of inodes that are
>> > there in the system - all the virtual inodes on sysfs / proc filesystem,
>> > all tmpfs inodes, all XFS inodes, all ext4 inodes when using journal (once I
>> > optimize ext4 code a bit), etc. So actually quite a bit of kernel memory
>> > saved in common configurations.
>> >
>> > Another win is that with metadata buffer head tracking now separated, I can
>> > modify that code (which will require growing the tracking structure) to
>> > properly track buffer head containing the inode and flush it on fsync(2).
>> > Currently there's a race that if flush worker writes out inode before
>> > fsync(2), then fsync(2) does not writeout the buffer containing the inode
>> > at all and thus data is not really persistent. This is actually my initial
>> > motivation for this refactoring since growing inode for everybody to fix
>> > data consistency issues of FAT/ext2/udf isn't popular these days...
>> 
>> Agree, it is good.  I'm only saying about the flushing earlier. To
>> implement it, is the flush earlier really necessary?
>
> Yes, to separate metadata buffer head tracking into a separate structure we
> must remove the handling of buffer head list from generic inode reclaim (as
> the filesystem has no way to provide the separate tracking structure there).
> Of course we could add a filesystem hook to inode reclaim to allow for
> handling of metadata bhs but:
>
> a) I'd rather do that in a way that is usable also for other issues
> filesystems have with inode reclaim as I mentioned in this thread before
>
> b) I don't think it's warranted for FAT etc. at this point as I don't think
> the possible overhead of metadata bh flushing on inode reclaim will be a
> problem in practice.
>
> But of course we can reevaluate if my gut feeling is wrong and someone
> comes with a workload which significantly regresses due to these changes.

OK.  I'm still thinking we should go the way to reduce the amplification
for performance and storage lifetime if possible, not increasing.

However discussion looks like enough for us, and looks like we just
voted to different priority.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
