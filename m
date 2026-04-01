Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530083D7D9E;
	Wed,  1 Apr 2026 09:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.171.160.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775036522; cv=none; b=rEFbfts8mhu5lcunBLpzC3JbZO3PacSMOPn51H6MESetijqy6BzWYXKiu1txdDQ7tQCSQXGdYs/EyV4mRodiRXrRguC600ANmeTNZS52kMAaPyWlCpIaAuTjWA7QNRzDcwReWBHXhnlG2DbxPa9mHead7jMaC7JfGXgMihI8VOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775036522; c=relaxed/simple;
	bh=83Y1I5dL5LBdN7XmV/fLKJrIGJQmPlJbJcP1P76mRa8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pGNHu+DsoqaASpu7fvdOpXq6ah/xvfmLJVJ1pvH/PGMA+hY9hKwARmjttzhFpeXdX9ePJJ6rdzjWoiuz00DnnnW8sz1pWw9iwG1YYw2M3PRzkHjxaJbcs5S0gr9oKXb5gw2JphnbzlMUaxirC6T9UV4sE/dwFztewo7GmRy6c3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp; spf=pass smtp.mailfrom=parknet.co.jp; dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b=xM9SP3IR; dkim=permerror (0-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b=eHL6eK8s; arc=none smtp.client-ip=210.171.160.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b="xM9SP3IR";
	dkim=permerror (0-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b="eHL6eK8s"
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
	by mail.parknet.co.jp (Postfix) with ESMTPSA id 356F626F7660;
	Wed,  1 Apr 2026 18:41:57 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114; t=1775036517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ddob+qWyvKUTgK+fMh/qkqDn+kishBT/6wKfgHgQIl0=;
	b=xM9SP3IR6SCuCSTpNShzzonkoyYx/J/7Y4upeeQeZ3ri/438yMIefO6AT2HeIaOFoFnfPx
	R2W0wkTM1DyHhA9NP8P8H8DdL5qxq6PWVeINCMck/eQXjFDVHqVrTCRF37VBHoKleGUfeJ
	XCuZZd0F11KDnjLJKmyE6yQgddHB7vgJihcQNkeLR+5DTswKT5ZtUIMiV7amrtbjyppzn5
	/EEmrriK/QfgMgJO3Owdx1Q8zxs9kCoib62xsNa0Y2mDds13n6qnszjB4uzsMOxXSku0ec
	jYfCVYxMUPWHNPAIv8qUAuu8uCdkBgie/qO6nb0o38m0S/PrJQF4/WGYC9CL2w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114-ed25519; t=1775036517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ddob+qWyvKUTgK+fMh/qkqDn+kishBT/6wKfgHgQIl0=;
	b=eHL6eK8sp2ZrquHtYTH0cSLXQ/utW4kdMHSr5Ik88ROLy/OlyHFQzSiM96G6KfZX6aVGMy
	7ljbzutsO031msAg==
Received: from devron.myhome.or.jp (devron.myhome.or.jp [192.168.0.3])
	by ibmpc.myhome.or.jp (Postfix) with ESMTPS id B3A96E00074;
	Wed, 01 Apr 2026 18:41:56 +0900 (JST)
Received: by devron.myhome.or.jp (Postfix, from userid 1000)
	id A9EB822001D9; Wed, 01 Apr 2026 18:41:56 +0900 (JST)
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
In-Reply-To: <gkwyh4z45xglmq7jmam4yfvkecivipr23trzjkbyfolm6pdzre@d5huocjf55ew>
References: <20260326082428.31660-1-jack@suse.cz>
	<20260326095354.16340-57-jack@suse.cz>
	<87ldfazqo2.fsf@mail.parknet.co.jp>
	<3oh5cbnm6dwz6rikc6laably5nvu4c4wtxjqzuu3wymzhpqrtw@skopu327hd7a>
	<87jyutwo6o.fsf@mail.parknet.co.jp>
	<mjraa5thsnzchejoomqgiahwajx4cs5ryqnmn7zsi3fylzhrrr@5ip65jcrlknn>
	<87wlyss2ny.fsf@mail.parknet.co.jp>
	<gkwyh4z45xglmq7jmam4yfvkecivipr23trzjkbyfolm6pdzre@d5huocjf55ew>
Date: Wed, 01 Apr 2026 18:41:56 +0900
Message-ID: <87tstvc90b.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jan Kara <jack@suse.cz> writes:

>> I think it would happen with normal operation, for example, copy many
>> files more than total memory. I think this would be much common than
>> write=>close=>open=>fsync in your example.
>
> When you copy a lot of files which are large in total, I agree the flushing
> can be triggered. But I don't think it will trigger any excessive IO
> because the metadata blocks being flushed aren't redirtied after the inode
> is evicted. So blocks may be written out earlier but I don't think they
> will be written out more times. For FAT for example you track only
> directory blocks in these lists so when directory inode will be getting
> evicted, you may see earlier writeout of dirty directory blocks but that's
> all.

Hm, metadata block is shared by several inodes. So earlier flush
makes fewer chance to combining multiple dirties.

For example,
  create dir-A
  reclaimed and flushed dir-A
  add new entries to dir-A
  lost chance to combining re-dirty of dir-A

>> Anyway, with it, reclaimed
>> inode metadata will be flushed forcibly and frequently (yeah, may not be
>> significant though. but I can't see the benefit for users from this
>> change.), and lost to chance combining multiple time of dirty while copy
>> many files.
>
> The benefit for users is 24 bytes saved for the majority of inodes that are
> there in the system - all the virtual inodes on sysfs / proc filesystem,
> all tmpfs inodes, all XFS inodes, all ext4 inodes when using journal (once I
> optimize ext4 code a bit), etc. So actually quite a bit of kernel memory
> saved in common configurations.
>
> Another win is that with metadata buffer head tracking now separated, I can
> modify that code (which will require growing the tracking structure) to
> properly track buffer head containing the inode and flush it on fsync(2).
> Currently there's a race that if flush worker writes out inode before
> fsync(2), then fsync(2) does not writeout the buffer containing the inode
> at all and thus data is not really persistent. This is actually my initial
> motivation for this refactoring since growing inode for everybody to fix
> data consistency issues of FAT/ext2/udf isn't popular these days...

Agree, it is good.  I'm only saying about the flushing earlier. To
implement it, is the flush earlier really necessary?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
