From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Which features should I implement in my ext4 reader?
Date: Sat, 17 Aug 2013 08:27:12 +0200
Message-ID: <CACyNnZPfFM8s10N=rh20QoEFDtFp+yFuh6sgY=XZ_d77tT1L2A@mail.gmail.com>
References: <CACyNnZNJssSL+UWOXYmWk9xy07WRT_z+Fk9Kjwfws9JRfWoNEQ@mail.gmail.com>
	<CACyNnZManY_k3SB1-p4mQ8Z1+9B=VAdfXU7bWsFVHDsHV6KyUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:32809 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab3HQG1N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Aug 2013 02:27:13 -0400
Received: by mail-pa0-f54.google.com with SMTP id kx10so2706652pab.13
        for <linux-ext4@vger.kernel.org>; Fri, 16 Aug 2013 23:27:12 -0700 (PDT)
In-Reply-To: <CACyNnZManY_k3SB1-p4mQ8Z1+9B=VAdfXU7bWsFVHDsHV6KyUQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I wonder if when    EXT4_FEATURE_INCOMPAT_DIRDATA and
EXT4_FEATURE_INCOMPAT_INLINEDATA are active, will all inodes have the
first part of the data inlined? Or only some? How to know which ones?

Any ideas on this and also about which features are the most important
to implement, how often they are used, how stable their implementation
is, etc would be greatly appreciated =)

thanks,

Felipe Monteiro de Carvalho


On Wed, Aug 14, 2013 at 7:06 AM, Felipe Monteiro de Carvalho
<felipemonteiro.carvalho@gmail.com> wrote:
> Hello,
>
> Did my last message go through? Just wondering if it was lost ...
>
> thanks,
>
> Felipe Monteiro de Carvalho
>
> On Mon, Aug 12, 2013 at 5:38 PM, Felipe Monteiro de Carvalho
> <felipemonteiro.carvalho@gmail.com> wrote:
>> Hello,
>>
>> Thanks to the help here I have essentially finished my ext4 reader =)
>> At least it can read ext4 filesystems with these features, which is
>> what I found when using Ubuntu and Mageia LInux:
>>
>>    EXT4_FEATURE_INCOMPAT_JOURNAL_DEV    = $0008; // Journal device */
>>    EXT4_FEATURE_INCOMPAT_META_BG        = $0010;
>>    EXT4_FEATURE_INCOMPAT_EXTENTS        = $0040; // extents support */
>>    EXT4_FEATURE_INCOMPAT_FLEX_BG        = $0200;
>>    EXT4_FEATURE_INCOMPAT_64BIT          = $0080;
>>
>> Some features seam to not require any extra care for my reader:
>>
>>    EXT4_FEATURE_INCOMPAT_COMPRESSION    = $0001;
>>    EXT4_FEATURE_INCOMPAT_FILETYPE       = $0002;
>>    EXT4_FEATURE_INCOMPAT_RECOVER        = $0004; // Needs recovery */
>>    EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM= $2000; // use crc32c for bg */
>>
>> But I now wonder about these features:
>>
>>    EXT4_FEATURE_INCOMPAT_MMP            = $0100;
>>    EXT4_FEATURE_INCOMPAT_EA_INODE       = $0400; // EA in inode */
>>    EXT4_FEATURE_INCOMPAT_DIRDATA        = $1000; // data in dirent */
>>    EXT4_FEATURE_INCOMPAT_LARGEDIR       = $4000; // >2GB or 3-lvl htree */
>>    EXT4_FEATURE_INCOMPAT_INLINEDATA     = $8000; // data in inode */
>>
>> Could anyone comment how common is the use of those features and if
>> they are already stable and in production usage (I read that they were
>> under development in 2011)?
>>
>> And also which ones require an active work for a reader application to
>> implement. As I already found out that FLEX_BG does not require active
>> work to be supported despite being in the INCOMPAT list...
>>
>> From the description I'm pretty sure that at least DIRDATA and
>> INLINEDATA would require adjustments in my software. But I wonder if
>> they are already being used and stable, etc, and if it is a good idea
>> to work on supporting them.
>>
>> thanks, =)
>> --
>> Felipe Monteiro de Carvalho
>
>
>
> --
> Felipe Monteiro de Carvalho



-- 
Felipe Monteiro de Carvalho
