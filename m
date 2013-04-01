From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: EXT4 nodelalloc => back to stone age.
Date: Tue, 02 Apr 2013 00:34:33 +0800
Message-ID: <5159B719.8060804@gmail.com>
References: <87d2uese6t.fsf@openvz.org> <5159A55B.1090302@redhat.com> <20130401153952.GE4731@thunk.org> <5159AF21.1050805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
	Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:50538 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758899Ab3DAQer (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Apr 2013 12:34:47 -0400
In-Reply-To: <5159AF21.1050805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,

On 04/02/2013 12:00 AM, Eric Sandeen wrote:
> On 4/1/13 10:39 AM, Theodore Ts'o wrote:
>> On Mon, Apr 01, 2013 at 10:18:51AM -0500, Eric Sandeen wrote:
>>> I'd add:
>>>
>>> 3) Why do we have a "nodelalloc" mount option at all?
>>>
>>> but then I thought:
>>>
>>> Is it also this bad when using the ext4 driver to run an ext3 fs?
>>
>> Yes, and I there would be a similar performance problem if you are
>> using the ext3 file system driver, since ext3_*_writepage() also ends
>> up calling block_write_full_page() which will also result in the
>> writes happening with WRITE_SYNC.
> 
>> The main reason why we keep nodelalloc at this point is bug-for-bug
>> compatibility with ext3 file systems --- basically, for users who are
>> using this as a workaround for the O_PONIES issue instead of fixing
>> their applications to use fsync() appropriately.
> 
> Sorry for getting off the original thread here, but IMHO these are
> 2 different things:
> 
> nondelalloc behavior makes sense for ext3, but:
> -o nodelalloc mount options don't make sense for ext4.

nodelalloc makes sense to me.  In our product system, we met a latency
problem that is caused by delalloc feature.  The workload is a web app
that does some append writes (approximately 5M/s), and wait flusher to
do write out.  We obverse that on every 30 seconds the latency will
reach a high level (approximately 100-200ms or higher, but normally
10-20ms).  The reason is that when flush tries to write dirty pages out,
it will take i_data_sem lock (write lock) and allocate some blocks for
these dirty pages.  But in the mean time the app does some append
write(2)s that will try to take i_data_sem lock (read lock) too.  So the
app will be delayed.  So I think nodelalloc is still useful for us.

Regards,
						- Zheng


