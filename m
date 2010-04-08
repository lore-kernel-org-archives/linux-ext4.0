From: Nebojsa Trpkovic <trx.lists@gmail.com>
Subject: Re: "data=writeback" and TRIM don't get along
Date: Thu, 08 Apr 2010 03:37:41 +0200
Message-ID: <4BBD3365.90306@gmail.com>
References: <4BBD285B.9000603@gmail.com> <4BBD2FDF.4040407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54259 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547Ab0DHBhp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Apr 2010 21:37:45 -0400
Received: by bwz1 with SMTP id 1so1385047bwz.21
        for <linux-ext4@vger.kernel.org>; Wed, 07 Apr 2010 18:37:43 -0700 (PDT)
In-Reply-To: <4BBD2FDF.4040407@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/08/10 03:22, Eric Sandeen wrote:
> How does it fail?
> 
> Surely a bug.  :)  If you can provide details we'll look into it.
> (perhaps it's obvious on first try but still worth saying exactly
> what problematic behavior you saw, when reporting a bug you
> encountered)

Well, I've done a simple test, described like:

"get the used sectors for a file
hdparm --fibmap filename
read a sector from the file eg. with
sudo hdparm --read-sector 66385920 /dev/sda
delete the file and sync
rm filename;sync
and read the sector a second time"


And I get something like this:

================================
# dd if=/dev/urandom of=tempfile count=100 bs=512k oflag=direct
100+0 records in
100+0 records out
52428800 bytes (52 MB) copied, 6.47137 s, 8.1 MB/s

# hdparm --fibmap tempfile

tempfile:
 filesystem blocksize 4096, begins at LBA 0; assuming 512 byte sectors.
 byte_offset  begin_LBA    end_LBA    sectors
           0   37094400   37196799     102400

# hdparm --read-sector 37094400 /dev/sdb

/dev/sdb:
reading sector 37094400: succeeded
b0e8 3ad7 d080 84e8 b4b2 7e60 21f1 eff3
0ef9 fa10 b172 89f8 186f 0194 4cb1 e190
d6b5 b2fe 2577 5dba e6f2 5ad7 34a0 f09f
ca5c 07ef 6e86 c3a8 9e77 77f3 78ff 672f
af71 dea7 ac23 a55d e31e ff83 164e bb76
8ea4 416d 343a 9f5e b41f b1d0 b6e9 6ed8
90c0 3cba ec07 1d96 fdd6 3940 1290 7cd2
c506 c3ee c120 3732 17eb 6e68 11aa 721c...

# rm tempfile
# sync
================================

Now, if I have "data=writeback" enable and I run
# hdparm --read-sector 37094400 /dev/sdb
again, I'll get the same random bytes.
Reboot doesn't help.

If I disable "data=writeback" and run
# hdparm --read-sector 37094400 /dev/sdb
I'll get all zeroes:
================================
# hdparm --read-sector 37094400 /dev/sdb

/dev/sdb:
reading sector 37094400: succeeded
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
...
================================

So, TRIM command works well, but not with "data=writeback" mount option.

Other info:

Intel X25-V 40GB (latest firmware)

Linux box 2.6.33-gentoo #4 SMP Sat Apr 3 05:02:04 CEST 2010 x86_64
Intel(R) Core(TM) i5 CPU 750 @ 2.67GHz GenuineIntel GNU/Linux


Nebojsa


