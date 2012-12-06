From: qixuan wu <wuqixuan@gmail.com>
Subject: Re: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Fri, 7 Dec 2012 00:21:25 +0800
Message-ID: <CAEjEV8CpTT1Sk5g=FkGL2VEa_sW4go1jpNeFh=jDcdKWN_n2XQ@mail.gmail.com>
References: <CALOAHbDC8jguV7GeSuN01UWBk+74wVHho8Fe9HLan06FZSpw0g@mail.gmail.com>
	<50BCE885.8010609@redhat.com>
	<50BE007D.5080504@huawei.com>
	<20121204150928.GF29083@thunk.org>
	<50BF2537.6070809@huawei.com>
	<50BF597D.3040704@tao.ma>
	<50BFF149.6080007@huawei.com>
	<20121206123744.GA17951@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Li Zefan <lizefan@huawei.com>, Tao Ma <tm@tao.ma>,
	"Theodore Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	wuqixuan@huawei.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20121206123744.GA17951@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Kara,

On Thu, Dec 6, 2012 at 8:37 PM, Jan Kara <jack@suse.cz> wrote:
> On Thu 06-12-12 09:13:45, Li Zefan wrote:
>> >> I found this in one log:
>> >>
>> >> Nov 14 05:26:55 kernel: EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #7225391: rec_len is smaller than minimal - offset=3952, inode=0, rec_len=0, name_len=0
>> >> Nov 14 13:42:40 kernel: EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #7225391: rec_len is smaller than minimal - offset=4024, inode=0, rec_len=0, name_len=0
>> >> Nov 16 17:29:40 kernel: EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #7225391: rec_len is smaller than minimal - offset=4084, inode=0, rec_len=0, name_len=0
>> >> Nov 23 19:42:44 kernel: EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #7225391: rec_len is smaller than minimal - offset=3952, inode=0, rec_len=0, name_len=0
>   Sorry for posting here in the thread but I got unsubscribed from the
> list so I don't have the beginning of the thread in my inbox.
>
>   ext3 directory format is such that the last directory entry in the block
> should have length to exactly fill up the whole block. Apparently, the
> length got trimmed for some reason so we ended up before end of directory
> block looked of another directory entry there and didn't find anything. I
> will also make one observation regarding offsets. They are 3952, 4024, and
> 4084. If we subtract that from 4096 (block size), we get differences (in
> binary) 10010000, 01001000, 00001100. Interestingly these have always two
> bits set. Might be luck but need not...

Yes, we also found the interesting things that the offset happen in
many boards are like below:
1) 3952
2) 3988( 3952+36)
3) 4024( 3988+36)
4) 4048(4042+24)
5) 4084(same as the rec_len of ".." file if there isn't any file).

I need introduce the rule of the files in the dir, for example:
.
..
current_log.txt (len is 15, rec_len is 24 when there is file after it,
the value "24" i think has relative with  offset 4048)
20120526124556.865213.txt(len is 25, rec_len is 36 when there is file after it).
20120526124984.239475.txt(len is 25, rec_len is 36 when there is file after it).
....
Because the rec_len is 36, it has some relative with those offset
values( the diff of those values are multiple of 36).
I need tell another thing, customer's app invoke opendir/readdir very
frequently. There are more than 1000 times, every second(the value
need to be confirmed).

> Anyway it would be interesting to get the dump of the corrupted directory
> before e2fsck is run. You can do that by running:
>   debugfs -R "dump_inode <7225391> /tmp/corrupted_dir" /dev/sda7
>
> Then you can send the dump of the corrupted directory here.

We have already dump of the data by debugfs. The data is very good
without error. But we just did it before fsck, even the fsck is not
giving any error. I want to know whether fsck will modify disk data
without reporting any error or not ?

>> >> Happend 4 times, the same inode, different offsets. Another log showed the
>> >> same pattern.
>> >>
>> >> They said they ran fsck everytime this happened. Many machines got this problem,
>> >> but they remember most of the time fsck didn't report error.(*)
>> >>
>> >> I've checked the pathname, and they all points to log dirs. There're 2 kinds
>> >> of log dirs with different loggers, but seems work similarly.
>> >>
>> >> Except one bug report, all others point to exactly the same log dir.
>> >>
>> >> There're two processes that will touch this dir. One is a monitor, it will
>> >> delete old logs if they occupy too much space, but normally this shouldn't
>> >> happen.
>> >>
>> >> Another is the logger. When it wants to log sth, it scans the directory, if
>> >> there're more than 100 log files, it will delete the oldest one. After writting
>> >> to the current log file, if the file is larger than 8M, this file will be
>> >> renamed as a backup log. I haven't read the code yet. But sounds pretty
>> >> simple, right?
>> >>
>> >> The length of the file name is 25. There were 35 logs dating from 2012/11/02
>> >> to 2012/11/23, and no pending deleted files. Thus the remaining ~2.8K of the
>> >> dir block is never used, so I don't think something zeroed it because it
>> >> has always been zero.
>> > Only 35 files? So there should be no rename. And the only possible
>>
>> Yes, there can be. The curren log will be renamed when it reaches 8M, and then
>> a new log is created as the current log.
>   Yep. Still the load looks extremely simple. We use 2.6.16 based kernels
> in our SLES distros and I never heard about such corruption. Strange.
>
>> > action we do to this dir is "create a new log file", right? Then, I
>> > really don't think ext3 will error in such a simple test case. :(
>> >
>> >>
>> >> This log dir is new in this version, while the other one also exists in
>> >> old verison, with less IO.
>> > You mean the kernel version? Sorry, but what do you want to tell us here?
>>
>> The versions of the apps. One of the differences between them is the log system,
>> and the old apps won't trigger this ext3 error.
>   Indeed, this is even stranger...
>
>                                                                         Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

Thanks
wuqixuan.
