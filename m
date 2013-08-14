From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Which features should I implement in my ext4 reader?
Date: Wed, 14 Aug 2013 07:06:44 +0200
Message-ID: <CACyNnZManY_k3SB1-p4mQ8Z1+9B=VAdfXU7bWsFVHDsHV6KyUQ@mail.gmail.com>
References: <CACyNnZNJssSL+UWOXYmWk9xy07WRT_z+Fk9Kjwfws9JRfWoNEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:38915 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3HNFGp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Aug 2013 01:06:45 -0400
Received: by mail-pb0-f52.google.com with SMTP id wz12so8738344pbc.39
        for <linux-ext4@vger.kernel.org>; Tue, 13 Aug 2013 22:06:44 -0700 (PDT)
In-Reply-To: <CACyNnZNJssSL+UWOXYmWk9xy07WRT_z+Fk9Kjwfws9JRfWoNEQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Did my last message go through? Just wondering if it was lost ...

thanks,

Felipe Monteiro de Carvalho

On Mon, Aug 12, 2013 at 5:38 PM, Felipe Monteiro de Carvalho
<felipemonteiro.carvalho@gmail.com> wrote:
> Hello,
>
> Thanks to the help here I have essentially finished my ext4 reader =)
> At least it can read ext4 filesystems with these features, which is
> what I found when using Ubuntu and Mageia LInux:
>
>    EXT4_FEATURE_INCOMPAT_JOURNAL_DEV    = $0008; // Journal device */
>    EXT4_FEATURE_INCOMPAT_META_BG        = $0010;
>    EXT4_FEATURE_INCOMPAT_EXTENTS        = $0040; // extents support */
>    EXT4_FEATURE_INCOMPAT_FLEX_BG        = $0200;
>    EXT4_FEATURE_INCOMPAT_64BIT          = $0080;
>
> Some features seam to not require any extra care for my reader:
>
>    EXT4_FEATURE_INCOMPAT_COMPRESSION    = $0001;
>    EXT4_FEATURE_INCOMPAT_FILETYPE       = $0002;
>    EXT4_FEATURE_INCOMPAT_RECOVER        = $0004; // Needs recovery */
>    EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM= $2000; // use crc32c for bg */
>
> But I now wonder about these features:
>
>    EXT4_FEATURE_INCOMPAT_MMP            = $0100;
>    EXT4_FEATURE_INCOMPAT_EA_INODE       = $0400; // EA in inode */
>    EXT4_FEATURE_INCOMPAT_DIRDATA        = $1000; // data in dirent */
>    EXT4_FEATURE_INCOMPAT_LARGEDIR       = $4000; // >2GB or 3-lvl htree */
>    EXT4_FEATURE_INCOMPAT_INLINEDATA     = $8000; // data in inode */
>
> Could anyone comment how common is the use of those features and if
> they are already stable and in production usage (I read that they were
> under development in 2011)?
>
> And also which ones require an active work for a reader application to
> implement. As I already found out that FLEX_BG does not require active
> work to be supported despite being in the INCOMPAT list...
>
> From the description I'm pretty sure that at least DIRDATA and
> INLINEDATA would require adjustments in my software. But I wonder if
> they are already being used and stable, etc, and if it is a good idea
> to work on supporting them.
>
> thanks, =)
> --
> Felipe Monteiro de Carvalho



-- 
Felipe Monteiro de Carvalho
