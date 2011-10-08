From: Tao Ma <tm@tao.ma>
Subject: Re: KVM-based xfstests appliance
Date: Sat, 08 Oct 2011 13:57:13 +0800
Message-ID: <4E8FE639.8030109@tao.ma>
References: <20110828235437.GA12187@thunk.org> <20110829133248.GC12187@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:52009 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750910Ab1JHF5j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Oct 2011 01:57:39 -0400
In-Reply-To: <20110829133248.GC12187@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
On 08/29/2011 09:32 PM, Ted Ts'o wrote:
> On Sun, Aug 28, 2011 at 07:54:37PM -0400, Ted Ts'o wrote:
>> Has anyone else noticed failures with xfstests #74?  What I'm finding
>> is that if compile the fstest program so that it is statically linked,
>> I can't get it to fail:
> 
> I've put up an my KVM-based xfstests appliance here:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/V-xfstests.tar.gz
It seems that this file is missing in the new ftp.kernel.org. Would you
mind upload it again or is there any other site that we can try to get it?

Thanks
Tao
> 
> Hopefully this will be useful for other people who are trying to do QA
> work for ext4.  I find it's much more convenient to test out a kernel
> by running "kvm-xfstests smoke", or "kvm-xfstests full".
> 
> BTW, I've found that the xfstests 74 test failure is very timing
> dependent.  It doesn't fail when I use another system which has faster
> disks than dm-crypt'ed laptop drives, and where writeback mode is
> enabled with lots of memory available for caching purposes.  It seems
> to require memory pressure and slower disks.  I should check and see
> whether it involves ext4_writepage() getting invoked out of the direct
> reclaim path...
> 
> 	     	     	    	      	  	  - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

