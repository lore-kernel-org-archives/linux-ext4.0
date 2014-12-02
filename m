From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: inline_data,metadata_csum  a lot of bad csum for directories
Date: Mon, 1 Dec 2014 22:58:13 -0500
Message-ID: <20141202035813.GB953@thunk.org>
References: <877fybcvho.fsf@openvz.org>
 <32FC5424-8CFB-4D12-A201-1BFDD1552460@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33483 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932938AbaLBD6U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Dec 2014 22:58:20 -0500
Content-Disposition: inline
In-Reply-To: <32FC5424-8CFB-4D12-A201-1BFDD1552460@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 01, 2014 at 04:32:02PM -0700, Andreas Dilger wrote:
> On Dec 1, 2014, at 7:09 AM, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> > 
> > Ted can you please clarify what is status of inline_data patchset.
> > I've enabled inline_data testing in my test environment
> 
> I suspect that since inline_data and metadata_csum were developed
> in isolation, they don't work well together yet.  I believe that
> Darrick is working on fixing some issues in this area.

The standard xfstests-bld test configuration is with inline_data and
metadata_csum in combination:

export FS=ext4
export TEST_DEV=$SM_TST_DEV
export TEST_DIR=$SM_TST_MNT
export MKFS_OPTIONS="-q -I 256 -O inline_data,metadata_csum,64bit"
export EXT_MOUNT_OPTIONS="-o block_validity"
TESTNAME="Ext4 4k block w/inline"

Are you using the very latest version of e2fsprogs.git#next branch for
your tests?  If not, that could be why you are getting some test
failures.  It is absolutely required for any tests involving
metdata_csum.

I have a xfstests-build 32-bit rootfs.img I can upload for your
convenience if that's what you are using.  Getting a formally upgraded
xfstests-bld rootfs.img with the latest xfstests and some other bug
fixes and the latest e2fsprogs was on my todo list; sorry, the
metadata csum v3 patches that went in in 3.18-rc3 required an updated
e2fsprogs that's not in the released rootfs.img.

> > Please post your test matrix
> > 
> > My config:
> > e2fsprogs git commit: g210baa5

OK, that should be sufficiently up to date.  As far as my test matrix,
please see:

http://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/tree/kvm-xfstests/test-appliance/files/root/conf

with these test versions:

e2fsprogs	v1.42.12-415-gf0a7814 (Sun, 23 Nov 2014 20:32:08 -0500)
fio		fio-2.1.13-77-g0f9940a (Wed, 15 Oct 2014 14:16:35 -0600)
quota		f215e3f (Mon, 2 Dec 2013 23:06:23 -0300)
xfsprogs	v3.2.1-6-gba24eb7 (Fri, 18 Jul 2014 10:47:11 +1000)
xfstests-bld	2a20a9d (Fri, 31 Oct 2014 10:08:53 -0400)
xfstests	linux-v3.8-523-g481c28f (Tue, 14 Oct 2014 22:59:39 +1100)

> > ext4.git commit: recent tytso/dev ca83cc75a16f67
> > ./kvm-xfstests -c inline generic/011  generic/013
> > generic/013       [13:51:44]
> > [  368.507266] EXT4-fs error (device vdd): ext4_iget:3918: inode #294: comm rm: checksum invalid
> > [  368.511098] EXT4-fs error (device vdd): ext4_iget:3918: inode #294: comm rm: checksum invalid
> > [  369.098863] EXT4-fs error (device vdd): ext4_iget:3918: inode #2108:comm rm: checksum invalid

Hmm, works for me:

./kvm-xfstests -c inline generic/011  generic/013

BEGIN TEST: Ext4 4k block w/inline Mon Dec  1 22:56:21 EST 2014
Device: /dev/vdd
mk2fs options: -q -I 256 -O inline_data,metadata_csum,64bit
mount options: -o block_validity
FSTYP         -- ext4
PLATFORM      -- Linux/i686 kvm-xfstests 3.18.0-rc3-00530-g32f3869
MKFS_OPTIONS  -- -q -I 256 -O inline_data,metadata_csum,64bit /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc

generic/011 2s ...  [22:56:24] [22:56:26] 2s
generic/013 47s ... [22:56:26] [22:57:21] 55s
Ran: generic/011 generic/013
Passed all 2 tests

						- Ted
