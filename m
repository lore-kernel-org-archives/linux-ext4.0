From: Saugata Das <saugata.das@linaro.org>
Subject: Re: [PATCH] REQ_META set during meta data write
Date: Fri, 2 Mar 2012 01:34:31 +0530
Message-ID: <CAKLKtzdvdH9aAWRace4-qMgx8_ARMCuD0uSHmOKEniW=PsN7CQ@mail.gmail.com>
References: <1330625463-5683-1-git-send-email-saugata.das@stericsson.com>
	<20120301183327.GA32588@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	arnd.bergmann@linaro.org, adilger@whamcloud.com
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54581 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab2CAUEc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Mar 2012 15:04:32 -0500
Received: by wibhm2 with SMTP id hm2so176461wib.19
        for <linux-ext4@vger.kernel.org>; Thu, 01 Mar 2012 12:04:31 -0800 (PST)
In-Reply-To: <20120301183327.GA32588@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2 March 2012 00:03, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Mar 01, 2012 at 11:41:03PM +0530, Saugata Das wrote:
>> From: Saugata Das <saugata.das@linaro.org>
>>
>> Today, storage devices like eMMC has special features like data tagg=
ing
>> (introduced in MMC-4.5 version) in order to improve performance of s=
ome
>> specific writes. On MMC stack, data tagging is used for all writes w=
hich has
>> REQ_META flag set. On EXT4, however, currently REQ_META is set only =
for read.
>> This patch adds the capability to add REQ_META flag during meta data=
 write.
>> This patch adds new function set_buffer_meta, which is used to set a=
 bit
>> BH_Meta in the b_state field when meta data and super block is made =
dirty.
>>
>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -2926,6 +2926,9 @@ int submit_bh(int rw, struct buffer_head * bh)
>> =A0 =A0 =A0 if (test_set_buffer_req(bh) && (rw & WRITE))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_buffer_write_io_error(bh);
>>
>> + =A0 =A0 if (buffer_meta(bh) && (rw & WRITE))
>> + =A0 =A0 =A0 =A0 =A0 =A0 rw |=3D REQ_META;
>> +
>
> I know it's not necessary for your purposes as stated in the commit
> description, but wouldn't it be better if buffer_meta() always caused
> REQ_META to be set, regardless of whether we are doing a read or a
> write?

Sure, I will modify this in the next version.

>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
