From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH e2fsprogs] - fix swap sanity tests in blkid, and blkid
 tests
Date: Tue, 13 May 2008 07:47:19 -0500
Message-ID: <48298DD7.7060502@redhat.com>
References: <48288BEB.6090005@redhat.com> <20080513063212.GF3627@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756108AbYEMMrW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 May 2008 08:47:22 -0400
In-Reply-To: <20080513063212.GF3627@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On May 12, 2008  13:26 -0500, Eric Sandeen wrote:
>> One one other required change, though; mkswap requires at least
>> 10 pages of swap, so the image needs to be increased to 10x64k
>> if mkswap is to succeed...
>>
>> Maybe it'd be better to just dd it out on the fly?
> 
> Probably, yes.  Little point in bunzipping bytes that you are just
> going to overwrite...

It's just that right now it iterates over existing files, so that's how
it finds swap0 and swap1 to test...

*shrug*

Could make them bzipped sparse files... :)

>>  	bunzip2 < $SRCDIR/tests/$i.img.bz2 > tests/tmp/test.img.$$
>> +	# swap is native-endian, so regenerate before testing
>> +	if [ "$i" == "swap0" ]; then
>> +		mkswap -v0 tests/tmp/test.img.$$ > /dev/null
>> +	elif [ "$i" == "swap1" ]; then
>> +		mkswap -v1 -L SWAP-TEST -U 8ff8e77f-8553-485e-8656-58be67a81666 tests/tmp/test.img.$$ >/dev/null
>> +	fi
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 

