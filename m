From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] ext4: fix checking on nr_to_write
Date: Mon, 14 Oct 2013 21:50:54 +0800
Message-ID: <CACVXFVPpkJdw_AVwd=dRpD8ju6frjaU3QhKorr_PNNGu_D0jAQ@mail.gmail.com>
References: <1381682393-5769-1-git-send-email-ming.lei@canonical.com>
	<20131014125858.GH19604@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131014125858.GH19604@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 14, 2013 at 8:58 PM, Jan Kara <jack@suse.cz> wrote:
>   Umm, I guess I see what are you pointing at. Thanks for catching that.
> mpage_process_page_bufs() always adds a buffer to mpd even if nr_to_write
> is already <= 0. But I would somewhat prefer not to call
> mpage_prepare_extent_to_map() at all when nr_to_write <= 0. So a patch
> like:
>                 ret = mpage_prepare_extent_to_map(&mpd);
>                 if (!ret) {
> -                       if (mpd.map.m_len)
> +                       if (mpd.map.m_len) {
>                                 ret = mpage_map_and_submit_extent(handle, &mpd,
>                                         &give_up_on_write);
> -                       else {
> +                               done = (wbc->nr_to_write <= 0);
> +                       } else {
>
> Should also fix your problem, am I right?

I am afraid it can't, because we need to stop scanning page cache
if end of file is reached.

nr_to_write will become negative inside mpage_map_and_submit_extent(),
that is why I fix it inside mpage_prepare_extent_to_map().


Thanks,
--
Ming Lei
