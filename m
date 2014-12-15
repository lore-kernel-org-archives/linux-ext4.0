From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: Call trace in ext4_es_lru_add on 3.10 stable
Date: Mon, 15 Dec 2014 10:48:26 +0100
Message-ID: <548EAE6A.5010209@profihost.ag>
References: <20140922202004.GF4572@thunk.org> <54212641.9010808@profihost.ag> <20140923094204.GB2359@quack.suse.cz> <54216641.8090608@profihost.ag> <20140923144340.GI2359@quack.suse.cz> <54758A13.20209@profihost.ag> <20141126082552.GB20176@quack.suse.cz> <5475EDA9.2070600@profihost.ag> <20141126202638.GA30152@quack.suse.cz> <54807880.40203@profihost.ag> <20141204183539.GB23273@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	"p.herz@profihost.ag >> Philipp Herz - Profihost AG"
	<p.herz@profihost.ag>, stable@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20141204183539.GB23273@quack.suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,
Am 04.12.2014 um 19:35 schrieb Jan Kara:
> On Thu 04-12-14 16:06:40, Stefan Priebe - Profihost AG wrote:
>>
>> Am 26.11.2014 um 21:26 schrieb Jan Kara:
>>> On Wed 26-11-14 16:11:37, Stefan Priebe - Profihost AG wrote:
>>>> Am 26.11.2014 um 09:25 schrieb Jan Kara:
>>>>>   Hi,
>>>>>
>>>>> On Wed 26-11-14 09:06:43, Stefan Priebe - Profihost AG wrote:
>>>>>> i'm still getting a lot of those call traces:
>>>>>> "
>>>>>> Call Trace:
>>>>>>  [<ffffffffa01d7006>] ext4_es_lru_add+0x26/0x80 [ext4]
>>>>>>  [<ffffffffa01d7286>] ext4_es_insert_extent+0x96/0x100 [ext4]
>>>>>>  [<ffffffffa01c3fd3>] ? ext4_find_delalloc_range+0x23/0x60 [ext4]
>>>>>>  [<ffffffffa019b781>] ext4_map_blocks+0x111/0x450 [ext4]
>>>>>>  [<ffffffffa019d167>] _ext4_get_block+0x87/0x190 [ext4]
>>>>>>  [<ffffffffa019d2c6>] ext4_get_block+0x16/0x20 [ext4]
>>>>>>  [<ffffffff8117f73f>] generic_block_bmap+0x3f/0x50
>>>>>>  [<ffffffffa013f4ae>] ? jbd2_journal_file_buffer+0x4e/0x80 [jbd2]
>>>>>>  [<ffffffff810f6242>] ? mapping_tagged+0x12/0x20
>>>>>>  [<ffffffffa019ad71>] ext4_bmap+0x91/0xf0 [ext4]
>>>>>>  [<ffffffff811686de>] bmap+0x1e/0x30
>>>>>>  [<ffffffffa0148063>] jbd2_journal_bmap+0x33/0xb0 [jbd2]
>>>>>>  [<ffffffffa014831d>] jbd2_journal_next_log_block+0x7d/0x90 [jbd2]
>>>>>>  [<ffffffffa0140238>] jbd2_journal_commit_transaction+0x7f8/0x1ae0 [jbd2]
>>>>>>  [<ffffffff81084e13>] ? idle_balance+0xd3/0x110
>>>>>>  [<ffffffff8105a018>] ? lock_timer_base.isra.35+0x38/0x70
>>>>>>  [<ffffffffa014593a>] kjournald2+0xba/0x230 [jbd2]
>>>>>>  [<ffffffff81070360>] ? finish_wait+0x80/0x80
>>>>>>  [<ffffffffa0145880>] ? jbd2_journal_release_jbd_inode+0x130/0x130 [jbd2]
>>>>>>  [<ffffffff8106fb60>] kthread+0xc0/0xd0
>>>>>>  [<ffffffff8106faa0>] ? kthread_create_on_node+0x130/0x130
>>>>>>  [<ffffffff81554c2c>] ret_from_fork+0x7c/0xb0
>>>>>>  [<ffffffff8106faa0>] ? kthread_create_on_node+0x130/0x130
>>>>>> "
>>>>>>
>>>>>> Is there any chance to fix them in vanilla 3.10.61?
>>>>>   Ted is just testing patches to fix these. You are welcome if you can give
>>>>> them a try as well (tarball attached). I'm not sure patches will be
>>>>> backported as far as to 3.10-stable but when the patches get some testing
>>>>> in mainline, I'll be porting them to 3.12-stable for our enterprise
>>>>> kernel...
>>>>
>>>> OK i tried to port them to 3.10 but it seems i can't handle this. There
>>>> are so many differences. Are there any workarounds possible? Currently
>>>> the 3.10 kernel is also completely crashing with this backtrace.
>>>   No workarounds I'm aware of. Sorry. When I have patches for 3.12, you can
>>> try porting them to 3.10. That should be an easier task...
>>>
>>> 								Honza
>>
>> those patches work absolutely fine on a 3.16 kernel. Do you have any
>> idea, when your 3.12 backport is done?
>   Thanks for confirmation. I hope to backport the patches sometime next
> week.

Do you had some time last week?

Stefan
