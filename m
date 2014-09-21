From: TR Reardon <thomas_reardon@hotmail.com>
Subject: RE: resize2fs problem with stride calc
Date: Sun, 21 Sep 2014 18:32:53 -0400
Message-ID: <BAY179-W21A504DA0A8A8D30C139F3FDB20@phx.gbl>
References: <BAY179-W85AF983234DB78F07A12EFDB50@phx.gbl>,<541EF912.7000801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"darrick.wong@oracle.com" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bay004-omc1s7.hotmail.com ([65.54.190.18]:56777 "EHLO
	BAY004-OMC1S7.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaIUWcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Sep 2014 18:32:53 -0400
In-Reply-To: <541EF912.7000801@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Date: Sun, 21 Sep 2014 11:13:06 -0500
> From: sandeen@redhat.com
>
> On 9/20/14 3:46 PM, TR Reardon wrote:
>> resize2fs seems to come up with some crazy default stride numbers.
>> This occurs with and without bigalloc.
>>
>>
>> I was testing enabling/disabling 64bit using latest patches from DJW=
,
>> and noticed that s_raid_stride was being written with nonsensical
>> values, in particular determine_fs_stride() is coming up with overly
>> large values. The code is old (2006) and lacks comment so I'm not
>> sure what the intended operation is. Does this just need to be
>> updated for flex_bg? Should s_raid_stride ever be auto-changed on
>> resize? If it should change, should stripe also change?
>
> That old commit says:
>
> + In addition, add code so that resize2fs can automatically
> + determine the RAID stride parameter that had been
> + previously used on the filesystem.
>
> but a year later, in 2007, this:
>
> commit 96c6a3acd377698cb99ffd9925bec9b20ca4f6f9
> Author: Theodore Ts'o <tytso@mit.edu>
> Date: Fri May 18 22:06:53 2007 -0400
>
> Store the RAID stride value in the superblock and take advantage of i=
t
>
> stored it properly in the superblock (this hit e2fsprogs-1.40).
>
> So maybe the whole heuristic could just be removed now, but from a si=
mple
> test, it's working here.

Have you tried to test with flex_bg? =A0I think that's what raises the =
problem.

>
> What was the geometry (dumpe2fs -h) of your filesystem before the res=
ize?

Here is one example. =A0I am changing _only_ the bitness, geometry stay=
s the same=A0
other than changes to reserved GDT.

Prior to resize2fs -b :

=2E..
=46ilesystem revision #: =A0 =A01 (dynamic)
=46ilesystem features: =A0 =A0 =A0has_journal ext_attr resize_inode dir=
_index filetype needs_recovery extent flex_bg sparse_super large_file h=
uge_file dir_nlink extra_isize bigalloc metadata_csum
=46ilesystem flags: =A0 =A0 =A0 =A0 signed_directory_hash
Default mount options: =A0 =A0user_xattr acl
=46ilesystem state: =A0 =A0 =A0 =A0 clean
Errors behavior: =A0 =A0 =A0 =A0 =A0Continue
=46ilesystem OS type: =A0 =A0 =A0 Linux
Inode count: =A0 =A0 =A0 =A0 =A0 =A0 =A0715776
Block count: =A0 =A0 =A0 =A0 =A0 =A0 =A0732566384
Reserved block count: =A0 =A0 0
=46ree blocks: =A0 =A0 =A0 =A0 =A0 =A0 =A013977472
=46ree inodes: =A0 =A0 =A0 =A0 =A0 =A0 =A0714665
=46irst block: =A0 =A0 =A0 =A0 =A0 =A0 =A00
Block size: =A0 =A0 =A0 =A0 =A0 =A0 =A0 4096
Cluster size: =A0 =A0 =A0 =A0 =A0 =A0 65536
Reserved GDT blocks: =A0 =A0 =A053
Blocks per group: =A0 =A0 =A0 =A0 524288
Clusters per group: =A0 =A0 =A0 32768
Inodes per group: =A0 =A0 =A0 =A0 512
Inode blocks per group: =A0 32
=46lex block group size: =A0 =A016
=2E..
Inode size: =A0 =A0 =A0 =A0 =A0 =A0 =A0 256
Required extra isize: =A0 =A0 28
Desired extra isize: =A0 =A0 =A028
=2E..


And following resize2fs -b:

=46ilesystem revision #: =A0 =A01 (dynamic)
=46ilesystem features: =A0 =A0 =A0has_journal ext_attr resize_inode dir=
_index filetype extent 64bit flex_bg sparse_super large_file huge_file =
dir_nlink extra_isize bigalloc metadata_csum
=46ilesystem flags: =A0 =A0 =A0 =A0 signed_directory_hash=A0
Default mount options: =A0 =A0user_xattr acl
=46ilesystem state: =A0 =A0 =A0 =A0 clean
Errors behavior: =A0 =A0 =A0 =A0 =A0Continue
=46ilesystem OS type: =A0 =A0 =A0 Linux
Inode count: =A0 =A0 =A0 =A0 =A0 =A0 =A0715776
Block count: =A0 =A0 =A0 =A0 =A0 =A0 =A0732566384
Reserved block count: =A0 =A0 0
=46ree blocks: =A0 =A0 =A0 =A0 =A0 =A0 =A013977472
=46ree inodes: =A0 =A0 =A0 =A0 =A0 =A0 =A0714665
=46irst block: =A0 =A0 =A0 =A0 =A0 =A0 =A00
Block size: =A0 =A0 =A0 =A0 =A0 =A0 =A0 4096
Cluster size: =A0 =A0 =A0 =A0 =A0 =A0 65536
Group descriptor size: =A0 =A064
Reserved GDT blocks: =A0 =A0 =A042
Blocks per group: =A0 =A0 =A0 =A0 524288
Clusters per group: =A0 =A0 =A0 32768
Inodes per group: =A0 =A0 =A0 =A0 512
Inode blocks per group: =A0 32
RAID stride: =A0 =A0 =A0 =A0 =A0 =A0 =A065520
=46lex block group size: =A0 =A016
=2E..
Inode size:	 =A0 =A0 =A0 =A0 =A0256
Required extra isize: =A0 =A0 28
Desired extra isize: =A0 =A0 =A028
=2E..


 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
