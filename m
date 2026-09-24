Received: from mta1.migadu.com (out-250.mta1.migadu.com [95.215.58.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FF13469EE
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 09:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790242074; cv=none; b=lZNU+ui0yA/u/jqCNpWwa0Mh9biql7f2BR+LBMwPZtFqJJyXQimuj8ee7Dp11hpDHil+0JKpL8K271aesWSzrbQMNOnSf9axV6tfXbU4hEMf+9kt53AvafsmzjQczRIr0IZsRvNt/N7LdOLj0PmrtxzD1LOyC3Ovr8Poy5VnU3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790242074; c=relaxed/simple;
	bh=yQ1JL3OS1DIhfdfcLe4c8iEZGo0TsjpYksuAFp/3C9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m01HeSj+PVwP4NqB9KKeESPHVr4p21pvMLarDns49SyJBJ0Doaq8A/w7u+Ks2xTAWNC6+IC+Q11MQMVkjeWVJqkvqE77K3msG0+WtxjsMLs/NUkkpKluILjQlTTEKFAmhqQb3myxF7VXaV7CDBdwfY+DgF/9RjS3P6op5P6Gvyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=czuAz6+f; arc=none smtp.client-ip=95.215.58.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="czuAz6+f"
X-Envelope-To: linux-ext4@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yQ1JL3OS1DIhfdfcLe4c8iEZGo0TsjpYksuAFp/3C9s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790242069; v=1; x=1790846869;
 b=czuAz6+fWkcvel/Ss9yzDdaaRu5B7Vc6wVDqP8BP4o9hrQr87bNJAeSi8Gj3Xk2Kn6fXep0f
 2Yxc5UbBub1YEt4sDfOtHKMS2u7DpyivoZQ8nGpiAmrkzbcACMh3zldoCgerts1IrFflCOPXbmv
 6im9RzleA2/1AtVK18GchuTg=
X-Envelope-To: linux-ext4@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 17e50b02eda3b91c;
	Thu, 24 Sep 2026 09:27:49 +0000
X-Mizu-Trace-ID: 17e50b02eda3b91c
X-Migadu-Flow: FLOW_OUT
Message-ID: <f46ac4fb-6ef3-48e8-b098-bd210ea276b7@linux.dev>
Date: Thu, 24 Sep 2026 17:27:38 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] [ext4?] WARNING in __folio_set_anon
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, harry@kernel.org, jannh@google.com,
 liam@infradead.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@surriel.com,
 syzkaller-bugs@googlegroups.com, vbabka@kernel.org,
 syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
References: <6ab4ae75.80e1c6cc.1e8e5f.000d.GAE@google.com>
 <20260924065458.49698-1-lance.yang@linux.dev>
 <0a0a07f8-8ac9-4d75-b4c6-c403865f0be9@kernel.org>
 <08bbb615-a054-472c-9873-787cc0f7a4d7@kernel.org> <arTiHRj-i_17L3qo@gremlin>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <arTiHRj-i_17L3qo@gremlin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/9/24 16:52, Lorenzo Stoakes (ARM) wrote:
> On Thu, Sep 24, 2026 at 09:50:02AM +0200, David Hildenbrand (Arm) wrote:
>> On 9/24/26 09:43, David Hildenbrand (Arm) wrote:
>>> On 9/24/26 08:54, Lance Yang wrote:
>>>>
>>>> On Wed, Sep 23, 2026 at 10:00:37PM -0700, syzbot wrote:
>>>>> Hello,
>>>>>
>>>>> syzbot found the following issue on:
>>>>>
>>>>> HEAD commit:    38872197cae2 Merge branch 'for-next/fixes' into for-kernelci
>>>>> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=17a44d25580000
>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=56ed23170c168d4c
>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=c181d3198e98f8aef8b9
>>>>> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
>>>>> userspace arch: arm64
>>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a36515580000
>>>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16dcf4c9580000
>>>>
>>>> Looking at the repro, emm ... the repro maps an O_RDONLY /dev/zero fd with
>>>
>>> Does this trigger upstream or only after Lorenzo's rework (not upstream yet IIRC)
> 
> It'd trigger with my make MAP_PRIVATE-/dev/zero true anon stuff too yes.
> 
>>>
>>> 46827ac1ab221 mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous
>>> db7438ea23180 mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous
>>> 54e8e096ea86b mm: implement file_is_dev_zero() to uniquely identify /dev/zero
>>> fb24843cfd9eb mm: move drivers/char/mem.c to mm/char-mem.c
>>>
>>> I assume it triggers upstream. Does it also trigger with lorenzo's changes?
>>>
>>>> MAP_SHARED | PROT_READ. do_mmap() clears VM_SHARED and VM_MAYWRITE, so
>>>
>>> Clearing VM_MAYWRITE for a private mapping is odd. Can you point me at the code
>>> that clears both things?
>>>
>>> I assume we still have the file pointer, and as the file is read-only we remove
>>> VM_MAYWRITE. But why are we removing MAP_SHARED? (where?)
>>
>> Looking at the code, it's the
>>
>> 	if (!(file->f_mode & FMODE_WRITE))
>> 		vma_flags_clear(&vma_flags, VMA_MAYWRITE_BIT, VMA_SHARED_BIT);
>>
>> So we end up with VMA_MAYSHARE_BIT but without VMA_MAYWRITE_BIT and without
>> VMA_SHARED_BIT.
>>
>> So it's by definition not a COW mapping. But it's marked anonymous and confuses
>> the system :)
> 
> This is definitely a bug. And I added these asserts specifically to find
> bugs like this with anon mappings:
> 
> 	VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma)); <-- fires
> 	if (vma_is_anonymous(vma))
> 		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address)); <-- would have fired
> 
> It's because mmap_zero_prepare() keys off VMA_SHARED_BIT when it should be
> keying off the terribly-named VMA_MAYSHARE_BIT.
> 
> (VMA_MAYSHARE_BIT actually tells you if the mapping was mapped shared _in
> the first place_ specifically because of this clearing of VMA_SHARED_BIT,
> VMA_MAYWRITE_BIT.)

Cool! Using VMA_MAYSHARE_BIT instead of VMA_SHARED_BIT in 
mmap_zero_prepare()
should do the trick.

> 
> So it turns out forever a readonly /dev/zero shared mapping has quietly been
> converted to yet another variant of a 'special' anonymous mapping that we
> weren't even aware of.
> 
> And it's got an incorrect pgoff (but not anon pgoff now) as a result,
> similar to the usual MAP_PRIVATE-/dev/zero case.
> 
> So the solution is simple, check for VMA_MAYSHARE_BIT in
> mmap_zero_prepare(). The Fixes: will be in the sands of time.
> 
> I'll send a fix out.

Thanks, Lorenzo!

>>
>> --
>> Cheers,
>>
>> David
> 
> --
> Cheers, Lorenzo

