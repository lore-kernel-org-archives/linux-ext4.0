From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH V2] xfstests: mount other filesystems with selinux context
 as well
Date: Wed, 25 Jan 2012 15:28:12 -0600
Message-ID: <4F2073EC.80208@sandeen.net>
References: <4ECD3262.105@redhat.com> <20111128110228.GC13766@infradead.org> <4F1862FC.1050401@sandeen.net> <20120124174500.GB9853@infradead.org> <4F20700B.8060307@sandeen.net> <20120125211438.GA11821@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60381 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab2AYV2N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Jan 2012 16:28:13 -0500
In-Reply-To: <20120125211438.GA11821@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/25/12 3:14 PM, Christoph Hellwig wrote:
> On Wed, Jan 25, 2012 at 03:11:39PM -0600, Eric Sandeen wrote:
>> For some reason, non-xfs filesystems aren't getting mounted with
>> the selinux context; perhaps because none of the xattr tests used
>> to work on anything but xfs?
>>
>> Anyway, 062 fails for extN unless we mount with the fs-wide
>> context.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> ps: eparis says this should work for NFS as well, let's go for
>> it and if infrequently tested filesystems have trouble we can
>> exclude them as necessary.
> 
> Verifying that assumption isn't hard, please do it.
> 

# mount -t nfs -o context=system_u:object_r:nfs_t:s0 localhost:/mnt/export /mnt/test
# grep /mnt/export /proc/mounts 
localhost:/mnt/export /mnt/test nfs4 rw,context=system_u:object_r:nfs_t:s0,relatime,vers=4,rsize=262144,wsize=262144,namlen=255,hard,proto=tcp,port=0,timeo=600,retrans=2,sec=sys,clientaddr=127.0.0.1,minorversion=0,local_lock=none,addr=127.0.0.1 0 0

