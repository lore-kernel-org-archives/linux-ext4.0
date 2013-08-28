From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Which features should I implement in my ext4 reader?
Date: Wed, 28 Aug 2013 22:09:42 +0200
Message-ID: <CACyNnZOXOZ-uL+TO8HOuO4DoWsBKuBOX5RLQrZzyoeG1L2a9yg@mail.gmail.com>
References: <CACyNnZNJssSL+UWOXYmWk9xy07WRT_z+Fk9Kjwfws9JRfWoNEQ@mail.gmail.com>
	<CACyNnZManY_k3SB1-p4mQ8Z1+9B=VAdfXU7bWsFVHDsHV6KyUQ@mail.gmail.com>
	<20130817130204.GA30769@thunk.org>
	<CACyNnZONOUy0+OeDriZaSt4OQrR6LzpyJz4Sj8XvMHvxr2u_Xg@mail.gmail.com>
	<20130819050803.GA10882@gmail.com>
	<CACyNnZN4z_mHq86+FPOaGpzjwBVmmsKNjnd45s53o2LdQjxEsg@mail.gmail.com>
	<20130820103956.GA7846@gmail.com>
	<CACyNnZP6m96Uv_acbVvf3K2UvcMhhqk2S2gmdZS9DG9GwqbUcg@mail.gmail.com>
	<CACyNnZP2SFovG9YeBNeifm4KqrCzi7FU97CWVUjST0YQiqt3pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:43478 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3H1UJn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Aug 2013 16:09:43 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz10so6675115pad.30
        for <linux-ext4@vger.kernel.org>; Wed, 28 Aug 2013 13:09:43 -0700 (PDT)
In-Reply-To: <CACyNnZP2SFovG9YeBNeifm4KqrCzi7FU97CWVUjST0YQiqt3pQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Any idea where to find the extra data over 60 bytes in a very small
file (for example 120 bytes) would be greatly appreciated ... I
already tried the extra space after the inode but there was nothing
useful there! =/ Or at least nothing that matched the description of
the extended attributes. It should start with a magic number, but
started with many zeroes =/

thanks,

Felipe Monteiro de Carvalho

On Fri, Aug 23, 2013 at 2:54 PM, Felipe Monteiro de Carvalho
<felipemonteiro.carvalho@gmail.com> wrote:
> Hello,
>
> I went forward trying to implement this myself, but I am having trouble.
>
> Files up to 60 bytes work great, and large files too. But a file with
> 61 bytes does not.
>
> Reading ignoring the inline results in zero on all bytes, which can't
> be right, so I guess it is inlined.
>
> After the first 60 bytes I try to get the extended attribute, but
> i_file_acl_lo == FData.l_i_file_acl_high == 0
>
> And I think that it cannot possibly have the extended attribute data
> in block zero =/ (it contains DEADBEEF or something like that)
>
> Any ideas where I got this wrong or any tips about how to figure out
> in debugfs where the data is?
>
> thanks,
> --
> Felipe Monteiro de Carvalho



-- 
Felipe Monteiro de Carvalho
