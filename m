From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] ext4: fix checking on nr_to_write
Date: Tue, 15 Oct 2013 22:53:17 +0800
Message-ID: <CACVXFVOc9tDU-vDCeWHQNi2jLX3Q_wc18hP07P=Jvm9Yiy0hnA@mail.gmail.com>
References: <1381682393-5769-1-git-send-email-ming.lei@canonical.com>
	<20131014125858.GH19604@quack.suse.cz>
	<CACVXFVPpkJdw_AVwd=dRpD8ju6frjaU3QhKorr_PNNGu_D0jAQ@mail.gmail.com>
	<20131014173459.GL19604@quack.suse.cz>
	<20131015102553.22d4a018@tom-ThinkPad-T410>
	<20131015103900.GB12428@quack.suse.cz>
	<20131015191556.50c3eb03@tom-ThinkPad-T410>
	<20131015123439.GC12428@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131015123439.GC12428@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 15, 2013 at 8:34 PM, Jan Kara <jack@suse.cz> wrote:
> On Tue 15-10-13 19:15:56, Ming Lei wrote:
>> >   This won't quite work because if the page is fully mapped
>> > mpage_process_page_bufs() will immediately submit the page and decrease
>> > nr_to_write. So now you would end up writing less than you were asked for
>> > in some cases.
>>
>> Yes, your are right, so how about below?
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 32c04ab..3cf7abb 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -2295,6 +2295,7 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
>>       struct address_space *mapping = mpd->inode->i_mapping;
>>       struct pagevec pvec;
>>       unsigned int nr_pages;
>> +     int left = mpd->wbc->nr_to_write;
>   'long' please. Otherwise the patch looks fine. Thanks!

OK, and I will submit the formal one with you ack.

Thanks,
--
Ming Lei
