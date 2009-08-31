From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: large file system & high object count testing
Date: Mon, 31 Aug 2009 18:20:46 -0400
Message-ID: <4A9C4CBE.7040701@redhat.com>
References: <4A9BFB88.5030409@redhat.com> <4A9C0220.1040503@redhat.com>	 <20090831205608.GE4197@webber.adilger.int>	 <4A9C3A7B.3050302@redhat.com> <150c16850908311425vbc1c0a1if2a7d8ed56f650f5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	"Ted Ts'o" <tytso@thunk.org>
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbZHaWUs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Aug 2009 18:20:48 -0400
In-Reply-To: <150c16850908311425vbc1c0a1if2a7d8ed56f650f5@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/31/2009 05:25 PM, Justin Maggard wrote:
> On Aug 31, 2009  13:02 -0400, Ric Wheeler wrote:
>    
>> Mount after fsck:
>> Aug 31 12:27:12 megadeth kernel: EXT4-fs (dm-75):
>> ext4_check_descriptors: Checksum for group 487 failed (59799!=46827)
>> Aug 31 12:27:12 megadeth kernel: EXT4-fs (dm-75): group descriptors
>> corrupted!
>>      
> Ah, so it's not just me.  It looks like you're seeing the exact same
> thing I reported a few days ago in the ">16TB issues" thread.  You
> don't even have to do anything fancy to make this happen.  My test
> case involves simply creating 5 directories on the newly-created
> 64-bit filesystem, and running e2fsck on it immediately after
> unmounting to get the same results.
>
> -Justin
>    
Much faster than my fill it over the week end test :-)

ric

