From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT3 fuzzing
Date: Fri, 27 Oct 2006 11:44:11 -0500
Message-ID: <4542375B.5020209@redhat.com>
References: <20061027151445.GA13599@alice> <4542251C.9050603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57313 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1752339AbWJ0QoR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Oct 2006 12:44:17 -0400
To: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <4542251C.9050603@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> Eric Sesterhenn / Snakebyte wrote:
>> hi,
>>
>> after fsfuzz
>> (http://www.securityfocus.com/archive/1/449568/30/0/threaded) was
>> released i decided to give it a spin. So far I got two problematic
>> images:
>>
>> http://www.cobra-basket.de/ext3_ls_prozzy_hog.img.bz2
>> 	which makes the kernel use as much cpu as it can get
>>
>> http://www.cobra-basket.de/ext3_memhog.img.bz2
>> 	eats all memory it can get

Works for me w/ that patch:

[root@link-07 ~]# mount -o loop ext3_ls_prozzy_hog.img mnt/
[root@link-07 ~]# ls mnt/
[root@link-07 ~]# dmesg | tail -n 6
EXT3-fs: mounted filesystem with ordered data mode.
EXT3-fs error (device loop0): htree_dirblock_to_tree: bad entry in
directory #2: rec_len % 4 != 0 - offset=24, inode=11, rec_len=989,
name_len=10
Aborting journal on device loop0.
ext3_abort called.
EXT3-fs error (device loop0): ext3_journal_start_sb: Detected aborted
journal
Remounting filesystem read-only


[root@link-07 ~]# mount -o loop ext3_memhog.img mnt/
[root@link-07 ~]# ls mnt
[root@link-07 ~]# dmesg | tail -n 6
EXT3-fs: mounted filesystem with ordered data mode.
EXT3-fs error (device loop0): htree_dirblock_to_tree: bad entry in
directory #2: rec_len is smaller than minimal - offset=0, inode=75,
rec_len=0, name_len=0
Aborting journal on device loop0.
ext3_abort called.
EXT3-fs error (device loop0): ext3_journal_start_sb: Detected aborted
journal
Remounting filesystem read-only

-Eric
