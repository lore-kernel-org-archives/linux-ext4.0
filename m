From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Serious bug?
Date: Tue, 31 Jul 2012 16:40:36 -0500
Message-ID: <501850D4.8060101@redhat.com>
References: <0408C81F72528E40A0D3235A1F67FFC804A61E@SN2PRD0202MB144.namprd02.prod.outlook.com> <20120731024236.GB5027@thunk.org> <0408C81F72528E40A0D3235A1F67FFC804A643@SN2PRD0202MB144.namprd02.prod.outlook.com> <20120731032536.GE5027@thunk.org> <0408C81F72528E40A0D3235A1F67FFC804A65F@SN2PRD0202MB144.namprd02.prod.outlook.com> <20120731213845.GA3945@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Nelson, John R" <John_Nelson@student.uml.edu>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab2GaVkl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jul 2012 17:40:41 -0400
In-Reply-To: <20120731213845.GA3945@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/31/12 4:38 PM, Theodore Ts'o wrote:
> On Tue, Jul 31, 2012 at 04:54:42AM +0000, Nelson, John R wrote:
>> ok i am using 3.2.0-27-generic (ubuntu 64 bit) e2fsporgs 1.42. the filesystem is 681GB.  Both computers are intel based on is core i5 and one is intel atom and they are in no special configuration just one sata cable to each drive
>>
>> here are the steps i did
>> 1. fallocate file1 -l 500gb              << exact method
>> 2.mkfs.ext4 file1                                <<  exact method
>> i will get the error messages about it failing, i delete the file and fsck is still forced upon next mount
> 
> OK, I see what's going on.  I was able to reproduce it using a 3.2
> kernel (but not a more recent kernel which is what I normally use;
> more about that later) with a slightly smaller size (since that's all
> the space I had on free on my laptop):
> 
> # fallocate -l 215g file1
> # mke2fs -t ext4 -F file1
> 
> The problem is that fallocate allocated a large number of blocks, which
> mke2fs then immediately discarded as its first order of business.

Hm, then why didn't mkfs.ext4 -K solve the problem....

-Eric
