From: Li Zefan <lizefan@huawei.com>
Subject: Re: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Tue, 4 Dec 2012 21:54:05 +0800
Message-ID: <50BE007D.5080504@huawei.com>
References: <CALOAHbDC8jguV7GeSuN01UWBk+74wVHho8Fe9HLan06FZSpw0g@mail.gmail.com> <50BCE885.8010609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Yafang Shao <laoar.shao@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<wuqixuan@huawei.com>, <wuqixuan@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <50BCE885.8010609@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>> We have many x86 boards, and we've been using 2.6.16.60 for a long
>> time. Before time we occasionally found ext3 was switched to read-only
>> while services were running, and we took it for granted it must be
>> some hardware problems.
>>     But recently this issue happens frequently, both in old boards and
>> new boards. We've analyzed logs, and in one board we did find
>> exceptional reboot (but ext3 error happened 9 days after), and in
>> another board we found mptbase recovery routine, but in all other
>> boards there's no suspicious output at all.
>>     The only change with the system is some application updates, and
>> apps now put more IO burden on disks.
>>     The error always happened in ext3_readdir, like this:
>>
>> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory#6685458: rec_len is smaller than minimal - offset=3860, inode=0, rec_len=0, name_len=0
>> Aborting journal on device sda7.
>> EXT3-fs error (device sda7) in start_transaction: Readonly filesystem
>> Aborting journal on device sda7.
>> ext3_abort called.
>> EXT3-fs error (device sda7): ext3_journal_start_sb: Detected aborted journal
>> Remounting filesystem read-only
>> __journal_remove_journal_head: freeing b_committed_data
>>
>> We highly doubt it's hardware failures with this frequency in mind, so
>> we're wondering regarding to this issue if there's some ext3 bug-fix
>> having merged into mainline but not in our old kernel?
> 
> Absolutely there are.  There have been 87 changes just to namei.c since 2.6.16.
> You could look through git logs to see if anything looks applicable.
> 
> You might try:
> 
> ef2b02d3e617cb0400eedf2668f86215e1b0e6af ext34: ensure do_split leaves enough free space in both blocks

I've been asked to investigate this issue. Thanks for the reply!

I found this fix while searching for similar bug reports, but I don't think it
worths trying as we don't use dir_index feature.

I've collected some logs in different machines, and the error was always
triggered in ext3_readdir:

EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #6685458: rec_len is smaller than minimal - offset=3860, inode=0, rec_len=0, name_len=0
EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #9650541: rec_len is smaller than minimal - offset=3960, inode=0, rec_len=0, name_len=0
EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #11124783: rec_len is smaller than minimal - offset=4072, inode=0, rec_len=0, name_len=0
EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #52740880: rec_len is smaller than minimal - offset=4024, inode=0, rec_len=0, name_len=0
EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #52740880: rec_len is smaller than minimal - offset=4084, inode=0, rec_len=0, name_len=0

The last two errors happened on the same machine, and the same inode! One
happened in 11/22 (I was told they had run fsck later on), and one in 12/01.

The offset is always a bit smaller than blocksize, and all the fields are 0.
I dumped one of the dirs, and only ~1.6K was used (fsck reported no error).

In some machines fsck reported no error at all, and in others filesystems
were corrupted though fixable.

I didn't see any other error messages before this error at all.

Does this remind you of some old ext3 bug?

I'll send you fsck output, dir contents and other logs if u'r interested.

> 
> but to be honest, sticking with such an old kernel means you are largely on your own, or may need contract help if you can't resolve it.
> 

There're numerous machines running old kernels, and many of them are hard to
change. :(

Yesterday they upgrade apps on ~30 machines, and soon after that 5 machines
had filesystem corrupted. However they won't stop upgrading other machines!

On the other hand, we can hardly reproduce this bug in the lab.

So this is critical and urgent. Any help is appreciated.

Regards
Li Zefan

