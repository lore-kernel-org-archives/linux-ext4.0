From: lokesh jaliminche <lokesh.jaliminche@gmail.com>
Subject: Re: ext2/3 using ext4 module mkdir IO error on pmem DAX mount
Date: Fri, 4 Mar 2016 23:56:37 +0530
Message-ID: <CAKJOkCpaLDhxar1nBErxBFp4J9CeK=qNzNYTGsA5X5ryM0a_Ow@mail.gmail.com>
References: <20160302064304.GA15559@dhcp12-144.nay.redhat.com>
	<20160303002824.GA31238@linux.intel.com>
	<CAKJOkCoLEs2cQuS+CeciUY39ErQeOYmkQ_Jj4gHePPTUTMngrA@mail.gmail.com>
	<20160303234904.GF24012@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>,
	lokesh jaliminche <lokesh.jaliminche@gmail.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Xiong Zhou <xzhou@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-nvdimm@ml01.01.org,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20160303234904.GF24012@thunk.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ok, no issues and thanks for the information above.I will take care of
these things while sending corrected version of this patch.

Thanks & Regards,
      Lokesh

On Fri, Mar 4, 2016 at 5:19 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Mar 03, 2016 at 10:49:51PM +0530, lokesh jaliminche wrote:
>> Hi,
>>    I have tested it locally I am also getting same error but not
>> consistently. I have put some debug logs for debugging, as per the logs
>> it seems that block_group is not getting initialized properly. I am
>> not sure weather this is because of my patch. Need to debug more.
>
> I'm quite sure it's your patch, so I'm going to drop it for now.  Note
> that with ext3, we don't have flex_bg's (the flex_bg size is 1).
>
> Here's a reliable repro:
>
>         kvm-xfstests --no-log -c ext3 generic/003
>
> For more about kvm-xfstests
>
> https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/tree/quick-start?h=META
>
> Output from running this test:
>
> BEGIN TEST ext3: Ext4 4k block emulating ext3 Thu Mar  3 18:39:33 EST 2016
> DEVICE: /dev/vdd
> MK2FS OPTIONS: -q -O ^extents,^flex_bg,^uninit_bg,^64bit,^metadata_csum,^huge_file,^dir_nlink,^extra_isize
> MOUNT OPTIONS: -o block_validity,nodelalloc
> FSTYP         -- ext4
> PLATFORM      -- Linux/i686 kvm-xfstests 4.5.0-rc2-00026-g1f2d779
> MKFS_OPTIONS  -- -q -O ^extents,^flex_bg,^uninit_bg,^64bit,^metadata_csum,^huge_file,^dir_nlink,^extra_isize /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,nodelalloc /dev/vdc /vdc
>
> generic/003             [18:39:35][   13.096353] run fstests generic/003 at 2016-03-03 18:39:35
> [   14.859764] EXT4-fs error (device vdc): ext4_get_group_desc:288: comm mkdir: block_group >= groups_count - block_group = 850480444, groups_count = 40
> [   16.944808] EXT4-fs (vdc): warning: mounting fs with errors, running e2fsck is recommended
> [   16.956276] EXT4-fs error (device vdc): ext4_get_group_desc:288: comm mkdir: block_group >= groups_count - block_group = 3221700656, groups_count = 40
> [   19.023011] EXT4-fs (vdc): warning: mounting fs with errors, running e2fsck is recommended
> [   22.104702] EXT4-fs (vdc): warning: mounting fs with errors, running e2fsck is recommended
>  [18:39:46] - output mismatch (see /results/results-ext3/generic/003.out.bad)
>     --- tests/generic/003.out   2016-02-29 22:18:21.000000000 -0500
>     +++ /results/results-ext3/generic/003.out.bad       2016-03-03 18:39:46.587676694 -0500
>     @@ -1,2 +1,46 @@
>      QA output created by 003
>     +mkdir: cannot create directory '/vdc/dir1': Input/output error
>     +./tests/generic/003: line 93: /vdc/dir1/file1: No such file or directory
>     +stat: cannot stat '/vdc/dir1/file1': No such file or directory
>     +cat: /vdc/dir1/file1: No such file or directory
>     +stat: cannot stat '/vdc/dir1/file1': No such file or directory
>     +ERROR: access time has not been updated after accessing file1 first time
>     ...
>     (Run 'diff -u tests/generic/003.out /results/results-ext3/generic/003.out.bad'  to see the entire diff)
> Ran: generic/003
> Failures: generic/003
> Failed 1 of 1 tests
>
> (In fact a huge number of tests fail using the ext3 configuration, but
> generic/003 is a quick fast test.  Before submitting patches, please
> run at the very least "kvm-xfstests smoke".  Admittedly, for this bug
> the smoke test wouldn't have been enough.  You would have needed
> "kvm-xfstests-g quick", or preferably, "kvm-xfstests -g auto".
> Alternatively, you can use gce-xfstests, which uses Google Compute
> Engine where you can just fire off the tests, and it will send you
> e-mail with the test results.  See
> https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/tree/kvm-xfstests/README.GCE
> for more information.)
>
>                                                         - Ted
