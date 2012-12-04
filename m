From: Tao Ma <tm@tao.ma>
Subject: Re: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Tue, 04 Dec 2012 23:29:48 +0800
Message-ID: <50BE16EC.6060501@tao.ma>
References: <CALOAHbDC8jguV7GeSuN01UWBk+74wVHho8Fe9HLan06FZSpw0g@mail.gmail.com> <50BCE885.8010609@redhat.com> <50BE007D.5080504@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	wuqixuan@huawei.com, wuqixuan@gmail.com
To: Li Zefan <lizefan@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:48750 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753145Ab2LDP35 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2012 10:29:57 -0500
In-Reply-To: <50BE007D.5080504@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi zefan,
On 12/04/2012 09:54 PM, Li Zefan wrote:
>>> We have many x86 boards, and we've been using 2.6.16.60 for a long
>>> time. Before time we occasionally found ext3 was switched to read-only
>>> while services were running, and we took it for granted it must be
>>> some hardware problems.
>>>     But recently this issue happens frequently, both in old boards and
>>> new boards. We've analyzed logs, and in one board we did find
>>> exceptional reboot (but ext3 error happened 9 days after), and in
>>> another board we found mptbase recovery routine, but in all other
>>> boards there's no suspicious output at all.
>>>     The only change with the system is some application updates, and
>>> apps now put more IO burden on disks.
>>>     The error always happened in ext3_readdir, like this:
>>>
>>> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory#6685458: rec_len is smaller than minimal - offset=3860, inode=0, rec_len=0, name_len=0
>>> Aborting journal on device sda7.
>>> EXT3-fs error (device sda7) in start_transaction: Readonly filesystem
>>> Aborting journal on device sda7.
>>> ext3_abort called.
>>> EXT3-fs error (device sda7): ext3_journal_start_sb: Detected aborted journal
>>> Remounting filesystem read-only
>>> __journal_remove_journal_head: freeing b_committed_data
>>>
>>> We highly doubt it's hardware failures with this frequency in mind, so
>>> we're wondering regarding to this issue if there's some ext3 bug-fix
>>> having merged into mainline but not in our old kernel?
>>
>> Absolutely there are.  There have been 87 changes just to namei.c since 2.6.16.
>> You could look through git logs to see if anything looks applicable.
>>
>> You might try:
>>
>> ef2b02d3e617cb0400eedf2668f86215e1b0e6af ext34: ensure do_split leaves enough free space in both blocks
> 
> I've been asked to investigate this issue. Thanks for the reply!
> 
> I found this fix while searching for similar bug reports, but I don't think it
> worths trying as we don't use dir_index feature.
> 
> I've collected some logs in different machines, and the error was always
> triggered in ext3_readdir:
> 
> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #6685458: rec_len is smaller than minimal - offset=3860, inode=0, rec_len=0, name_len=0
> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #9650541: rec_len is smaller than minimal - offset=3960, inode=0, rec_len=0, name_len=0
> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #11124783: rec_len is smaller than minimal - offset=4072, inode=0, rec_len=0, name_len=0
> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #52740880: rec_len is smaller than minimal - offset=4024, inode=0, rec_len=0, name_len=0
> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #52740880: rec_len is smaller than minimal - offset=4084, inode=0, rec_len=0, name_len=0
> 
> The last two errors happened on the same machine, and the same inode! One
> happened in 11/22 (I was told they had run fsck later on), and one in 12/01.
So now this directory has been fscked to be right? You can try by just
ls this directory and check whether there are any errors in dmesg.

Having said that, as this error happens 2 times for the same inode,
maybe there is a kernel bug. At least as Ted said in another mail, the
end of this buffer head seems to be cleared. So I guess next time when
you see this error, please do:
1. use debugfs to find the disk layout for this dir
2. read the blocks from the block device directly
3. check whether the end of a block(from offset to the end) is zeroed.
4. If yes, I guess there should be a kernel bug and we can go on to
investigate the code.

Thanks
Tao
> 
> The offset is always a bit smaller than blocksize, and all the fields are 0.
> I dumped one of the dirs, and only ~1.6K was used (fsck reported no error).
> 
> In some machines fsck reported no error at all, and in others filesystems
> were corrupted though fixable.
> 
> I didn't see any other error messages before this error at all.
> 
> Does this remind you of some old ext3 bug?
> 
> I'll send you fsck output, dir contents and other logs if u'r interested.
> 
>>
>> but to be honest, sticking with such an old kernel means you are largely on your own, or may need contract help if you can't resolve it.
>>
> 
> There're numerous machines running old kernels, and many of them are hard to
> change. :(
> 
> Yesterday they upgrade apps on ~30 machines, and soon after that 5 machines
> had filesystem corrupted. However they won't stop upgrading other machines!
> 
> On the other hand, we can hardly reproduce this bug in the lab.
> 
> So this is critical and urgent. Any help is appreciated.
> 
> Regards
> Li Zefan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

