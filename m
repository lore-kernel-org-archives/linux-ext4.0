From: =?ISO-8859-1?Q?Fran=E7ois_Valenduc?=
	<francois.valenduc@tvcablenet.be>
Subject: Re: Wrong calculation of space remaining on a 32 bit system.
Date: Mon, 03 Nov 2008 19:28:34 +0100
Message-ID: <490F42D2.8080200@tvcablenet.be>
References: <490DBBD9.9040300@tvcablenet.be> <20081102204352.GJ8134@mit.edu> <490E1FB1.8020100@tvcablenet.be> <87fxm9bxps.fsf@newton.gmurray.org.uk> <490E289F.4010907@tvcablenet.be> <20081102230135.GM8134@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020902070607060300020809"
Cc: Graham Murray <graham@gmurray.org.uk>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mirapoint3.brutele.be ([212.68.199.148]:16107 "EHLO
	mirapoint3.brutele.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbYKCS3K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 13:29:10 -0500
In-Reply-To: <20081102230135.GM8134@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020902070607060300020809
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Theodore Tso a écrit :
> On Sun, Nov 02, 2008 at 11:24:31PM +0100, François Valenduc wrote:
>> How can I know if I ran out of inodes ? I already tried 128 and 256
>> inode sizes but the problem occurs in both cases. 
> 
> By using the command "df -i".  It will list the number of inodes that
> are in use.
> 
> The tuning parameters for mke2fs is -i (the inode ratio), or -N
> (number of inodes).  The number of inodes is normally calculated as a
> ratio to the disk size.  The normal inode ratio is 16384, which allows
> for an average inode size of 16k.  If you have a huge number of small
> files, or small directories, or a huge number of symbolic links or
> device nodes in the filesystem, you can run out of inodes.  You can
> change this either by specifying a a smaller inode ratio, or by
> explicitly specifying the number of inodes you want created using the
> -N option.
> 
>> As I said in my bug
>> report, I found a patch dated from november 2007 which seems to adress
>> the problem (see
>> http://osdir.com/ml/file-systems.ext4/2007-11/msg00200.htm).  Off course,
>> I can't apply it any more now.
> 
> You can't apply it because it's already been applied; it's been in
> mainline for quite a while.
> 
>>  But it seems this kind of problem still
>> exists. I have no problem to use ext4 on a 64 bit systems with logical
>> volumes having approximately the same size.
> 
> That seems very strange.  Maybe you have a different version of
> mke2fs, or a different mke2fs.conf file?  (The default inode size can
> be controlled by the mke2fs.conf file.)
> 
> Can you send the output of "dumpe2fs -h" on a filesystem where you are
> having this problem, and on a filesystem from the 64-bit system where
> it is working correctly?
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

I indeed ran out of inode and this probably has nothing to do with 32 or
64 bit systems. The df -i output looks like this:
/dev/mapper/system-portage      45K     45K       0  100% /usr/portage

As you may have guessed, I created a logical volume for the portage tree
 of gentoo. It indeeds contains a lot of small files with all the
ebuilds. I use XFS for the portage tree on the 64 bits computer. Maybe
ext4 is not appropriate for this case. Maybe I would have the same
problem also on the 64 bits computer.

I am also attaching the dump2efs output. I finally managed to use ext4
on this computer. I created a logical volume for the /usr/src directory
and I managed to copy 2 sources of linux kernel and a clone of    the
git tree on it. The df -i output is the following:
/dev/mapper/system-src   120K     96K     25K   80% /usr/src

I checked the mke2fs.conf files on both computer and the default inode
ratio is set to 16384 on the 2 systems.

François


--------------020902070607060300020809
Content-Type: text/plain;
 name="dump-prob"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dump-prob"

Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          f0c32b27-a50f-40ea-999f-bea17ac620d9
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              45120
Block count:              180224
Reserved block count:     9011
Free blocks:              173110
Free inodes:              45109
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      43
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         7520
Inode blocks per group:   470
Flex block group size:    16
Filesystem created:       Mon Nov  3 00:35:25 2008
Last mount time:          Mon Nov  3 00:35:31 2008
Last write time:          Mon Nov  3 00:35:31 2008
Mount count:              1
Maximum mount count:      27
Last checked:             Mon Nov  3 00:35:25 2008
Check interval:           15552000 (6 months)
Next check after:         Sat May  2 01:35:25 2009
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      c29d076b-7903-4f63-bc67-fcf72f753cf7
Journal backup:           inode blocks
Journal size:             16M


--------------020902070607060300020809--

