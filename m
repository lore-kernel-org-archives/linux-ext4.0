From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: jbd2 inside a device mapper module
Date: Thu, 25 Dec 2008 10:52:48 -0500
Message-ID: <20081225155248.GJ9871@mit.edu>
References: <20081224211038.GT4127@blitiri.com.ar>
	<20081224234915.GA23723@mit.edu>
	<20081225143535.GA4127@blitiri.com.ar>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dm-devel@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Alberto Bertogli <albertito@blitiri.com.ar>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20081225143535.GA4127@blitiri.com.ar>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 25, 2008 at 12:35:35PM -0200, Alberto Bertogli wrote:
> 
> Thanks. I've found and tried that (that's what I meant with the
> paragraph you quote), but I couldn't make it work.

See attached transcript.  I did it using lvm/dm just to show it's not
an devicemapper problem.

> The first problem I stumbled upon was that jbd2_journal_create() doesn't
> like journals initialized using jbd2_journal_init_dev() (because it has
> no j_inode). I had two choices: or try to create the journal some other
> way, or remove the j_inode test in jbd2_journal_create().

ext4_journal_create is ancient code dating back to ext3/jbd, and even
there it's code which has been obsolete for about 6-7 years.  In fact,
I plan to remove ext4_journal_create, the journal_inum mount option,
and jbd2_journal_init_dev, because the supported way of creating a
journal is using mke2fs.  I need to double check and make sure ocfs2
isn't using jbd2_journal_init_dev before I remove it from the jbd2
layer, but really, this sort of thing should be done all in userspace.

> Then I tried to create the journal using mke2fs as you described, but
> jbd2_journal_load() fails when trying to load it.

See attached.   Works fine for me.

>  - Why does __bread() gets stucked when called from inside a dm map
>    function? It looks like it's waiting on a buffer_head, but why?

I'm not a dm guy, so I can't answer this, but I suspect the issue may
be a lock ordering issue.

>  - What is the reason behind the j_inode check in jbd2_journal_create()?

jbd2_journal_create was only designed for creating inode-based
journals, and it's a deprecated function that will likely be removed
soon.

>  - Does mke2fs -O journal_dev creates a journal that jbd2_journal_load()
>    is supposed to read without any knowledge of ext2/3/4 stuff? If not,
>    how can I create such a journal? I'll be looking at the e2fsprogs
>    code for the answer to this question later today (I haven't looked at
>    it yet).

mke2fs -O journal_dev creates an external journal, but when you create
a filesystem, you need to specify need to specify location of the
external journal.    Hence:

	 mke2fs -O journal_dev /dev/extern_journal_dev
	 mke2fs -t ext4 -J device=/dev/extern_journal_dev /dev/filesystem_dev

As I said in my last message.  I've tested it, and it works Just Fine.

     	     	     	       	    	       - Ted

Script started on Thu 25 Dec 2008 10:22:11 AM EST
Top-level shell (parent script)
Using forwarded ssh authentication socket
# lvs
  LV          VG    Attr   LSize   Origin Snap%  Move Log Copy% 
  ext3root    thunk -wi-a-  15.00G                              
  footest     thunk -wi-a-   1.00G                              
  foresight   thunk -wi-a-   5.00G                              
  old-root    thunk -wi-a- 128.00G                              
  rmake       thunk -wi-a-   2.00G                              
  root        thunk -wi-ao 128.00G                              
  sff-torrent thunk -wi-a-   7.00G                              
  testext4    thunk -wi-a-   1.00G                              
# mke2fs -O journal_dev /dev/thunk/footest
mke2fs 1.41.3 (12-Oct-2008)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
0 inodes, 262144 blocks
0 blocks (0.00%) reserved for the super user
First data block=0
0 block group
32768 blocks per group, 32768 fragments per group
0 inodes per group
Superblock backups stored on blocks: 

Zeroing journal device:   done                            
# mke2fs -t ext4 -J device=/dev/thunk/footest /dev/thunk/testext4
mke2fs 1.41.3 (12-Oct-2008)
Using journal device's blocksize: 4096
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
65536 inodes, 262144 blocks
13107 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=268435456
8 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376

Writing inode tables: done                            
Adding journal to device /dev/thunk/footest: done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 29 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
# dumpe2fs -h /dev/thunk/testext4
dumpe2fs 1.41.3 (12-Oct-2008)
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          47b3315f-7b0d-40ab-995e-de1ddaaf3528
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              65536
Block count:              262144
Reserved block count:     13107
Free blocks:              257701
Free inodes:              65525
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      63
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Thu Dec 25 10:23:12 2008
Last mount time:          n/a
Last write time:          Thu Dec 25 10:23:12 2008
Mount count:              0
Maximum mount count:      29
Last checked:             Thu Dec 25 10:23:12 2008
Check interval:           15552000 (6 months)
Next check after:         Tue Jun 23 11:23:12 2009
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal UUID:             484902c6-34a5-4cd2-9f66-02a3251bfc9e
Journal device:	          0xfe06
Default directory hash:   half_md4
Directory Hash Seed:      2889d0e3-ca37-443d-b9a3-12e3b0e26d70

# mount /dev/thunk/testext4 /mnt
# df /mnt
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/thunk-testext4
                       1032088      1284    978376   1% /mnt
# umount /mnt
# exit

Script done on Thu 25 Dec 2008 10:23:37 AM EST
