From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4
Date: Wed, 14 Jul 2010 14:03:04 +0400
Message-ID: <87lj9e7547.fsf@dmon-lap.sw.ru>
References: <1278489212-12110-1-git-send-email-lczerner@redhat.com>
	<1278489212-12110-3-git-send-email-lczerner@redhat.com>
	<87tyo2a2f7.fsf@dmon-lap.sw.ru>
	<alpine.LFD.2.00.1007141101110.2980@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: eshishki@redhat.com, jmoyer@redhat.com, rwheeler@redhat.com,
	linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47646 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab0GNKDN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Jul 2010 06:03:13 -0400
Received: by ewy23 with SMTP id 23so1348814ewy.19
        for <linux-ext4@vger.kernel.org>; Wed, 14 Jul 2010 03:03:12 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1007141101110.2980@localhost> (Lukas Czerner's
	message of "Wed, 14 Jul 2010 11:40:56 +0200 (CEST)")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Lukas Czerner <lczerner@redhat.com> writes:

> On Wed, 14 Jul 2010, Dmitry Monakhov wrote:
>
>> Lukas Czerner <lczerner@redhat.com> writes:
>> 
>> > Walk through each allocation group and trim all free extents. It can be
>> > invoked through TRIM ioctl on the file system. The main idea is to
>> > provide a way to trim the whole file system if needed, since some SSD's
>> > may suffer from performance loss after the whole device was filled (it
>> > does not mean that fs is full!).
>> >
>> > It search fro free extents in each allocation group. When the free
>> > extent is found, blocks are marked as used and then trimmed. Afterwards
>> > these blocks are marked as free in per-group bitmap.
>> Looks ok, except two small notes:
>> 1) trim_fs is a time consuming operation and we have to add
>>    condresced, and signal_pending checks to allow user to interrupt
>>    cmd if necessery. See patch attached.
>
> Hi, Dimitry
>
> thanks for your patch! Although I have one question:
>
>
>  	for (group = 0; group < ngroups; group++) {
> -		int err;
> -
> -		err = ext4_mb_load_buddy(sb, group, &e4b);
> -		if (err) {
> +		ret = ext4_mb_load_buddy(sb, group, &e4b);
> +		if (ret) {
>  			ext4_error(sb, "Error in loading buddy "
>  					"information for %u", group);
> -			continue;
> +			break;
>  		}
>
> Is there really need to jump out from the loop and exit in the case of
> load_buddy failure ? Next group may very well succeed in loading buddy,
> or am I missing something ?
Well, it may fail due to -ENOMEM which is not scary but in some places
it may fail due to EIO which is a very bad sign. So i think it is
slightly dangerous to continue if we have found a same group.
>
>> 2) IMHO runtime trim support is useful sometimes, for example when
>>    user really care about data security i.e. unlinked file should be
>>    trimmed ASAP. I think we have to provide 'secdel' mount option
>>    similar to secdeletion flag for inode, but this is another story
>>    not directly connected with the patch.
>
> I like the idea, but IMO this should work for any underlying storage,
> not just for SSDs.
Off course. We may use blkdev_issue_zeroout() if disk does not support
discard with zeroing.
>
> Thanks!
> -Lukas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
