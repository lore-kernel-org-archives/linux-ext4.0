From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: next-20090206: deadlock on ext4
Date: Wed, 18 Feb 2009 12:56:33 +0300
Message-ID: <a4423d670902180156yd293319na51f91c6651e076c@mail.gmail.com>
References: <a4423d670902060935y59e540beta417144935416560@mail.gmail.com>
	 <498C7671.1050309@redhat.com>
	 <a4423d670902061004i424817e1vd699a61e335f010a@mail.gmail.com>
	 <498C9876.3060208@redhat.com>
	 <a4423d670902090401k716d054eo25640aa2207beca7@mail.gmail.com>
	 <4995F27E.3070401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <4995F27E.3070401@redhat.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2009/2/14 Eric Sandeen <sandeen@redhat.com>:
> Alexander Beregalov wrote:
>
>> I have reproduced it with 2.6.29-rc4.
>> Loop file was on XFS.
>> I can not reproduce it on ext4 on raw device.
>> Let me know if I can do anything else to help resolving it.
>>
> Can you try this patch from Aneesh?  Works for me...
>

Yes, it works, I can not reproduce the bug on
2.6.29-rc5-00122-g5955c7a which contains 2acf2c261b82
"ext4: Implement range_cyclic in ext4_da_writepages instead of
write_cache_pages"

Thanks
