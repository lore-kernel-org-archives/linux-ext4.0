From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Tue, 04 Dec 2012 17:11:37 +0100
Message-ID: <50BE20B9.1050404@itwm.fraunhofer.de>
References: <CALOAHbDC8jguV7GeSuN01UWBk+74wVHho8Fe9HLan06FZSpw0g@mail.gmail.com> <50BCE885.8010609@redhat.com> <50BE007D.5080504@huawei.com> <50BE16EC.6060501@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Li Zefan <lizefan@huawei.com>, Eric Sandeen <sandeen@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	wuqixuan@huawei.com, wuqixuan@gmail.com
To: Tao Ma <tm@tao.ma>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <50BE16EC.6060501@tao.ma>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 12/04/2012 04:29 PM, Tao Ma wrote:
>> The last two errors happened on the same machine, and the same inode! One
>> happened in 11/22 (I was told they had run fsck later on), and one in 12/01.
> So now this directory has been fscked to be right? You can try by just
> ls this directory and check whether there are any errors in dmesg.
> 
> Having said that, as this error happens 2 times for the same inode,
> maybe there is a kernel bug. At least as Ted said in another mail, the
> end of this buffer head seems to be cleared. So I guess next time when
> you see this error, please do:
> 1. use debugfs to find the disk layout for this dir
> 2. read the blocks from the block device directly
> 3. check whether the end of a block(from offset to the end) is zeroed.
> 4. If yes, I guess there should be a kernel bug and we can go on to
> investigate the code.

I still don't know if it is related to htree only, but e2fsck isn't
properly fixing directory issues without the "-D" option.
For example I have a VM here, where the kernel frequently reports
something like:

> [  304.096059] EXT4-fs (vdb): error count: 4
> [  304.096305] EXT4-fs (vdb): initial error at 1352366631: htree_dirblock_to_tree:861: inode 3146582: block 1641814
> [  304.096857] EXT4-fs (vdb): last error at 1352381914: empty_dir:2334: inode 3146582: block 1641814
> [86807.520052] EXT4-fs (vdb): error count: 4

and e2fsck does not report anything. Also the dir_entry_type is for some
dirs wrongly reported by the kernel, but seen correctly by e2fsck
(https://bugzilla.kernel.org/show_bug.cgi?id=50261).

I hope to find some time to investigate that next week. I have seen it
several times already, but never had the chance to investigate or to
take an image.

So I would really recommend to run "e2fsck -D" for the issue reported here.

Cheers,
Bernd


Cheers,
Bernd
