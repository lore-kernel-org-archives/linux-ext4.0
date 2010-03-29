From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: 2.6.33.1: ext4 disk free weirdness
Date: Mon, 29 Mar 2010 12:51:00 -0500
Message-ID: <4BB0E884.5070500@redhat.com>
References: <20100329045748.GR2657@zip.com.au> <4BB0BDD2.3080100@redhat.com>	 <20100329145311.GA4671@thunk.org> <4BB0C0D2.1080303@redhat.com> <150c16851003291043l2fa17795o3b8339b2e04514ba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab0C2RvI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Mar 2010 13:51:08 -0400
In-Reply-To: <150c16851003291043l2fa17795o3b8339b2e04514ba@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Justin Maggard wrote:
> On Mon, Mar 29, 2010 at 8:01 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>> tytso@mit.edu wrote:
>>> On Mon, Mar 29, 2010 at 09:48:50AM -0500, Eric Sandeen wrote:
>>>> CaT wrote:
>>>>> Using kernel 2.6.33.1. Am rsyncing from /data/mirror (a raid0 mount) to
>>>>> /dev/sda1 (a usb HD). Both filesystems formatted as ext3 but mounted as
>>>>> ext4. /mnt filesystem is only being added to and currently large files
>>>>> (iso files 700MB-4.4GB) are being copied. When I remounted /mnt as ext3
>>>>> I could not duplicate the issue and the amount of disk used stabilised
>>>>> at 182G. The df results, whilst /mnt is mounted as ext4, are below:
>>>> I would say this is likely speculative allocation due to delalloc
>>>> (ext4 has to reserve worst-case metadata amounts to prepare for
>>>> delalloc writeback).  When the file data actually gets written out,
>>>> the worst-case reservation is freed up again.  We also flush and
>>>> switch to nodelalloc when the filesystem is pretty close to full.
>>>> see ext4_nonda_switch() for example.
>>>>
>>>> This looks pretty severe though, more than I would expect
>>>> from that behavior.
>>> This is fixed in commit d330a5bef, which which got merged post
>>> 2.6.34-rc2, and which we need to get into 2.6.33 stable.  If you
>>> cherry-pick that commit, I think you'll see that it fixes this
>>> problem.
>> Oh, right, spaced that one.  Thanks for the reminder Ted.  :)
>>
>> And from now on ext3-mounted-as-ext4 is special-cased so you won't get
>> delalloc, and you won't get this behavior at all (nor will you get
>> any delalloc benefits, FWIW).
>>
> 
> Out of curiosity, when you say ext3-mounted-as-ext4, are you referring
> to filesystems without ext4 features mounted -t ext4, or filesystems
> mounted -t ext3 when CONFIG_EXT4_USE_FOR_EXT23 is defined?

hmmm to be honest i've lost track a little ;)

I was referring to:

commit ba69f9ab7df844125898104e854e063b47c26637
Author: Jan Kara <jack@suse.cz>
Date:   Wed Mar 24 20:18:37 2010 -0400

    ext4: Don't use delayed allocation by default when used instead of ext3
    
    When ext4 driver is used to mount a filesystem instead of the ext3 file
    system driver (through CONFIG_EXT4_USE_FOR_EXT23), do not enable delayed
    allocation by default since some ext3 users and application writers have
    developed unfortunate expectations about the safety of writing files on
    systems subject to sudden and violent death without using fsync().
    
    Signed-off-by: Jan Kara <jack@suse.cz>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

looking at that commit I guess it's -only- when CONFIG_EXT4_USE_FOR_EXT23
is defined.  So in answer to your question above, it's your latter case.

See previous complaint about this all becoming rather confusing....

-Eric


> -Justin

