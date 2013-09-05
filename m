From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Which features should I implement in my ext4 reader?
Date: Thu, 5 Sep 2013 09:41:53 +0200
Message-ID: <CACyNnZMs8oHkyu2YeZ8WX1279hiESsxPzpSZpF4wwZ6a1uHPgg@mail.gmail.com>
References: <CACyNnZONOUy0+OeDriZaSt4OQrR6LzpyJz4Sj8XvMHvxr2u_Xg@mail.gmail.com>
	<20130819050803.GA10882@gmail.com>
	<CACyNnZN4z_mHq86+FPOaGpzjwBVmmsKNjnd45s53o2LdQjxEsg@mail.gmail.com>
	<20130820103956.GA7846@gmail.com>
	<CACyNnZP6m96Uv_acbVvf3K2UvcMhhqk2S2gmdZS9DG9GwqbUcg@mail.gmail.com>
	<CACyNnZP2SFovG9YeBNeifm4KqrCzi7FU97CWVUjST0YQiqt3pQ@mail.gmail.com>
	<CACyNnZOXOZ-uL+TO8HOuO4DoWsBKuBOX5RLQrZzyoeG1L2a9yg@mail.gmail.com>
	<CACyNnZNhrmcpQRU+JcqSJeUYt3YNpyTyVArW_Jrp3e43owVf5Q@mail.gmail.com>
	<20130902120718.GB1106@gmail.com>
	<CACyNnZNQf6a05zE64KfouuT=dUXaNPT7iqPe8HKT1wXKz+pK0Q@mail.gmail.com>
	<20130904053503.GA3518@gmail.com>
	<CAGW2f1FgHZsQbNMyWiD997UZz55y20qHJHryEcMsgpEwecxftA@mail.gmail.com>
	<CACyNnZPqhBw2q78tfG1npfO5SFt57xahME30h9rZiTnvZnhM+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: jon ernst <jonernst07@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:54405 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607Ab3IEHlx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Sep 2013 03:41:53 -0400
Received: by mail-pa0-f47.google.com with SMTP id kl13so1552307pab.34
        for <linux-ext4@vger.kernel.org>; Thu, 05 Sep 2013 00:41:53 -0700 (PDT)
In-Reply-To: <CACyNnZPqhBw2q78tfG1npfO5SFt57xahME30h9rZiTnvZnhM+A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 5, 2013 at 9:04 AM, Felipe Monteiro de Carvalho
<felipemonteiro.carvalho@gmail.com> wrote:
> Is it to make sure that the block of data starts aligned to 4-bytes?

Hello,

Ok, I just checked here experimentally and it is indeed padding to 4-bytes...

Does the same padding exist if the attribute is in a block as opposed
to being in the space after the inode?

thanks,
-- 
Felipe Monteiro de Carvalho
