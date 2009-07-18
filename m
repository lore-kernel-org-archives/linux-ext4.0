From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfstests: very basic defragmentation testing for xfs
 &	ext4
Date: Sat, 18 Jul 2009 11:30:13 -0500
Message-ID: <4A61F895.9090704@redhat.com>
References: <4A5E3A37.5050306@redhat.com> <20090718143114.GC20905@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: xfs mailing list <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60237 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbZGRQaX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Jul 2009 12:30:23 -0400
In-Reply-To: <20090718143114.GC20905@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christoph Hellwig wrote:
> On Wed, Jul 15, 2009 at 03:21:11PM -0500, Eric Sandeen wrote:

...

>> (md5sums may just be reading buffered data though,
>> suggestions?)
> 
> As Andreas said unmount it before.
> 
>> The test currently expects to find e4defrag in
>> /usr/bin
> 
>> +_supported_fs xfs ext4
> 
>> +fragfile=$SCRATCH_MNT/fragfile.$$
>> +
>> +if [ "$FSTYP" == "xfs" ]; then
>> +	DEFRAG=/usr/sbin/xfs_fsr
>> +else
>> +	DEFRAG=/usr/bin/e4defrag
>> +fi
>> +
>> +_require_command $DEFRAG
>> +_require_command /usr/sbin/filefrag
> 
> I think we're much better off adding a helpers for this in a new
> common.defrag (or adding it somwhere).
> 
> Then set a DEFRAF_PROG variable there, and add a _require_defrag
> ala


Both ideas sound good, will send a V2.

-Eric
