From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: [PATCH] ext4: Use an rbtree for tracking blocks freed during
	transaction.
Date: Mon, 19 Jan 2009 12:16:14 -0500
Message-ID: <170fa0d20901190916qf176ec0o6ed2e69add19411@mail.gmail.com>
References: <E1LOG9D-0006h4-7R@closure.thunk.org>
	 <20090119113537.GF9482@skywalker>
	 <170fa0d20901190914n3354bf3w572b65e18c1a00f0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:37136 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbZASRQQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Jan 2009 12:16:16 -0500
Received: by nf-out-0910.google.com with SMTP id d3so426452nfc.21
        for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 09:16:14 -0800 (PST)
In-Reply-To: <170fa0d20901190914n3354bf3w572b65e18c1a00f0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/19/09, Mike Snitzer <snitzer@gmail.com> wrote:
> On 1/19/09, Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> wrote:
>  >
>  >  From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>  >  Subject: [PATCH] ext4: Use an rbtree for tracking blocks freed during transaction.
>  >
>  >  With this patch we track the block freed during a transaction using
>  >  red-black tree.  We also make sure contiguous blocks freed are collected
>  >  in one node in the tree.
>  >
>  >  Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>  >  Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>
>
> Any particular reason for (re)posting this patch?
>
>  This appears to have been committed upstream via commit:
>  c894058d66637c7720569fbe12957f4de64d9991

Ah, sorry I missed the discussion in the "Ext4 tree backports for
2.6.27.10 and 2.6.28" thread.

regards,
Mike
