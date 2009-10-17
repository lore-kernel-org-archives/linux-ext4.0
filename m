From: Viji V Nair <viji@fedoraproject.org>
Subject: Re: optimising filesystem for many small files
Date: Sat, 17 Oct 2009 23:26:04 +0530
Message-ID: <84c89ac10910171056i773dfb93wc2e917a086dd8ef0@mail.gmail.com>
References: <84c89ac10910162352x5cdeca37icfbf0af2f2325d7c@mail.gmail.com>
	 <4AD9D599.3000306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext3-users@redhat.com, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f171.google.com ([209.85.216.171]:56645 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbZJQR4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Oct 2009 13:56:00 -0400
Received: by pxi1 with SMTP id 1so246181pxi.33
        for <linux-ext4@vger.kernel.org>; Sat, 17 Oct 2009 10:56:04 -0700 (PDT)
In-Reply-To: <4AD9D599.3000306@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

these files are not in a single directory, this is a pyramid
structure. There are total 15 pyramids and coming down from top to
bottom the sub directories and files  are multiplied by a factor of 4.

The IO is scattered all over!!!! and this is a single disk file system.

Since the python application is creating files, it is creating
multiple files to multiple sub directories at a time.

On Sat, Oct 17, 2009 at 8:02 PM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
> Viji V Nair wrote:
>>
>> Hi,
>>
>> System : Fedora 11 x86_64
>> Current Filesystem: 150G ext4 (formatted with "-T small" option)
>> Number of files: 50 Million, 1 to 30K png images
>>
>> We are generating these files using a python programme and getting v=
ery
>> slow IO performance. While generation there in only write, no read. =
After
>> generation there is heavy read and no write.
>>
>> I am looking for best practices/recommendation to get a better
>> performance.
>>
>> Any suggestions of the above are greatly appreciated.
>>
>> Viji
>>
>
> I would start with using blktrace and/or seekwatcher to see what your=
 IO
> patterns look like when you're populating the disk; I would guess tha=
t
> you're seeing IO scattered all over.
>
> How you are placing the files in subdirectories will affect this quit=
e a
> lot; sitting in 1 directory for a while, filling with images, before =
moving
> on to the next directory, will probably help. =A0Putting each new fil=
e in a
> new subdirectory will probably give very bad results.
>
> -Eric
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
