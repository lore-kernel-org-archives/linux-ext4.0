Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B59A3E7145;
	Thu, 24 Sep 2026 07:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790236214; cv=none; b=Ft4aa8AUGscBSnHmyy3+PeciFwIAXqfa6moFSsrsmV8eAzx2f7xhPimbz/23QDX5dOUlg8nfAnmmqyKK3v5nZqJFIb7g+Hsar+/p5nTGag2L4UOTbFslLFMr1n4jOScEzcENxwjUkLNI7ZPJZg8RRjpbHQo8ZwanHVPVh8vpbhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790236214; c=relaxed/simple;
	bh=Qj0te7eGJQSqezg4WUh94TJNtvGrDCfxRYklUhsZl7s=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=W3gxGwOfV/Zva70H/a5/XGMFrChlClBQPvqCVjqx/1xJWzpZx+FSAAmsFCcxO5U4h0UXfpbDq34jdxnCMFs7UWvlUx4pdY9irRe9No6SC+dSxaytmnYTn46Jw+ZRNgT7drKrmS5aHFcE7Zfha7eUfAIBILSQhD2+B1u1YgKCBG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eRT+7H9A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eRT+7H9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D691F000FF;
	Thu, 24 Sep 2026 07:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790236212;
	bh=XDvywVc6Ep1SuVeW2SGy85kW0rD7YUN5EGSklkhHzQk=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=eRT+7H9ABPwFjh7BVERhP8cozvQ4MQhStKNB7IRvgfIVy1HpxDFA1S9CLNaBl5pzI
	 KbWjS+JLXuC1wfFOu3O1kKNSLzYoFlGe7Tv2kGJimLChc4ZoVJCdySlQ6e/Tz0sL1D
	 U0iYGLcnxGjb2dU5iqN0HCoSkRnXP9Xme2baHRJ40E4KIM8t0wkAmMfPUSppRNQrim
	 DTNpz+zdjksrk7NtzRiTQlySjLsTl2p+yx+bYXTEnPJmuk8zk0/jV46rM7nWCxR/1h
	 T2pphZq6jbBIsqIE5qVV+FHA7Q1fgJbsv1XCiH44gQdnf98X4nCMENM2ur68i1YPoB
	 mW+MzuRrfmFrA==
Message-ID: <08bbb615-a054-472c-9873-787cc0f7a4d7@kernel.org>
Date: Thu, 24 Sep 2026 09:50:02 +0200
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] [ext4?] WARNING in __folio_set_anon
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Lance Yang <lance.yang@linux.dev>, ljs@kernel.org,
 akpm@linux-foundation.org
Cc: harry@kernel.org, jannh@google.com, liam@infradead.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, riel@surriel.com, syzkaller-bugs@googlegroups.com,
 vbabka@kernel.org, syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
References: <6ab4ae75.80e1c6cc.1e8e5f.000d.GAE@google.com>
 <20260924065458.49698-1-lance.yang@linux.dev>
 <0a0a07f8-8ac9-4d75-b4c6-c403865f0be9@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0a0a07f8-8ac9-4d75-b4c6-c403865f0be9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/24/26 09:43, David Hildenbrand (Arm) wrote:
> On 9/24/26 08:54, Lance Yang wrote:
>>
>> On Wed, Sep 23, 2026 at 10:00:37PM -0700, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    38872197cae2 Merge branch 'for-next/fixes' into for-kernelci
>>> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=17a44d25580000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=56ed23170c168d4c
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=c181d3198e98f8aef8b9
>>> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
>>> userspace arch: arm64
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a36515580000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16dcf4c9580000
>>
>> Looking at the repro, emm ... the repro maps an O_RDONLY /dev/zero fd with
> 
> Does this trigger upstream or only after Lorenzo's rework (not upstream yet IIRC)
> 
> 46827ac1ab221 mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous
> db7438ea23180 mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous
> 54e8e096ea86b mm: implement file_is_dev_zero() to uniquely identify /dev/zero
> fb24843cfd9eb mm: move drivers/char/mem.c to mm/char-mem.c
> 
> I assume it triggers upstream. Does it also trigger with lorenzo's changes?
> 
>> MAP_SHARED | PROT_READ. do_mmap() clears VM_SHARED and VM_MAYWRITE, so
> 
> Clearing VM_MAYWRITE for a private mapping is odd. Can you point me at the code
> that clears both things?
> 
> I assume we still have the file pointer, and as the file is read-only we remove
> VM_MAYWRITE. But why are we removing MAP_SHARED? (where?)

Looking at the code, it's the

	if (!(file->f_mode & FMODE_WRITE))
		vma_flags_clear(&vma_flags, VMA_MAYWRITE_BIT, VMA_SHARED_BIT);

So we end up with VMA_MAYSHARE_BIT but without VMA_MAYWRITE_BIT and without
VMA_SHARED_BIT.

So it's by definition not a COW mapping. But it's marked anonymous and confuses
the system :)

-- 
Cheers,

David
