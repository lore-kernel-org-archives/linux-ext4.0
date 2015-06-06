From: Wen Congyang <ghostwcy@gmail.com>
Subject: Re: Re-2: Strange problems with lseek in qemu-img map
Date: Sat, 06 Jun 2015 11:53:50 +0800
Message-ID: <55726ECE.70101@gmail.com>
References: <00056481.556F34D3@pegasus.munzinger.de>	<20150605140515.GB30104@stefanha-thinkpad.redhat.com>
	<alpine.LFD.2.00.1506051711390.13926@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: David Weber <wb@munzinger.de>, linux-ext4@vger.kernel.org,
	qemu-devel@nongnu.org, wenqing.lz@taobao.com
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>,
	Stefan Hajnoczi <stefanha@gmail.com>
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <alpine.LFD.2.00.1506051711390.13926@localhost.localdomain>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
List-Id: linux-ext4.vger.kernel.org

At 2015/6/5 23:14, Lukáš Czerner Wrote:
> On Fri, 5 Jun 2015, Stefan Hajnoczi wrote:
>
>> Date: Fri, 5 Jun 2015 15:05:15 +0100
>> From: Stefan Hajnoczi <stefanha@gmail.com>
>> To: David Weber <wb@munzinger.de>
>> Cc: qemu-devel@nongnu.org, linux-ext4@vger.kernel.org,
>>      Lukas Czerner <lczerner@redhat.com>, wency@cn.fujitsu.com
>> Subject: Re: [Qemu-devel] Re-2:  Strange problems with lseek in qemu-img map
>>
>> On Wed, Jun 03, 2015 at 03:09:40PM +0000, David Weber wrote:
>>>>> I then startet a fedora 22 live system and I saw the same problem. It
>>>>> happens
>>>>> on both the ramdisk and a ext4 filesystem.
>>>>
>>>> "it" == qemu-img map hangs or takes a very long time?
>>> I never waited for it to complete but I guess it just takes very long.
>>>
>>>>
>>>> Can you post a shell script that reproduces this with a ramdisk?  That
>>>> seems like the easiest way to get people debugging it.
>>>
>>> You can use the following commands.
>>>
>>> mkfs.ext4 /dev/ram0
>>> mkdir -p /mnt/tmp
>>> mount /dev/ram0 /mnt/tmp
>>> cd /mnt/tmp
>>> qemu-img create test 500G
>>> time qemu-img map test
>>>
>>> This takes foreover on all my systems.
>>
>> I experience the same thing on Linux 4.1.0-rc5 with ext4 (4 KB file
>> system block size, 512B device sector size).
>>
>> The lseek() calls take *seconds* to complete on a completely empty
>> (sparse) 500G file.
>>
>> Here is the perf-top(1) output:
>>
>>    34.08%  [kernel]                         [k] _raw_read_lock
>>    21.11%  [kernel]                         [k] ext4_es_lookup_extent
>>    20.67%  [kernel]                         [k] ext4_es_find_delayed_extent_range
>>     8.68%  [kernel]                         [k] ext4_map_blocks
>>     4.99%  [kernel]                         [k] ext4_llseek
>>     1.90%  [kernel]                         [k] rb_next
>>     0.14%  [kernel]                         [k] __fget
>>
>> Yikes!
>>
>> The syscall causing this is just:
>>
>> lseek(7, 0, SEEK_DATA)
>>
>> Lukas: I've CCed you because you have helped with ext4 issues in the
>> past.  Not sure if you have time or if this is your area.
>>
>> Stefan
>
> Hi,
>
> this is definitely an issue with extent status tree and I have not seen
> it before. I'll look at it first thing next week, but meanwhile I'll
> add Zheng Liu who is the author of the extent status tree so he
> might be able to help you.

It is an known bug, and Dmitry Monakhov tried to fix it:
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=14516bb7bb6ffbd49f35389f9ece3b2045ba5815

But this patch introduced another problem, and have been reverted.

Thanks
Wen Congyang

>
> Regards,
> -Lukas
>
>
