From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfstests: 223 - test file alignment on stripe geometry
Date: Sat, 30 Jan 2010 10:13:45 -0600
Message-ID: <4B645AB9.8050508@sandeen.net>
References: <4B621529.20708@sandeen.net> <20100130105236.GA18286@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 64-131-60-146.usfamily.net ([64.131.60.146]:40039 "EHLO
	mail.sandeen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab0A3QNq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jan 2010 11:13:46 -0500
In-Reply-To: <20100130105236.GA18286@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christoph Hellwig wrote:
>> +# real QA test starts here
>> +_supported_fs xfs ext4
> 
> I'd make this generic and just do the notrun in scratch_mkfs_geom for
> non-supported filesystems.

fair enough

>> +scratch_mkfs_geom()
>> +{
> 
> And I'd throw this one into common.rc.

ok

>> +=== Testing size 1073745920 falloc on 128k stripe ===
>> +SCRATCH_MNT/file-1073745920-falloc: well-aligned
>> diff --git a/common.rc b/common.rc
>> index 6424871..97513cc 100644
>> --- a/common.rc
>> +++ b/common.rc
>> @@ -292,7 +292,7 @@ _scratch_mkfs()
>>          $MKFS_UDF_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
>>  	;;
>>      *)
>> -	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
>> +	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV
> 
> Hmm, doesn't this change break other testcase?  Anyway needs some
> rationale in the changelog.

didn't break anything for me; I wanted to be able to see the mkfs
results w/ geometry, is all.  Will re-double-check but it was fine AFAIK.

>> index 0000000..fa005b2
>> --- /dev/null
>> +++ b/src/fibmap.c
> 
> This is a bit misnamed as it's not a generic fibmap tool but rather
> a specific tool comparing the bmap to the sunit alignment.
> 

good point .. how about making it more generic, something like:

fibmap -o <file offset> -l <length> -s <stripe alignment> <filename>

hmm though I hate to reqwrite filefrag ... :)

I suppose something like this could go into xfs_io as well, but that
makes this test unavailable to the masses until another release, at least.

-Eric
