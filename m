From: Tao Ma <tm@tao.ma>
Subject: Re: bigalloc and max file size
Date: Tue, 01 Nov 2011 12:06:11 +0800
Message-ID: <4EAF7033.8070005@tao.ma>
References: <51BECC2B-2EBC-4FCB-B708-8431F7CB6E0D@dilger.ca> <5846CEDC-A1ED-4BB4-8A3E-E726E696D3E9@mit.edu> <EB03FF23-73BC-4FDC-B991-5EB3FEEB8DAE@whamcloud.com> <B327AF5F-B58A-43A2-BCB2-D0345F550D43@mit.edu> <97D9C5CC-0F22-4BC7-BDFA-7781D33CA7F3@whamcloud.com> <E0A4425F-9C68-4929-83CD-9B2CA3F87979@mit.edu> <4EAA2217.5020002@tao.ma> <A0C1821A-B597-4617-BD14-B638143DC3C2@mit.edu> <4EAE780D.3090005@tao.ma> <20111031200053.GI16825@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@whamcloud.com>,
	linux-ext4 development <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <bzzz@whamcloud.com>,
	"hao.bigrat@gmail.com" <hao.bigrat@gmail.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:58583 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750757Ab1KAEGQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Nov 2011 00:06:16 -0400
In-Reply-To: <20111031200053.GI16825@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/01/2011 04:00 AM, Ted Ts'o wrote:
> On Mon, Oct 31, 2011 at 06:27:25PM +0800, Tao Ma wrote:
>> In the new bigalloc case if chunk size=64k, and with the linux-3.0
>> source, every file will be allocated a chunk, but they aren't contiguous
>> if we only write the 1st 4k bytes. In this case, writeback and the block
>> layer below can't merge all the requests sent by ext4. And in our test
>> case, the total io will be around 20000. While with the cluster size, we
>> have to zero the whole cluster. From the upper point of view. we have to
>> write more bytes. But from the block layer, the write is contiguous and
>> it can merge them to be a big one. In our test, it will only do around
>> 2000 ios. So it helps the test case.
> 
> This is test case then where there are lot of sub-64k files, and so
> the system administrator would be ill-advised to use a 64k bigalloc
> cluster size in the first place.  So don't really consider that a
> strong argument; in fact, if the block device is a SSD or a
> thin-provisioned device with an allocation size smaller than the
> cluster size, the behaviour you describe would in fact be detrimental,
> not a benefit.
OK, actually the above test case is more natural if we replace umount
with sync. And I guess this is the most common case for a normal desktop
user. Even without sync, the disk util will be very high. As now the SSD
isn't popular in normal user's env, I would imagine more guy will
complain about it when bigalloc get merged.
> 
> In the case of a hard drive where seeks are expensive relative to
> small writes, this is something which we could do (zero out the whole
> cluster) with the current bigalloc file system format.  I could
> imagine trying to turn this on automatically with a hueristic, but
> since we can't know the underlying allocation size of a
> thin-provisioned block device, that would be tricky at best...
OK, if we would decide to leave extent length to be block length, we can
do some tricky thing like cfq to read the rotational flag of the
underlying device. It is a bit pain, but we have to handle it as I
mention above.

Thanks
Tao
