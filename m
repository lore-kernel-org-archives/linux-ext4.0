From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 0/5][64-BIT] Miscellaneous e2fsprogs 64-bit patches -
 description
Date: Wed, 15 Apr 2009 14:56:15 -0500
Message-ID: <49E63BDF.5020506@redhat.com>
References: <11629.1239227147@alphaville.usa.hp.com> <20090415195014.GB1668@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Nick Dokos <nicholas.dokos@hp.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56146 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807AbZDOT4V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Apr 2009 15:56:21 -0400
In-Reply-To: <20090415195014.GB1668@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Valerie Aurora Henson wrote:
> On Wed, Apr 08, 2009 at 05:45:47PM -0400, Nick Dokos wrote:


>> but there is an interesting catch-22: how do I save its output?
>>
>> I can try the command line suggested in the manual page:
>>
>>   e2image -r <dev> - | bzip2 > image.bz2
>>
>> but it takes forever: I started a run on Saturday and it was not
>> done by Tuesday when I killed it - writing to the pipe at 4096 bytes
>> a pop is very slow.
>>
>> Or I can forego the compression and try to save to a file: it's sparse
>> (I only used 7GiB before it failed), but its nominal size exceeded the
>> maximum file size limit on ext4, at which point I start getting lseek
>> failures.

We really need some e2image format which encodes the sparseness, I think...

> The 16TB limit on ext4 files is an enormous pain for testing 64-bit
> (>= 16TB) file systems.  I keep intending to write some simple dm
> setup to concatenate two loopback files together, but instead I always
> install XFS and create a loopback file on an XFS partition.

For testing a large device, say /dev/sdb1 is 10GB large:

# TERABYTES=`expr 20 \* 1024 \* 1024 \* 1024 \* 2`   # 20 TB in sectors
# echo "0 $ERABYTES zero" | dmsetup create zero1
# echo "0 $TERABYTES snapshot /dev/mapper/zero1 /dev/sdb1 p 128" | \
   dmsetup create sparse1

This will create a 20TB sparse device called /dev/mapper/sparse1 that
has 10GB of actual storage space available. If more than 10GB of data is
written to this device, it will start returning I/O errors.

This is from Documentation/device-mapper/zero.txt

-Eric
