From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: sanity check the block and cluster size at
 mount time
Date: Fri, 18 Nov 2016 12:58:39 -0500
Message-ID: <20161118175838.q67hqgjdtydnl22f@thunk.org>
References: <5ce3de05-2f37-6758-1178-ecf520c87d4f@kyup.com>
 <20161118042610.13464-1-tytso@mit.edu>
 <955b7ea8-2fb2-a958-bb8a-5b5003668765@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, bp@alien8.de,
        stable@vger.kernel.org
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <955b7ea8-2fb2-a958-bb8a-5b5003668765@kyup.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 18, 2016 at 09:40:02AM +0200, Nikolay Borisov wrote:
> 
> 
> On 11/18/2016 06:26 AM, Theodore Ts'o wrote:
> > If the block size or cluster size is insane, reject the mount.  This
> > is important for security reasons (although we shouldn't be just
> > depending on this check).
> > 
> > Ref: http://www.securityfocus.com/archive/1/539661
> > Ref: https://bugzilla.redhat.com/show_bug.cgi?id=1332506
> > Reported-by: Borislav Petkov <bp@alien8.de>
> > Reported-by: Nikolay Borisov <kernel@kyup.com>
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Cc: stable@vger.kernel.org
> 
> I just tested with the 3 patches applied on 4.9-rc4 and could still
> reproduce the issue.

I've just tested the dev branch on both x86 and x86_64 and it doesn't reproduce for me;

root@xfstests:~# mount -o ro,loop /tmp/OSS-2016-23-image  /mnt
mount: wrong fs type, bad option, bad superblock on /dev/loop0,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.
root@xfstests:~# dmesg | tail -3
[  910.472554] EXT4-fs (loop0): Unrecognized mount option "" or missing value
[  910.479708] EXT4-fs (loop0): failed to parse options in superblock: 
[  910.486279] EXT4-fs (loop0): Invalid log block size: 4286906368
root@xfstests:~# 

The critical patch should be:

    ext4: sanity check the block and cluster size at mount time

Can you double check your test?

Thanks,

						- Ted
