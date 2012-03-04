From: Saugata Das <saugata.das@linaro.org>
Subject: Re: [PATCH v2] REQ_META set during meta data write
Date: Sun, 4 Mar 2012 13:32:51 +0530
Message-ID: <CAKLKtzezhmb0ydaWko_r=QZxKfnHx-15pg6tPuw50nbds_tA7g@mail.gmail.com>
References: <1330692309-6187-1-git-send-email-saugata.das@stericsson.com>
	<20120303093441.GB8417@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	arnd.bergmann@linaro.org, tytso@mit.edu, adilger@whamcloud.com,
	venkat@linaro.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120303093441.GB8417@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 3 March 2012 15:04, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Mar 02, 2012 at 06:15:09PM +0530, Saugata Das wrote:
>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -2926,6 +2926,9 @@ int submit_bh(int rw, struct buffer_head * bh)
>> =A0 =A0 =A0 if (test_set_buffer_req(bh) && (rw & WRITE))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_buffer_write_io_error(bh);
>>
>> + =A0 =A0 if (buffer_meta(bh))
>> + =A0 =A0 =A0 =A0 =A0 =A0 rw |=3D REQ_META;
>> +
>
> submit_bh has a perfectly valid rw argument where you can pass REQ_ME=
TA.
> Please use that instead of abusing a buffer state bit for an I/O
> submission flag.
>

Typically, during meta-data writes, the buffer is only marked dirty
(__ext4_handle_dirty_metadata). The submit_bh of the dirty meta-data
buffer happens later from writeback thread which in general flushes
out all the buffers. From this generic handling of dirty buffers from
writeback thread via generic writepage functions till submit_bh, it is
not possible to identify whether the buffer was corresponding to any
meta-data without having an extra information in the buffer itself.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
