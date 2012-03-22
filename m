From: Saugata Das <saugata.das@linaro.org>
Subject: Re: [PATCH v2] REQ_META set during meta data write
Date: Thu, 22 Mar 2012 16:38:07 +0530
Message-ID: <CAKLKtzcHxabZJHMWK8nmgCL23j7c=bPASgn0bKwAO-tCFRHvYQ@mail.gmail.com>
References: <1330692309-6187-1-git-send-email-saugata.das@stericsson.com>
	<20120303093441.GB8417@infradead.org>
	<CAKLKtzezhmb0ydaWko_r=QZxKfnHx-15pg6tPuw50nbds_tA7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	arnd.bergmann@linaro.org, tytso@mit.edu, adilger@whamcloud.com,
	venkat@linaro.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63076 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab2CVLII convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Mar 2012 07:08:08 -0400
Received: by wejx9 with SMTP id x9so1692730wej.19
        for <linux-ext4@vger.kernel.org>; Thu, 22 Mar 2012 04:08:07 -0700 (PDT)
In-Reply-To: <CAKLKtzezhmb0ydaWko_r=QZxKfnHx-15pg6tPuw50nbds_tA7g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Christoph

On 4 March 2012 13:32, Saugata Das <saugata.das@linaro.org> wrote:
> On 3 March 2012 15:04, Christoph Hellwig <hch@infradead.org> wrote:
>> On Fri, Mar 02, 2012 at 06:15:09PM +0530, Saugata Das wrote:
>>> --- a/fs/buffer.c
>>> +++ b/fs/buffer.c
>>> @@ -2926,6 +2926,9 @@ int submit_bh(int rw, struct buffer_head * bh=
)
>>> =A0 =A0 =A0 if (test_set_buffer_req(bh) && (rw & WRITE))
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_buffer_write_io_error(bh);
>>>
>>> + =A0 =A0 if (buffer_meta(bh))
>>> + =A0 =A0 =A0 =A0 =A0 =A0 rw |=3D REQ_META;
>>> +
>>
>> submit_bh has a perfectly valid rw argument where you can pass REQ_M=
ETA.
>> Please use that instead of abusing a buffer state bit for an I/O
>> submission flag.
>>
>
> Typically, during meta-data writes, the buffer is only marked dirty
> (__ext4_handle_dirty_metadata). The submit_bh of the dirty meta-data
> buffer happens later from writeback thread which in general flushes
> out all the buffers. From this generic handling of dirty buffers from
> writeback thread via generic writepage functions till submit_bh, it i=
s
> not possible to identify whether the buffer was corresponding to any
> meta-data without having an extra information in the buffer itself.

Is the above explanation OK for you ? Or, do you some alternative
suggestion for me to explore ?

Based on your feedback, I shall resubmit the patch on top of 3.4.


regards
saugata
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
