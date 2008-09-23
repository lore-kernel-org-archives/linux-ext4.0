From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH, RFC] ext4: Use preallocation when reading from the	inode
 table
Date: Tue, 23 Sep 2008 08:18:54 -0400
Message-ID: <48D8DEAE.4080309@redhat.com>
References: <E1KhvsB-0002Ik-Ex@closure.thunk.org> <20080923101613.58768083@lxorguk.ukuu.org.uk> <20080923115045.GI10950@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47790 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbYIWMTI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2008 08:19:08 -0400
In-Reply-To: <20080923115045.GI10950@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Sep 23, 2008  10:16 +0100, Alan Cox wrote:
>   
>> On Mon, 22 Sep 2008 20:35:23 -0400
>> "Theodore Ts'o" <tytso@mit.edu> wrote:
>>     
>>> With modern hard drives, reading 64k takes roughly the same time as
>>> reading a 4k block.  So request adjacent inode table blocks to reduce
>>> the time it takes when iterating over directories (especially when doing
>>> this in htree sort order) in a cold cache case.  With this patch, the
>>> time it takes to run "git status" on a kernel tree after flushing the
>>> caches via "echo 3 > /proc/sys/vm/drop_caches", is reduced by 21%.
>>>
>>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>>>       
>> Acked-by: Alan Cox <alan@redhat.com>
>>
>> I'm actually suprised that 16 is the magic tuning number you've used and
>> a bigger one isn't even more of a win
>>     
>
> I was going to suggest making this at least a #defined constant instead
> of hard coding the values there.  Making it a mount option and/or /proc
> value would allow further testing.
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>   

I think that Alan is probably right - the magic number for modern drives 
is probably closer to 256K. Having it be a /sys tunable (with a larger 
default) would be a nice way to verify this.

Ric

