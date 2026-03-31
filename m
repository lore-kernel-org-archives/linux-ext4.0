Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13903A4F2F;
	Tue, 31 Mar 2026 10:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.171.160.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774953614; cv=none; b=Kd053Mtwu3wi+MueAktbCh3fk3or/zeMUFmi/TtQOPFs1nEcsxORY2h1HnJjdrF/FRKIKojQ+wucQzpHWU1negkW9zpiKkEEq0byeuWT/leBMEJSQIryOwFeNvhizLdoxn+hqa+RoDlrfpfTplfoGt/JAJyr7xP+IPUocy+Ogtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774953614; c=relaxed/simple;
	bh=9Nx9On3/A9yUpOPmBiwI3EzprmI9bCiG/OLT9iVkg94=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SdCHvKJNKGOlcKElxDfljBlw4ch8EyNVf8RdLV0ZugzBJn5LCgebo03d5IXL1R8j2j6/i6RqDnn116UhvHIqUAWIJDcgYhWV7gy0ojjjQGo2GKFdc04Cgt5FhBvcmTdy73XIGEGaq6UZ+H5frkfgzH7kE3kBBzkwwmuYXZ63Bdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp; spf=pass smtp.mailfrom=parknet.co.jp; dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b=RGXImBG9; dkim=permerror (0-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b=IkV85c1b; arc=none smtp.client-ip=210.171.160.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b="RGXImBG9";
	dkim=permerror (0-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b="IkV85c1b"
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
	by mail.parknet.co.jp (Postfix) with ESMTPSA id 779F226F7689;
	Tue, 31 Mar 2026 19:40:02 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114; t=1774953602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o61ziz1K7RE+vfkx01/BqKbiM2DvTc1gWIWpdSZJsrk=;
	b=RGXImBG9OkkmJqMaygJ7AQDGsKzIQl9abCecZ1Urgp/oZ2yiBvcZeoE7CFuE+/kvV+iN6D
	U4swsphXGmlc5MObWhkYovizM+FxkoO6U2EEfzujW5BqBtiQ0r/J752mOChnK4gJbLR1dD
	1VUSlKrbZJpn48cr/6Z/ap3ks+R41GUVNedpzkFQCJe04B0BLknTNOOiimUB7JUPB+SQ/N
	4X6OBt/0Ut5bSz7MyVLy+TgrTD28bKJcZgC7ik/AyOmHECVjUd9Vv439R9htdHSYnn55Lv
	bCx5WQtQ/S9RUkvZ1CIEdGRCrYI8pxGW0DbfMNG8k94uebjKG5i/Rptypu+OKw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114-ed25519; t=1774953602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o61ziz1K7RE+vfkx01/BqKbiM2DvTc1gWIWpdSZJsrk=;
	b=IkV85c1bt9eSNB1ACUrhM1X1oZJQ7QVVMbbvnBOLSwK7ls9q0Ga6u2jMZrt3U7fvRHGRKO
	E6TPZwycQpL0rOBA==
Received: from devron.myhome.or.jp (devron.myhome.or.jp [192.168.0.3])
	by ibmpc.myhome.or.jp (Postfix) with ESMTPS id 04458E00CC9;
	Tue, 31 Mar 2026 19:40:02 +0900 (JST)
Received: by devron.myhome.or.jp (Postfix, from userid 1000)
	id EABA92200056; Tue, 31 Mar 2026 19:40:01 +0900 (JST)
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
In-Reply-To: <mjraa5thsnzchejoomqgiahwajx4cs5ryqnmn7zsi3fylzhrrr@5ip65jcrlknn>
References: <20260326082428.31660-1-jack@suse.cz>
	<20260326095354.16340-57-jack@suse.cz>
	<87ldfazqo2.fsf@mail.parknet.co.jp>
	<3oh5cbnm6dwz6rikc6laably5nvu4c4wtxjqzuu3wymzhpqrtw@skopu327hd7a>
	<87jyutwo6o.fsf@mail.parknet.co.jp>
	<mjraa5thsnzchejoomqgiahwajx4cs5ryqnmn7zsi3fylzhrrr@5ip65jcrlknn>
Date: Tue, 31 Mar 2026 19:40:01 +0900
Message-ID: <87wlyss2ny.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jan Kara <jack@suse.cz> writes:

>> >> Hm, why do we have to add this here? For FAT, if buffers are still
>> >> dirty, buffers will be flushed via bdev flush?
>> >
>> > The reason why I've put sync_mapping_buffers() here is the following
>> > sequence:
>> >   fd = open("file")
>> >   write(fd)
>> >   close(fd)
>> >     - now data gets written out, dentry & inode can get evicted from memory
>> >   fd = open("file")
>> >   fsync(fd)
>> >     - this should flush all dirty metadata associated with "file" but if we
>> >       didn't call sync_mapping_buffers() during inode eviction we wouldn't
>> >       have a way to do that.
>> >
>> > So in general I think sync_mapping_buffers() call is indeed needed.
>> 
>> Hm, it looks like not new issue, isn't it? Why we have changed now in
>> this series?
>
> It isn't a new issue. But so far inode_lru_isolate() was checking whether
> the metadata buffers list has any dirty buffers and if yes, it skipped the
> inode. So inodes with dirty buffers in this list could reach .evict method
> only for deleted inodes or during unmount and either case makes above
> problem impossible to happen. This is however a layering violation (generic
> inode handling code shouldn't care about details of buffer heads) and as a
> result it makes it difficult to abstract the metadata buffer handling this
> series is doing. And all this for a handful of filesystems which,
> honestly, aren't used in performace critical settings.

I see, I could understand why you wanted to change though. However, (in
my thought, this change has disadvantage by below reason) changing this
behavior because of layering violation is not good way, IMO.

>> It is including trade off write amplification vs reliability (i.e. may
>> not call fsync()), for example. So I think we should not add it easily.
>
> I expect in practice you'll hardly be able to observe the difference as
> inodes usually get quite a while to be reclaimed at which point the dirty
> buffers would be already flushed by background writeback. I don't see how
> this change would lead specifically to "write amplification" - that would
> mean frequent redirtying of the same metadata buffer of an inode
> interleaved with frequent reclaims of the inode and I don't see how that
> would happen in a realistic setting.
>
> If someone comes with a realistic workload which would suffer significant
> regression from this change, then of course we should address it. I have
> plans for adding an interface for filesystems to expose the information
> that inode has some pending dirty metadata and a way to flush them from
> flush worker because that is a common need a lot of filesystems has and
> doing the flushing from .evict isn't always doable due to locking
> constraints.

I think it would happen with normal operation, for example, copy many
files more than total memory. I think this would be much common than
write=>close=>open=>fsync in your example.  Anyway, with it, reclaimed
inode metadata will be flushed forcibly and frequently (yeah, may not be
significant though. but I can't see the benefit for users from this
change.), and lost to chance combining multiple time of dirty while copy
many files.

> I'm still thinking about details but this has to be a properly
> abstracted interface all filesystems can use and not a special hack for a
> handful of old filesystems.

Sounds great. How about we delay this behavior change until this
interface?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
