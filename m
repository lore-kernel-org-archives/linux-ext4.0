From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Which features should I implement in my ext4 reader?
Date: Fri, 23 Aug 2013 14:54:29 +0200
Message-ID: <CACyNnZP2SFovG9YeBNeifm4KqrCzi7FU97CWVUjST0YQiqt3pQ@mail.gmail.com>
References: <CACyNnZNJssSL+UWOXYmWk9xy07WRT_z+Fk9Kjwfws9JRfWoNEQ@mail.gmail.com>
	<CACyNnZManY_k3SB1-p4mQ8Z1+9B=VAdfXU7bWsFVHDsHV6KyUQ@mail.gmail.com>
	<20130817130204.GA30769@thunk.org>
	<CACyNnZONOUy0+OeDriZaSt4OQrR6LzpyJz4Sj8XvMHvxr2u_Xg@mail.gmail.com>
	<20130819050803.GA10882@gmail.com>
	<CACyNnZN4z_mHq86+FPOaGpzjwBVmmsKNjnd45s53o2LdQjxEsg@mail.gmail.com>
	<20130820103956.GA7846@gmail.com>
	<CACyNnZP6m96Uv_acbVvf3K2UvcMhhqk2S2gmdZS9DG9GwqbUcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:50603 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3HWMy3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Aug 2013 08:54:29 -0400
Received: by mail-pb0-f44.google.com with SMTP id xa7so649111pbc.3
        for <linux-ext4@vger.kernel.org>; Fri, 23 Aug 2013 05:54:29 -0700 (PDT)
In-Reply-To: <CACyNnZP6m96Uv_acbVvf3K2UvcMhhqk2S2gmdZS9DG9GwqbUcg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I went forward trying to implement this myself, but I am having trouble.

Files up to 60 bytes work great, and large files too. But a file with
61 bytes does not.

Reading ignoring the inline results in zero on all bytes, which can't
be right, so I guess it is inlined.

After the first 60 bytes I try to get the extended attribute, but
i_file_acl_lo == FData.l_i_file_acl_high == 0

And I think that it cannot possibly have the extended attribute data
in block zero =/ (it contains DEADBEEF or something like that)

Any ideas where I got this wrong or any tips about how to figure out
in debugfs where the data is?

thanks,
-- 
Felipe Monteiro de Carvalho
