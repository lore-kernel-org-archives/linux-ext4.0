From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: Protect group inode free counting with group lock.
Date: Tue, 29 May 2012 22:28:34 +0800
Message-ID: <4FC4DD12.4020007@tao.ma>
References: <1337158192-4591-1-git-send-email-tm@tao.ma> <4FB3AF00.9060704@redhat.com> <4FB3BFC9.20901@tao.ma> <4FB3CC8C.4030502@redhat.com> <4FB45FBE.10004@tao.ma> <20120528222241.GD5610@thunk.org> <4FC431E6.7020206@tao.ma> <8932CA1F-B08D-4327-AD23-38EA56D49F47@dilger.ca> <20120529123950.GC16351@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:57632 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753506Ab2E2O2n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2012 10:28:43 -0400
In-Reply-To: <20120529123950.GC16351@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/29/2012 08:39 PM, Ted Ts'o wrote:
> On Mon, May 28, 2012 at 11:57:59PM -0600, Andreas Dilger wrote:
>>> We are just disabling the uninit_bg so as to let the block group
>>> initialization happen in the mkfs time. I don't know why the checksum is
>>> also disabled by ^uninit_bg.
>>
>> The checksum is controlled by uninit_bg, because there was a need to
>> ensure the bg_itable_unused count and the UNINIT flags could be
>> trusted when doing an e2fsck.
>>
>> If you don't want to do lazy inode table initialization, that is
>> disabled by "mke2fs -E lazy_itable_init=0".
> 
> You can also disable whether or not lazy inode table initialization
> happens by default via /etc/mke2fs.conf.  At work we have a very
> fairly havily modified /etc/mke2fs.conf which has our
> production-specific mke2fs parameters defined, so that someone who
> runs mke2fs by hand will get the same result at as the automated
> systems.
> 
> I can easily see how if you are trying for predictable latency
> numbers, disabling lazy inode table initialization makes a huge amount
> of sense.  I'd recommend doing it via /etc/mke2fs.conf, though.
OK, thank you all for the good suggestion.

Thanks
Tao
